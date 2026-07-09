import "dart:convert";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/date_time.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/models/currency.dart";

Future<double> getExchangeRate(Currency origin, Currency target,
    {BuildContext? context}) async {
  if (target.id != 140) {
    return await getExchangeRate(origin, const Currency(id: 140)) /
        await getExchangeRate(target, const Currency(id: 140));
  }
  if (origin.id == target.id) return 1;
  final Database db = BudgeteaDatabase.database!;

  Map<String, Object?>? pair = (await db.query("currency_pair",
          where:
              "(currency_origin = ${origin.id} and currency_target = ${target.id}) or (currency_origin = ${target.id} and currency_target = ${origin.id})"))
      .firstOrNull;

  if (pair == null) {
    try {
      final int newId = await db.insert("currency_pair", <String, Object?>{
        "currency_origin": origin.id,
        "currency_target": target.id,
      });
      pair = <String, Object?>{
        "id": newId,
        "currency_origin": origin.id,
        "currency_target": target.id,
      };
    } catch (e) {
      debugPrint("Error inserting currency pair: $e");
      return 1.0;
    }
  }

  final int pairId = pair["id"]?.toInt() ?? 0;

  if (pairId == 0) {
    return 1.0;
  }
  Map<String, Object?>? json = (await db.query(
    "currency_pair_rate",
    where: "currency_pair = $pairId",
    orderBy: "date(date) desc",
    limit: 1,
  ))
      .firstOrNull;
  if (json == null ||
      json["date"] != DateTime.now().onlyDate().toIso8601String()) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.up,
          duration: const Duration(minutes: 5),
          backgroundColor: Colors.grey,
          margin: EdgeInsets.only(
            bottom: 10,
            left: MediaQuery.of(context).size.width - 200,
            right: 8,
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Loading...",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    }
    try {
      if (target.type == CurrencyType.crypto ||
          origin.type == CurrencyType.crypto) {
        await fetchCryptoPrices();
      } else {
        await fetchForexData();
      }
    } catch (e) {
      debugPrint("Error fetching exchange rate from API: $e");
    } finally {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }

    json = (await db.query(
      "currency_pair_rate",
      where: "currency_pair = $pairId",
      orderBy: "date(date) desc",
      limit: 1,
    ))
        .firstOrNull;
  }

  final double? rate = json?["rate"]?.toDouble();
  if (rate == null || rate == 0) {
    return 1;
  }
  if (pair["currency_origin"] == target.id) {
    return 1 / rate;
  }
  return rate;
}

Future<void> fetchCryptoPrices() async {
  final Database db = BudgeteaDatabase.database!;
  final http.Response res = await http.get(Uri.parse(
      "https://api.coinbase.com/v2/exchange-rates?currency=USD"));
  if (res.statusCode != 200) {
    throw Exception("Failed to fetch crypto prices: ${res.statusCode}");
  }
  final Map<String, Object?> json = jsonDecode(res.body);
  final Map<String, dynamic> rates =
      (json["data"] as Map<String, dynamic>)["rates"] as Map<String, dynamic>;

  final List<Map<String, Object?>> cryptoCurrencies =
      await db.query("currency", where: "type = 'CRYPTO'");

  final List<Map<String, Object?>> currencies = await db.query("currency");
  final int usdId = currencies
          .firstWhereOrNull(
              (Map<String, Object?> e) => e["iso"] == "USD")?["id"]
          ?.toInt() ??
      140;

  final Batch batch = db.batch();
  final String dateNow = DateTime.now().onlyDate().toIso8601String();

  for (final Map<String, Object?> crypto in cryptoCurrencies) {
    final String iso = crypto["iso"]?.toString() ?? "";
    if (iso.isEmpty) continue;
    final String? rateStr = rates[iso];
    if (rateStr == null) continue;
    final double? rate = double.tryParse(rateStr);
    if (rate == null || rate == 0.0) continue;

    final int cryptoId = crypto["id"]?.toInt() ?? 0;
    if (cryptoId == 0) continue;

    Map<String, Object?>? pair = (await db.query("currency_pair",
            where:
                "(currency_origin = $usdId and currency_target = $cryptoId) or (currency_origin = $cryptoId and currency_target = $usdId)"))
        .firstOrNull;

    if (pair == null) {
      try {
        final int newId = await db.insert("currency_pair", <String, Object?>{
          "currency_origin": usdId,
          "currency_target": cryptoId,
        });
        pair = <String, Object?>{
          "id": newId,
          "currency_origin": usdId,
          "currency_target": cryptoId,
        };
      } catch (e) {
        debugPrint("Error inserting currency pair: $e");
        continue;
      }
    }

    final int pairId = pair["id"]?.toInt() ?? 0;
    if (pairId == 0) continue;

    batch.insert("currency_pair_rate", <String, Object?>{
      "currency_pair": pairId,
      "rate": rate,
      "date": dateNow,
    });
  }

  await batch.commit(continueOnError: true, noResult: true);
}

Future<void> fetchCryptoCurrencies() async {
  // Coindesk API is deprecated/unauthorized. This is a no-op as it's not used in the app.
}

Future<void> fetchForexData() async {
  final Database db = BudgeteaDatabase.database!;
  http.Response res =
      await http.get(Uri.parse("https://open.er-api.com/v6/latest/USD"));
  final Map<String, Object?> json = jsonDecode(res.body);
  final List<Map<String, Object?>> currencies = await db.query("currency");
  final int usdId = currencies
          .firstWhereOrNull(
              (Map<String, Object?> e) => e["iso"] == "USD")?["id"]
          ?.toInt() ??
      140;
  final List<Map<String, Object?>> list = <Map<String, Object?>>[];

  for (final MapEntry<String, Object?> rates
      in (json["rates"] as Map<String, Object?>).entries) {
    final int target = currencies
            .firstWhereOrNull(
                (Map<String, Object?> e) => e["iso"] == rates.key)?["id"]
            ?.toInt() ??
        0;
    if (target == 0 || target == usdId) {
      continue;
    }

    Map<String, Object?>? pair = (await db.query("currency_pair",
            where:
                "(currency_origin = $usdId and currency_target = $target) or (currency_origin = $target and currency_target = $usdId)"))
        .firstOrNull;

    if (pair == null) {
      try {
        final int newId = await db.insert("currency_pair", <String, Object?>{
          "currency_origin": usdId,
          "currency_target": target,
        });
        pair = <String, Object?>{
          "id": newId,
          "currency_origin": usdId,
          "currency_target": target,
        };
      } catch (e) {
        debugPrint("Error inserting currency pair: $e");
        continue;
      }
    }

    final int pairId = pair["id"]?.toInt() ?? 0;
    if (pairId == 0) continue;

    final String dateNow = DateTime.now().onlyDate().toIso8601String();
    list.add(<String, Object?>{
      "currency_pair": pairId,
      "rate": rates.value?.toDouble() ?? 0.0,
      "date": dateNow
    });
  }

  final Batch batch = db.batch();
  for (final Map<String, Object?> e in list) {
    batch.insert("currency_pair_rate", <String, Object?>{
      "currency_pair": e["currency_pair"],
      "rate": e["rate"],
      "date": e["date"]
    });
  }
  await batch.commit(continueOnError: true);
}
