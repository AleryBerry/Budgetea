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
import "dart:typed_data";
import "package:intl/intl.dart";

class CashFlowDetails extends StatelessWidget {
  const CashFlowDetails({super.key, required this.cashFlow});
  final CashFlow cashFlow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.view_details),
      ),
      body: FutureBuilder<(Currency, Account, Category, String, Uint8List?)?>(
        future: (() async {
          final Database db = BudgeteaDatabase.database!;
          final Map<String, Object?>? currJson = (await db.query(
            "currency",
            where: "id = ${cashFlow.amount.$2}",
            limit: 1,
          )).firstOrNull;
          final Map<String, Object?>? accJson = (await db.query(
            "account",
            where: "id = ${cashFlow.accountId}",
            limit: 1,
          )).firstOrNull;
          final Map<String, Object?>? catJson = (await db.query(
            "cash_flow_category",
            where: "id = ${cashFlow.category}",
            limit: 1,
          )).firstOrNull;
          final Map<String, Object?>? desJson = (await db.query(
            "cash_flow",
            where: "id = ${cashFlow.id}",
            limit: 1,
          )).firstOrNull;

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
            desJson["description_image"] as Uint8List?,
          );
        })(),
        builder: (BuildContext context,
            AsyncSnapshot<(Currency, Account, Category, String, Uint8List?)?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Data not found"));
          }
          
          final Currency currency = snapshot.data!.$1;
          final Account account = snapshot.data!.$2;
          final Category category = snapshot.data!.$3;
          final String description = snapshot.data!.$4;
          final Uint8List? image = snapshot.data!.$5;
          final IconData? iconData = category.getIconData();
          final Color iconColor = HexColor.fromHex(category.iconColor) ?? Colors.grey;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              if (iconData != null) ...<Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: iconColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: iconColor,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          MoneyText(
                            cashFlow: cashFlow,
                            currency: currency,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Account",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      AccountTile(account: account),
                      const SizedBox(height: 16),
                      Text(
                        "Date",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd(AppLocalizations.of(context)!.localeName).add_jm().format(cashFlow.date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (description.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.description,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                      if (image != null && image.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
