import "package:animated_tree_view/tree_view/tree_node.dart";
import "package:animated_tree_view/tree_view/tree_view.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_iconpicker/Serialization/icondata_serialization.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/constants.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/account_creation.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/category/category.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:my_app/screens/transaction/searchable_dropdown.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Future<Account?> accountSelector(BuildContext context) async {
  final DataRequest<TreeNode<Account>> snapshot =
      DataRequest<TreeNode<Account>>(await fullAccountTree());
  if (!context.mounted) return null;
  return await showDialog<Account>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: AccountsTree(
                  snapshot: snapshot,
                  widget: (TreeNode<Account> item, _) {
                    return AccountTile(
                      account: item.data!,
                      onTap: () => Navigator.pop(context, item.data!),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    if (await Navigator.push<bool>(
                          context,
                          PageRouteBuilder<bool>(
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) {
                              const Offset begin = Offset(0.0, 1.0);
                              const Offset end = Offset.zero;
                              const Cubic curve = Curves.ease;

                              Animatable<Offset> tween =
                                  Tween<Offset>(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child);
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> _, Animation<double> __) {
                              return const AccountCreation();
                            },
                          ),
                        ) ??
                        false) {
                      snapshot.replace(await fullAccountTree());
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.create_account),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<TreeNode<Account>> fullAccountTree() async {
  Database db = BudgeteaDatabase.database!;
  List<Map<String, Object?>> json = await db.query("account_roots");
  return TreeNode<Account>.root()
    ..addAll(
      await Future.wait(
        json.map(
          (Map<String, Object?> e) async {
            final Account acc = Account.fromJson(e);
            return TreeNode<Account>(
              key: acc.id.toString(),
              data: acc,
            )..addAll(
                (await Account.getAccountChildren(e["id"]?.toInt() ?? 1)).map(
                  (Account e) => TreeNode<Account>(
                    key: e.id.toString(),
                    data: e,
                  ),
                ),
              );
          },
        ),
      ),
    );
}

class AccountFormSelector extends FormField<Account> {
  AccountFormSelector({
    super.key,
    required this.onSelected,
    required this.noSelectedTitle,
    required this.widget,
    required this.selectText,
    required this.selectedWidget,
    super.validator,
  }) : super(
          autovalidateMode: AutovalidateMode.disabled,
          enabled: true,
          builder: (FormFieldState<Account> field) {
            void onPressed(BuildContext context) async {
              accountSelector(context).then((Account? temp) {
                if (temp != null) {
                  field.didChange(temp);
                  field.validate();
                  onSelected(temp);
                }
              });
            }

            return field.value == null
                ? Builder(builder: (BuildContext context) {
                    return Column(
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Durations.short2,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: field.errorText == null
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(context).colorScheme.error,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: ListTile(
                            title: noSelectedTitle,
                            trailing: TextButton(
                              onPressed: () => onPressed(context),
                              child: Text(selectText),
                            ),
                          ),
                        ),
                        if (field.errorText != null)
                          Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    );
                  })
                : Builder(
                    builder: (BuildContext context) {
                      return selectedWidget(onPressed, context);
                    },
                  );
          },
        );

  final void Function(Account) onSelected;
  final Widget noSelectedTitle;
  final Widget Function(
          TreeNode<Account>, TreeViewController<Account, TreeNode<Account>>?)
      widget;
  final Widget Function(void Function(BuildContext), BuildContext)
      selectedWidget;
  final String selectText;
}

class CashFlowForm extends StatelessWidget {
  CashFlowForm({
    super.key,
    required this.type,
  });
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TransactionType type;
  final TextEditingController amount = TextEditingController();
  final ValueNotifier<Currency?> currency = ValueNotifier<Currency?>(null);
  final ValueNotifier<Account?> accountListenable =
      ValueNotifier<Account?>(null);
  final ValueNotifier<Category?> category = ValueNotifier<Category?>(null);

  @override
  Widget build(BuildContext context) {
    final TextEditingController amount = TextEditingController();
    final TextEditingController description = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.add_cash_flow),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: <Widget>[
              ValueListenableBuilder<Account?>(
                valueListenable: accountListenable,
                builder: (BuildContext context, Account? account, Widget? _) {
                  return AccountFormSelector(
                    validator: (Account? account) {
                      if (account == null) {
                        return AppLocalizations.of(context)!
                            .no_account_selected;
                      }
                      return null;
                    },
                    selectText: AppLocalizations.of(context)!.select_account,
                    noSelectedTitle:
                        Text(AppLocalizations.of(context)!.no_account_selected),
                    onSelected: (Account acc) => accountListenable.value = acc,
                    selectedWidget: (void Function(BuildContext) func,
                            BuildContext context) =>
                        AccountTile(
                      account: account ?? const Account(),
                      onTap: () => func(context),
                      margin: EdgeInsets.zero,
                    ),
                    widget: (TreeNode<Account> item,
                        TreeViewController<Account, TreeNode<Account>>? tree) {
                      if (item.data == accountListenable.value) {
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
                  );
                },
              ),
              DropDownCustom<Category>(
                label: AppLocalizations.of(context)!.category,
                table: "cash_flow_category",
                getType: (List<Map<String, Object?>> json) =>
                    json.map(Category.fromJson).toList(),
                validator: (_) {
                  if (category.value == null) {
                    return AppLocalizations.of(context)!.select_a_category;
                  }
                  return null;
                },
                child: (Category category) {
                  return Row(
                    children: <Widget>[
                      Icon(
                        deserializeIcon(<String, Object?>{
                          "key": category.iconName,
                          "pack": category.iconPack
                        })?.data,
                        color: HexColor.fromHex(category.iconColor),
                      ),
                      Text(category.name),
                    ],
                  );
                },
                onSelected: (Category newCategory) =>
                    category.value = newCategory,
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
              ValueListenableBuilder<Currency?>(
                  valueListenable: currency,
                  builder: (BuildContext context, Currency? currencyValue,
                      Widget? _) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: SearchableDropDown<Currency>(
                            label: AppLocalizations.of(context)!.currency,
                            table: "currency",
                            getType: (List<Map<String, Object?>> json) =>
                                json.map(Currency.fromJson).toList(),
                            onSelected: (Currency? newCurrency) {
                              currency.value = newCurrency;
                            },
                            validator: (_) {
                              if (currencyValue == null) {
                                return AppLocalizations.of(context)!
                                    .select_a_currency;
                              }
                              return null;
                            },
                            child: (Currency element) => ListTile(
                              leading: element.logoUrl.isEmpty
                                  ? null
                                  : CachedNetworkImage(
                                      imageUrl: element.logoUrl,
                                      width: 22,
                                      height: 22,
                                    ),
                              title: Text(
                                "${element.type == CurrencyType.crypto ? "" : element.getEmoji()} ${element.name} (${element.iso})",
                                maxLines: 3,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (BuildContext context) {
                              final CurrencyTextInputFormatter formatter =
                                  Constants.formatter(currencyValue);
                              amount.text = formatter.formatString(amount.text);
                              return TextFormField(
                                textAlign: TextAlign.end,
                                validator: (String? value) {
                                  if (formatter.getDouble() <= 0) {
                                    return AppLocalizations.of(context)!
                                        .empty_number;
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  formatter
                                ],
                                controller: amount,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: false,
                                ),
                                decoration: InputDecoration(
                                  suffix: currencyValue == null
                                      ? null
                                      : Text(currencyValue.iso),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
              TextFormField(
                maxLength: 300,
                controller: description,
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
            if (!formKey.currentState!.validate()) {
              return;
            }
            final Database db = BudgeteaDatabase.database!;
            db.insert("cash_flow", <String, Object?>{
              "date": DateTime.now().toIso8601String(),
              "amount": (type == TransactionType.gasto ? -1 : 1) *
                  (NumberFormat.simpleCurrency().parse(amount.text)),
              "account": accountListenable.value!.id,
              "currency": currency.value!.id,
              "description": description.text,
              "category": category.value!.id,
            });
            Navigator.pop(context, true);
          },
          child: const Text("Aceptar"),
        ),
      ),
    );
  }
}
