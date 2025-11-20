import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/main.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/utils/currency_fetch.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sqflite/sqflite.dart";

Future<(Currency, double, double, double)> getWinsAndLosses(
    {BuildContext? context, DateTimeRange? range, int? accountId}) async {
  final Database db = BudgeteaDatabase.database!;
  final int? accId =
      accountId ?? (await SharedPreferences.getInstance()).getInt("main_account");
  late final String request;
  if (range != null) {
    request = """select coalesce(sum(amount), 0) as total, 
coalesce(sum(case when amount >= 0.0 then amount else 0.0 end), 0) as earnings,
coalesce(sum(case when amount < 0.0 then amount else 0.0 end), 0) as expenditures,
account,
currency
from cash_flow
where ((account = $accId) OR (NOT EXISTS (SELECT 1 FROM account WHERE id = $accId))) AND (date < '${range.end}' AND date > '${range.start}')
group by currency""";
  } else {
    request = """select coalesce(sum(amount), 0) as total, 
coalesce(sum(case when amount >= 0.0 then amount else 0.0 end), 0) as earnings,
coalesce(sum(case when amount < 0.0 then amount else 0.0 end), 0) as expenditures,
account,
currency
from cash_flow
where (account = $accId) OR (NOT EXISTS (SELECT 1 FROM account WHERE id = $accId))
group by currency""";
  }

  final List<Map<String, Object?>> json = await db.rawQuery(request);
  if (json.isEmpty) {}
  double total = 0.0;
  double earnings = 0.0;
  double expenditures = 0.0;
  int prefsId =
      (await SharedPreferences.getInstance()).getInt("main_currency") ?? 140;

  for (final Map<String, Object?> val in json) {
    final Database db = BudgeteaDatabase.database!;
    final Currency currency = Currency.fromJson(
        (await db.query("currency", where: "id = ${val['currency']}")).first);
    double rate = 1;
    if (context != null && context.mounted) {
      rate = (await getExchangeRate(
        currency,
        Currency(id: prefsId),
        context: context,
      ));
    } else {
      rate = (await getExchangeRate(
        currency,
        Currency(id: prefsId),
      ));
    }
    total += (val["total"]!.toDouble()) * rate;
    earnings += val["earnings"]!.toDouble() * rate;
    expenditures += val["expenditures"]!.toDouble() * rate;
  }
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(
      reason: SnackBarClosedReason.timeout,
    );
  }
  final Map<String, Object?>? currJson =
      (await db.query("currency", where: "id = $prefsId")).firstOrNull;
  if (currJson == null) {
    return (
      const Currency(id: 140, decimalPoints: 2, iso: "USD"),
      total,
      earnings,
      expenditures
    );
  } else {
    return (Currency.fromJson(currJson), total, earnings, expenditures);
  }
}

class Balance extends StatelessWidget {
  Balance({super.key, this.accountId});
  final int? accountId;

  final DataRequest<(Currency, double, double, double)> snapshot =
      DataRequest<(Currency, double, double, double)>(
          (const Currency(), 0, 0, 0));

  void fetchData({BuildContext? context, DateTimeRange? range}) async {
    snapshot.fetched = true;
    snapshot.replace(await getWinsAndLosses(
        context: context, range: range, accountId: accountId));
  }

  @override
  Widget build(BuildContext context) {
    if (!snapshot.fetched) {
      fetchData(context: context);
    }

    return ListenableBuilder(
      listenable: snapshot,
      builder: (BuildContext context, Widget? _) {
        final NumberFormat format =
            Constants.formatterCompact(snapshot.data.$1).format;
        format.significantDigitsInUse = true;
        format.minimumSignificantDigitsStrict = true;
        format.minimumSignificantDigits = 2;
        format.minimumFractionDigits = 2;
        format.minimumSignificantDigits = 3;
        String formatter(double amount) {
          final String sym = snapshot.data.$1.symbol.isNotEmpty
              ? snapshot.data.$1.symbol
              : snapshot.data.$1.iso;

          final String val = format.format(amount);
          if (snapshot.data.$1.symbolOnLeft) {
            return "$sym$val";
          } else {
            return "$val $sym";
          }
        }

        return Column(
          children: <Widget>[
            Text(
              formatter(snapshot.data.$2),
              style: TextStyle(
                fontSize: 70.0 -
                    (((format.format(snapshot.data.$2).length) - 0) * 2)
                        .roundToDouble(),
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              children: <Widget>[
                const Spacer(flex: 6),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: Colors.green[400],
                    ),
                    Text(
                      formatter(snapshot.data.$3),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: Colors.red[400],
                    ),
                    Text(
                      formatter(snapshot.data.$4),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(flex: 6),
              ],
            ),
          ],
        );
      },
    );
  }
}
