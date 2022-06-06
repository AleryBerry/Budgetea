import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/home/budget_card.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/cash_flow.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:sqflite/sqlite_api.dart";

class CashFlowDetails extends StatelessWidget {
  const CashFlowDetails({super.key, required this.cashFlow});
  final CashFlow cashFlow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_cash_flow),
      ),
      body: FutureBuilder<(Currency, Account, Category, String)?>(
        future: (() async {
          final Database db = BudgeteaDatabase.database!;
          final Map<String, Object?>? currJson = ((await db.query(
            "currency",
            where: "id = ${cashFlow.amount.$2}",
            limit: 1,
          ))
              .firstOrNull);
          final Map<String, Object?>? accJson = (await db.query(
            "account",
            where: "id = ${cashFlow.accountId}",
            limit: 1,
          ))
              .firstOrNull;
          final Map<String, Object?>? catJson = (await db.query(
            "cash_flow_category",
            where: "id = ${cashFlow.category}",
            limit: 1,
          ))
              .firstOrNull;
          final Map<String, Object?>? desJson = (await db.query(
            "cash_flow",
            where: "id = ${cashFlow.id}",
            limit: 1,
          ))
              .firstOrNull;

          if (accJson == null ||
              currJson == null ||
              catJson == null ||
              desJson == null) {
            return null;
          }
          return (
            Currency.fromJson(currJson),
            Account.fromJson(accJson),
            Category.fromJson(catJson),
            desJson["description"]?.toString() ?? "",
          );
        })(),
        builder: (BuildContext context,
            AsyncSnapshot<(Currency, Account, Category, String)?> snapshot) {
          final IconData? iconData = snapshot.data?.$3.getIconData();
          return Column(
            children: <Widget>[
              AccountTile(account: snapshot.data?.$2 ?? const Account()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <StatelessWidget?>[
                      iconData == null
                          ? null
                          : Icon(
                              iconData,
                              color:
                                  HexColor.fromHex(snapshot.data?.$3.iconColor),
                            ),
                      Text(snapshot.data!.$3.name),
                    ].nonNulls.toList(),
                  ),
                  MoneyText(
                    cashFlow: cashFlow,
                    currency: snapshot.data?.$1,
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.description),
                    Text(snapshot.data!.$4),
                    Text(cashFlow.date.toIso8601String())
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
