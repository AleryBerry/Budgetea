import "dart:convert";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/date_time.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/models/currency.dart";
import "package:sqflite/sqflite.dart";

Future<double> getExchangeRate(Currency origin, Currency target,
    {BuildContext? context}) async {
  if (target.id != 140) {
    return await getExchangeRate(origin, const Currency(id: 140)) /
        await getExchangeRate(target, const Currency(id: 140));
  }
  if (origin.id == target.id) return 1;
  final Database db = BudgeteaDatabase.database!;

  final Map<String, Object?>? pair = (await db.query("currency_pair",
          where:
              "(currency_origin = ${origin.id} and currency_target = ${target.id}) or (currency_origin = ${target.id} and currency_target = ${origin.id})"))
      .firstOrNull;
  final int pairId = pair?["id"]?.toInt() ?? 0;

  if (pairId == 0) {
    return 0.0;
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
    if (target.type == CurrencyType.crypto ||
        origin.type == CurrencyType.crypto) {
      await fetchCryptoPrices();
    } else {
      await fetchForexData();
    }

    json = (await db.query(
      "currency_pair_rate",
      where: "currency_pair = $pairId",
      orderBy: "date",
      limit: 1,
    ))
        .firstOrNull;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  final double? rate = json?["rate"]?.toDouble();
  if (rate == null || rate == 0) {
    return 1;
  }
  if (pair!["currency_origin"] == target.id) {
    return 1 / rate;
  }
  return rate;
}

Future<void> fetchCryptoPrices() async {
  final Database db = BudgeteaDatabase.database!;
  http.Response res = await http.get(Uri.parse(
      "https://data-api.coindesk.com/asset/v1/top/list?page=1&page_size=20&sort_by=CIRCULATING_MKT_CAP_USD&sort_direction=DESC&groups=ID,BASIC,PRICE&toplist_quote_asset=USD&asset_type=BLOCKCHAIN"));
  final Map<String, Object?> json = jsonDecode(res.body);
  List<dynamic> cryptos = (json["Data"] as Map<String, dynamic>)["LIST"];
  dynamic prueba = cryptos.map(
    (dynamic e) async {
      final int crypto =
          (await db.query("currency", where: "iso = '${e['SYMBOL']}'"))
                  .firstOrNull?["id"]
                  ?.toInt() ??
              0;

      return (
        (await db.query("currency_pair", where: "currency_target = $crypto"))
            .firstOrNull?["id"],
        e,
      );
    },
  );
  final List<(dynamic, dynamic)> e = await Future.wait(prueba);
  final Batch batch = db.batch();
  for (final (Object?, dynamic) a in e) {
    batch.insert("currency_pair_rate", <String, Object?>{
      "currency_pair": a.$1,
      "rate": 1 / a.$2["PRICE_USD"],
      "date": DateTime.now().onlyDate().toIso8601String()
    });
  }
  await batch.commit(continueOnError: true, noResult: true);
}

Future<void> fetchCryptoCurrencies() async {
  final Database db = BudgeteaDatabase.database!;
  http.Response res = await http.get(Uri.parse(
      "https://data-api.coindesk.com/asset/v1/top/list?page=1&page_size=20&sort_by=CIRCULATING_MKT_CAP_USD&sort_direction=DESC&groups=ID,BASIC,PRICE&toplist_quote_asset=USD&asset_type=BLOCKCHAIN"));
  final Map<String, Object?> json = jsonDecode(res.body);
  final List<Map<String, Object?>> currencies = await db.query("currency");
  final int usdId = currencies
          .firstWhereOrNull(
              (Map<String, Object?> e) => e["iso"] == "USD")?["id"]
          ?.toInt() ??
      0;
  final List<dynamic> cryptos = (json["Data"] as Map<dynamic, dynamic>)["LIST"];
  String query = """BEGIN TRANSACTION;
${cryptos.map((dynamic e) => "INSERT OR IGNORE INTO currency(name, iso, type, logo_url, decimal_points) VALUES('${e['NAME']}', '${e['SYMBOL']}', 'CRYPTO', '${e['LOGO_URL']}', ${e['ASSET_DECIMAL_POINTS']});").join("\n")}
COMMIT;""";
  await db.rawInsert(query);
  final List<Map<String, Object?>> crypto =
      await db.query("currency", where: "type = 'CRYPTO'");
  query = """BEGIN TRANSACTION;
${crypto.map((Map<String, Object?> e) => "INSERT INTO currency_pair(currency_origin, currency_target) VALUES($usdId, ${e['id']});").join("\n")}
COMMIT;""";
  await db.rawInsert(query);
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
      0;
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
    final int? pair = (await db.query("currency_pair",
            where:
                "(currency_origin = $usdId and currency_target = $target) or (currency_origin = $target and currency_target = $usdId)"))
        .first["id"]
        ?.toInt();
    final String dateNow = DateTime.now().onlyDate().toIso8601String();
    list.add(<String, Object?>{
      "currency_pair": pair,
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
