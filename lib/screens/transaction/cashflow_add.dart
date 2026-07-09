import "dart:typed_data";
import "package:animated_tree_view/tree_view/tree_node.dart";
import "package:animated_tree_view/tree_view/tree_view.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_iconpicker/Serialization/icondata_serialization.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/cash_flow.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/constants.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/account_creation.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/category/category.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:my_app/screens/transaction/searchable_dropdown.dart";

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

class CashFlowForm extends StatefulWidget {
  const CashFlowForm({
    super.key,
    required this.type,
    this.cashFlow,
  });

  final TransactionType type;
  final CashFlow? cashFlow;

  @override
  State<CashFlowForm> createState() => _CashFlowFormState();
}

class _CashFlowFormState extends State<CashFlowForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final ValueNotifier<Currency?> _currencyListenable;
  late final ValueNotifier<Account?> _accountListenable;
  late final ValueNotifier<Category?> _categoryListenable;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _currencyListenable = ValueNotifier<Currency?>(null);
    _accountListenable = ValueNotifier<Account?>(null);
    _categoryListenable = ValueNotifier<Category?>(null);

    if (widget.cashFlow != null) {
      _isLoading = true;
      _loadCashFlowData();
    }
  }

  Future<void> _loadCashFlowData() async {
    final Database db = BudgeteaDatabase.database!;
    final Map<String, Object?>? row = (await db.query(
      "cash_flow",
      where: "id = ?",
      whereArgs: <Object?>[widget.cashFlow!.id],
      limit: 1,
    )).firstOrNull;

    if (row != null) {
      final Map<String, Object?>? accJson = (await db.query(
        "account",
        where: "id = ?",
        whereArgs: <Object?>[row["account"]],
        limit: 1,
      )).firstOrNull;

      final Map<String, Object?>? catJson = (await db.query(
        "cash_flow_category",
        where: "id = ?",
        whereArgs: <Object?>[row["category"]],
        limit: 1,
      )).firstOrNull;

      final Map<String, Object?>? currJson = (await db.query(
        "currency",
        where: "id = ?",
        whereArgs: <Object?>[row["currency"]],
        limit: 1,
      )).firstOrNull;

      if (accJson != null) {
        _accountListenable.value = Account.fromJson(accJson);
      }
      if (catJson != null) {
        _categoryListenable.value = Category.fromJson(catJson);
      }
      if (currJson != null) {
        final Currency curr = Currency.fromJson(currJson);
        _currencyListenable.value = curr;
        final double amtValue = (row["amount"] as num).toDouble().abs();
        final CurrencyTextInputFormatter formatter = Constants.formatter(curr);
        _amountController.text = formatter.formatDouble(amtValue);
      }
      _descriptionController.text = row["description"]?.toString() ?? "";
      _imageBytes = row["description_image"] as Uint8List?;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _currencyListenable.dispose();
    _accountListenable.dispose();
    _categoryListenable.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final XFile? file = await picker.pickImage(source: source, imageQuality: 80);
        if (file != null) {
          final Uint8List bytes = await file.readAsBytes();
          setState(() {
            _imageBytes = bytes;
          });
        }
      } catch (e) {
        debugPrint("Error picking image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.cashFlow == null
              ? AppLocalizations.of(context)!.add_cash_flow
              : "Editar movimiento"),
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.cashFlow == null
            ? AppLocalizations.of(context)!.add_cash_flow
            : "Editar movimiento"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ValueListenableBuilder<Account?>(
                  valueListenable: _accountListenable,
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
                      onSelected: (Account acc) => _accountListenable.value = acc,
                      selectedWidget: (void Function(BuildContext) func,
                              BuildContext context) =>
                          AccountTile(
                        account: account ?? const Account(),
                        onTap: () => func(context),
                        margin: EdgeInsets.zero,
                      ),
                      widget: (TreeNode<Account> item,
                          TreeViewController<Account, TreeNode<Account>>? tree) {
                        if (item.data == _accountListenable.value) {
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
                ValueListenableBuilder<Category?>(
                  valueListenable: _categoryListenable,
                  builder: (BuildContext context, Category? cat, Widget? _) {
                    return DropDownCustom<Category>(
                      label: AppLocalizations.of(context)!.category,
                      table: "cash_flow_category",
                      initialValue: cat,
                      getType: (List<Map<String, Object?>> json) =>
                          json.map(Category.fromJson).toList(),
                      validator: (_) {
                        if (_categoryListenable.value == null) {
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
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        );
                      },
                      onSelected: (Category newCategory) =>
                          _categoryListenable.value = newCategory,
                      onAdd: () async =>
                          await Navigator.push<bool>(
                            context,
                            MaterialPageRoute<bool>(
                              builder: (BuildContext context) =>
                                  const CategoryCreation(),
                            ),
                          ) ??
                          false,
                    );
                  },
                ),
                ValueListenableBuilder<Currency?>(
                  valueListenable: _currencyListenable,
                  builder: (BuildContext context, Currency? currencyValue,
                      Widget? _) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: SearchableDropDown<Currency>(
                            label: AppLocalizations.of(context)!.currency,
                            table: "currency",
                            initialValue: currencyValue,
                            getType: (List<Map<String, Object?>> json) =>
                                json.map(Currency.fromJson).toList(),
                            onSelected: (Currency? newCurrency) {
                              _currencyListenable.value = newCurrency;
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Builder(
                            builder: (BuildContext context) {
                              final CurrencyTextInputFormatter formatter =
                                  Constants.formatter(currencyValue);
                              _amountController.text = formatter.formatString(_amountController.text);
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
                                controller: _amountController,
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
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.description,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
                if (_imageBytes != null) ...[
                  const SizedBox(height: 10),
                  const Text(
                    "Comprobante:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imageBytes!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _imageBytes = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final Database db = BudgeteaDatabase.database!;
            final CurrencyTextInputFormatter formatter =
                Constants.formatter(_currencyListenable.value);
            formatter.formatString(_amountController.text);
            final double amountVal = (widget.type == TransactionType.gasto ? -1.0 : 1.0) *
                formatter.getDouble();

            if (widget.cashFlow == null) {
              // Insert mode
              await db.insert("cash_flow", <String, Object?>{
                "date": DateTime.now().toIso8601String(),
                "amount": amountVal,
                "account": _accountListenable.value!.id,
                "currency": _currencyListenable.value!.id,
                "description": _descriptionController.text,
                "category": _categoryListenable.value!.id,
                "description_image": _imageBytes,
              });
            } else {
              // Edit mode
              await db.update(
                "cash_flow",
                <String, Object?>{
                  "amount": amountVal,
                  "account": _accountListenable.value!.id,
                  "currency": _currencyListenable.value!.id,
                  "description": _descriptionController.text,
                  "category": _categoryListenable.value!.id,
                  "description_image": _imageBytes,
                },
                where: "id = ?",
                whereArgs: <Object?>[widget.cashFlow!.id],
              );
            }
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text("Aceptar"),
        ),
      ),
    );
  }
}
