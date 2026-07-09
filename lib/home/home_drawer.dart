import 'package:flutter/material.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/models/account.dart';
import 'package:my_app/models/currency.dart';
import 'package:my_app/models/category.dart';
import 'package:my_app/models/constants.dart';
import 'package:my_app/screens/transaction/dropdown_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/data_base/budgetea_database.dart';
import 'package:my_app/screens/accounts/accounts.dart';
import 'package:my_app/screens/transaction/cashflow_add.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_tree),
            title: Text(AppLocalizations.of(context)!.set_main_account),
            onTap: () => accountSelector(context).then(
              (Account? account) async {
                if (account != null) {
                  (await SharedPreferences.getInstance())
                      .setInt(PreferencesKeys.mainAccount, account.id);
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text(AppLocalizations.of(context)!.set_main_currency),
            onTap: () async {
              final Currency? currency = await showDialog<Currency>(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: DropDownCustom<Currency>(
                      label: AppLocalizations.of(context)!.currency,
                      table: "currency",
                      getType: (List<Map<String, Object?>> json) =>
                          json.map(Currency.fromJson).toList(),
                      onSelected: (Currency currency) {
                        Navigator.pop(context, currency);
                      },
                      child: (Currency element) => Row(
                        children: <StatelessWidget?>[
                          element.logoUrl.isEmpty
                              ? null
                              : CachedNetworkImage(
                                  imageUrl: element.logoUrl,
                                  width: 22,
                                  height: 22,
                                ),
                          Text(
                              "${element.type.toString() == 'CRYPTO' ? "" : element.getEmoji()} ${element.name} (${element.iso})"),
                        ].nonNulls.toList(),
                      ),
                    ),
                  );
                },
              );
              if (currency == null) return;
              (await SharedPreferences.getInstance())
                  .setInt(PreferencesKeys.mainCurrency, currency.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.category_list),
            onTap: () async {
              final List<CategoryWithUsage> categories =
                  await BudgeteaDatabase.database!.getCategoriesWithUsageCount();
              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(AppLocalizations.of(context)!.category_list),
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final CategoryWithUsage category = categories[index];
                            final IconData? iconData = category.getIconData();
                            final Color? iconColor = category.getIconColor();
                            return ListTile(
                              leading: iconData != null
                                  ? Icon(iconData, color: iconColor)
                                  : null,
                              title: Text(category.name),
                              trailing: Text(category.transactionCount.toString()),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
