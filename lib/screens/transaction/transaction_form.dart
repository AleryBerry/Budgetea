import "package:animated_tree_view/tree_view/tree_node.dart";
import "package:animated_tree_view/tree_view/tree_view.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:collection/collection.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/category/category.dart";
import "package:my_app/screens/transaction/cashflow_add.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class TransactionForm extends StatelessWidget {
  TransactionForm({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Category? category;
    final ValueNotifier<Currency?> currency = ValueNotifier<Currency?>(null);
    final ValueNotifier<Account?> accountListenableOrigin =
        ValueNotifier<Account?>(null);
    final ValueNotifier<Account?> accountListenableTarget =
        ValueNotifier<Account?>(null);
    final TextEditingController amount = TextEditingController();
    bool isValid = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.add_transfer),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.origin_account),
                  ValueListenableBuilder<Account?>(
                    valueListenable: accountListenableOrigin,
                    builder:
                        (BuildContext context, Account? account, Widget? _) {
                      return AccountFormSelector(
                        validator: (Account? val) {
                          if (val == null) {
                            return AppLocalizations.of(context)!.select_account;
                          }
                          return null;
                        },
                        selectText:
                            AppLocalizations.of(context)!.select_account,
                        selectedWidget: (void Function(BuildContext) func,
                            BuildContext context) {
                          return AccountTile(
                            account: account ?? const Account(),
                            onTap: () => func(context),
                          );
                        },
                        noSelectedTitle: Text(
                            AppLocalizations.of(context)!.no_account_selected),
                        widget: (TreeNode<Account> item,
                            TreeViewController<Account, TreeNode<Account>>?
                                tree) {
                          if (item.data == accountListenableOrigin.value ||
                              item.data == accountListenableTarget.value) {
                            return AccountTile(
                              account: item.data!,
                              selected: true,
                            );
                          }
                          return AccountTile(
                            account: item.data!,
                            onTap: item.data?.canReceiveCashFlow ?? false
                                ? () {
                                    Navigator.pop(
                                      context,
                                      item.data,
                                    );
                                  }
                                : null,
                          );
                        },
                        onSelected: (Account acc) {
                          accountListenableOrigin.value = acc;
                        },
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.target_account),
                  ValueListenableBuilder<Account?>(
                    valueListenable: accountListenableTarget,
                    builder:
                        (BuildContext context, Account? account, Widget? _) {
                      return AccountFormSelector(
                        validator: (Account? val) {
                          if (val == null) {
                            return AppLocalizations.of(context)!.select_account;
                          }
                          return null;
                        },
                        selectText:
                            AppLocalizations.of(context)!.select_account,
                        selectedWidget: (void Function(BuildContext) func,
                            BuildContext context) {
                          return AccountTile(
                            account: account ?? const Account(),
                            onTap: () => func(context),
                          );
                        },
                        noSelectedTitle: Text(
                            AppLocalizations.of(context)!.no_account_selected),
                        widget: (TreeNode<Account> item,
                            TreeViewController<Account, TreeNode<Account>>?
                                tree) {
                          if (item.data == accountListenableOrigin.value ||
                              item.data == accountListenableTarget.value) {
                            return AccountTile(
                              account: item.data!,
                              selected: true,
                            );
                          }
                          return AccountTile(
                            account: item.data!,
                            onTap: item.data?.canReceiveCashFlow ?? false
                                ? () {
                                    Navigator.pop(
                                      context,
                                      item.data,
                                    );
                                  }
                                : null,
                          );
                        },
                        onSelected: (Account acc) =>
                            accountListenableTarget.value = acc,
                      );
                    },
                  ),
                ],
              ),
              DropDownCustom<Category>(
                label: AppLocalizations.of(context)!.category,
                table: "cash_flow_category",
                getType: (List<Map<String, Object?>> json) =>
                    json.map(Category.fromJson).toList(),
                validator: (_) {
                  if (category == null) {
                    return AppLocalizations.of(context)!.select_a_category;
                  }
                  return null;
                },
                onSelected: (Category newCategory) => category = newCategory,
                onAdd: () async =>
                    await Navigator.push<bool>(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (BuildContext context) =>
                            const CategoryCreation(),
                      ),
                    ) ??
                    false,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropDownCustom<Currency>(
                      label: AppLocalizations.of(context)!.currency,
                      table: "currency",
                      getType: (List<Map<String, Object?>> json) =>
                          json.map(Currency.fromJson).toList(),
                      onSelected: (Currency newCurrency) =>
                          currency.value = newCurrency,
                      validator: (Currency? currency) {
                        if (currency == null) {
                          return AppLocalizations.of(context)!
                              .select_a_currency;
                        }
                        if (!isValid) {
                          return AppLocalizations.of(context)!
                              .account_doesnt_own_currency;
                        }
                        return null;
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
                              "${element.type == CurrencyType.crypto ? "" : element.getEmoji()} ${element.name} (${element.iso})"),
                        ].nonNulls.toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Currency?>(
                      valueListenable: currency,
                      builder: (BuildContext context, Currency? currency,
                          Widget? _) {
                        final CurrencyTextInputFormatter formatter =
                            Constants.formatter(currency);
                        amount.text = formatter.formatString(amount.text);
                        return TextFormField(
                          textAlign: TextAlign.end,
                          validator: (String? value) {
                            if (formatter.getDouble() <= 0) {
                              return AppLocalizations.of(context)!.empty_number;
                            }
                            if (currency == null) {
                              return AppLocalizations.of(context)!
                                  .select_a_currency;
                            }
                            if (formatter.getDouble() > 0) {}
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[formatter],
                          controller: amount,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                            suffix:
                                currency == null ? null : Text(currency.iso),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                maxLength: 300,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.description,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            final num amt = (NumberFormat.simpleCurrency().parse(amount.text));
            final (Currency, double)? wot = (await accountListenableOrigin.value
                    ?.getTotals())
                ?.firstWhereOrNull(
                    ((Currency, double) e) => e.$1.id == currency.value?.id);
            if (wot != null && wot.$2 >= amt) {
              isValid = true;
            }
            if (!formKey.currentState!.validate()) {
              return;
            }
            final Database db = BudgeteaDatabase.database!;
            final Batch batch = db.batch();
            batch.insert("cash_flow", <String, Object?>{
              "date": DateTime.now().toIso8601String(),
              "account": accountListenableOrigin.value!.id,
              "currency": currency.value!.id,
              "category": category!.id,
              "amount": -amt,
            });
            batch.insert("cash_flow", <String, Object?>{
              "date": DateTime.now().toIso8601String(),
              "account": accountListenableTarget.value!.id,
              "currency": currency.value!.id,
              "category": category!.id,
              "amount": amt,
            });

            final List<int> ids = (await batch.commit(continueOnError: false))
                .map((Object? e) => e?.toInt() ?? 0)
                .toList();

            await db.insert("transfer", <String, Object?>{
              "cash_flow_origin": ids[0],
              "cash_flow_target": ids[1],
            });
            if (!context.mounted) return;
            Navigator.pop(context, true);
          },
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ),
    );
  }
}
