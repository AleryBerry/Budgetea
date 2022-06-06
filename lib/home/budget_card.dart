import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/extension_methods/date_time.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/cash_flow.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/currency.dart";
import "package:sqflite/sqflite.dart";

class CashFlowCard extends StatelessWidget {
  const CashFlowCard(this.cashFlow, {this.onTap, this.onLongPress, super.key});
  final CashFlow cashFlow;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: FutureBuilder<(Currency, Account, Category)?>(
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
          if (accJson == null || currJson == null || catJson == null) {
            return null;
          }
          return (
            Currency.fromJson(currJson),
            Account.fromJson(accJson),
            Category.fromJson(catJson)
          );
        })(),
        builder: (BuildContext context,
            AsyncSnapshot<(Currency, Account, Category)?> snapshot) {
          final IconData? iconData = snapshot.data?.$3.getIconData();

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            isThreeLine: false,
            leading: iconData == null
                ? null
                : Icon(
                    iconData,
                    color: HexColor.fromHex(snapshot.data?.$3.iconColor),
                  ),
            title: Text(
              snapshot.data?.$2.name ?? "",
            ),
            subtitle: Text(
                "${cashFlow.date.formatStandardWithTime()}\n${snapshot.data?.$3.name ?? ""}"),
            trailing: MoneyText(
              cashFlow: cashFlow,
              currency: snapshot.data?.$1,
            ),
            focusColor: Colors.red,
            onTap: onTap,
            onLongPress: onLongPress,
          );
        },
      ),
    );
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText({
    super.key,
    required this.cashFlow,
    required this.currency,
  });

  final CashFlow cashFlow;
  final Currency? currency;

  @override
  Widget build(BuildContext context) {
    final NumberFormat format = Constants.formatter(currency).format;
    format.significantDigitsInUse = true;
    format.minimumSignificantDigitsStrict = true;
    format.minimumSignificantDigits = 2;
    format.minimumFractionDigits = 2;
    format.minimumSignificantDigits = 3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget?>[
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: <InlineSpan>[
              TextSpan(
                style: TextStyle(
                  color: cashFlow.amount.$1 < 0 ? null : Colors.green[300],
                  fontSize: 20.0 -
                      (((format.format(cashFlow.amount.$1).length) - 2) * 0.8)
                          .roundToDouble(),
                ),
                text:
                    "${cashFlow.amount.$1 > 0 ? "+" : ""}${format.format(cashFlow.amount.$1)}",
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: currency?.iso ?? "",
              ),
            ],
          ),
        ),
        currency == null
            ? null
            : Tooltip(
                message: currency!.name,
                child: currency!.type == CurrencyType.crypto
                    ? CachedNetworkImage(
                        imageUrl: currency!.logoUrl,
                        width: 40,
                        height: 40,
                      )
                    : SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            currency!.getEmoji(),
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
              ),
      ].nonNulls.toList(),
    );
  }
}
