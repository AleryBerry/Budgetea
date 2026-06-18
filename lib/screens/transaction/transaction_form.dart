import "dart:typed_data";
import "package:animated_tree_view/tree_view/tree_node.dart";
import "package:animated_tree_view/tree_view/tree_view.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:collection/collection.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/models/transaction.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/category/category.dart";
import "package:my_app/screens/transaction/cashflow_add.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    this.transfer,
  });

  final Transfer? transfer;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final ValueNotifier<Currency?> _currencyListenable;
  late final ValueNotifier<Account?> _accountListenableOrigin;
  late final ValueNotifier<Account?> _accountListenableTarget;
  late final ValueNotifier<Category?> _categoryListenable;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _currencyListenable = ValueNotifier<Currency?>(null);
    _accountListenableOrigin = ValueNotifier<Account?>(null);
    _accountListenableTarget = ValueNotifier<Account?>(null);
    _categoryListenable = ValueNotifier<Category?>(null);

    if (widget.transfer != null) {
      _isLoading = true;
      _loadTransferData();
    }
  }

  Future<void> _loadTransferData() async {
    final Database db = BudgeteaDatabase.database!;
    final Map<String, Object?>? originRow = (await db.query(
      "cash_flow",
      where: "id = ?",
      whereArgs: <Object?>[widget.transfer!.cashFlowOriginId],
      limit: 1,
    )).firstOrNull;

    final Map<String, Object?>? targetRow = (await db.query(
      "cash_flow",
      where: "id = ?",
      whereArgs: <Object?>[widget.transfer!.cashFlowTargetId],
      limit: 1,
    )).firstOrNull;

    if (originRow != null && targetRow != null) {
      final Map<String, Object?>? originAccJson = (await db.query(
        "account",
        where: "id = ?",
        whereArgs: <Object?>[originRow["account"]],
        limit: 1,
      )).firstOrNull;

      final Map<String, Object?>? targetAccJson = (await db.query(
        "account",
        where: "id = ?",
        whereArgs: <Object?>[targetRow["account"]],
        limit: 1,
      )).firstOrNull;

      final Map<String, Object?>? catJson = (await db.query(
        "cash_flow_category",
        where: "id = ?",
        whereArgs: <Object?>[originRow["category"]],
        limit: 1,
      )).firstOrNull;

      final Map<String, Object?>? currJson = (await db.query(
        "currency",
        where: "id = ?",
        whereArgs: <Object?>[originRow["currency"]],
        limit: 1,
      )).firstOrNull;

      if (originAccJson != null) {
        _accountListenableOrigin.value = Account.fromJson(originAccJson);
      }
      if (targetAccJson != null) {
        _accountListenableTarget.value = Account.fromJson(targetAccJson);
      }
      if (catJson != null) {
        _categoryListenable.value = Category.fromJson(catJson);
      }
      if (currJson != null) {
        final Currency curr = Currency.fromJson(currJson);
        _currencyListenable.value = curr;
        final double amtValue = (originRow["amount"] as num).toDouble().abs();
        final CurrencyTextInputFormatter formatter = Constants.formatter(curr);
        _amountController.text = formatter.formatDouble(amtValue);
      }
      _descriptionController.text = originRow["description"]?.toString() ?? "";
      _imageBytes = originRow["description_image"] as Uint8List?;
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
    _accountListenableOrigin.dispose();
    _accountListenableTarget.dispose();
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
          title: Text(widget.transfer == null
              ? AppLocalizations.of(context)!.add_transfer
              : "Editar transferencia"),
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
        title: Text(widget.transfer == null
            ? AppLocalizations.of(context)!.add_transfer
            : "Editar transferencia"),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.origin_account),
                    const SizedBox(height: 5),
                    ValueListenableBuilder<Account?>(
                      valueListenable: _accountListenableOrigin,
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
                            if (item.data == _accountListenableOrigin.value ||
                                item.data == _accountListenableTarget.value) {
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
                            _accountListenableOrigin.value = acc;
                          },
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.target_account),
                    const SizedBox(height: 5),
                    ValueListenableBuilder<Account?>(
                      valueListenable: _accountListenableTarget,
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
                            if (item.data == _accountListenableOrigin.value ||
                                item.data == _accountListenableTarget.value) {
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
                              _accountListenableTarget.value = acc,
                        );
                      },
                    ),
                  ],
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
                      onSelected: (Category newCategory) => _categoryListenable.value = newCategory,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ValueListenableBuilder<Currency?>(
                        valueListenable: _currencyListenable,
                        builder: (BuildContext context, Currency? cur, Widget? _) {
                          return DropDownCustom<Currency>(
                            label: AppLocalizations.of(context)!.currency,
                            table: "currency",
                            initialValue: cur,
                            getType: (List<Map<String, Object?>> json) =>
                                json.map(Currency.fromJson).toList(),
                            onSelected: (Currency newCurrency) =>
                                _currencyListenable.value = newCurrency,
                            validator: (Currency? currency) {
                              if (currency == null) {
                                return AppLocalizations.of(context)!
                                    .select_a_currency;
                              }
                              if (!_isValid) {
                                return AppLocalizations.of(context)!
                                    .account_doesnt_own_currency;
                              }
                              return null;
                            },
                            child: (Currency element) => Row(
                              children: <Widget?>[
                                element.logoUrl.isEmpty
                                    ? null
                                    : CachedNetworkImage(
                                        imageUrl: element.logoUrl,
                                        width: 22,
                                        height: 22,
                                      ),
                                const SizedBox(width: 8),
                                Text(
                                    "${element.type == CurrencyType.crypto ? "" : element.getEmoji()} ${element.name} (${element.iso})"),
                              ].nonNulls.toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder<Currency?>(
                        valueListenable: _currencyListenable,
                        builder: (BuildContext context, Currency? currencyValue,
                            Widget? _) {
                          final CurrencyTextInputFormatter formatter =
                              Constants.formatter(currencyValue);
                          _amountController.text = formatter.formatString(_amountController.text);
                          return TextFormField(
                            textAlign: TextAlign.end,
                            validator: (String? value) {
                              if (formatter.getDouble() <= 0) {
                                return AppLocalizations.of(context)!.empty_number;
                              }
                              if (currencyValue == null) {
                                return AppLocalizations.of(context)!
                                    .select_a_currency;
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[formatter],
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            decoration: InputDecoration(
                              suffix:
                                  currencyValue == null ? null : Text(currencyValue.iso),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
            final CurrencyTextInputFormatter formatter =
                Constants.formatter(_currencyListenable.value);
            formatter.formatString(_amountController.text);
            final double amt = formatter.getDouble();

            final (Currency, double)? wot = (await _accountListenableOrigin.value
                    ?.getTotals())
                ?.firstWhereOrNull(
                    ((Currency, double) e) => e.$1.id == _currencyListenable.value?.id);

            final double originAvailable = wot?.$2 ?? 0.0;
            double requiredAmt = amt;
            if (widget.transfer != null) {
              final double oldAmount = widget.transfer!.amount.$2;
              if (widget.transfer!.account1.id == _accountListenableOrigin.value!.id &&
                  widget.transfer!.amount.$1.id == _currencyListenable.value!.id) {
                requiredAmt -= oldAmount;
              }
            }

            if (wot != null && originAvailable >= requiredAmt) {
              _isValid = true;
            }
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final Database db = BudgeteaDatabase.database!;
            if (widget.transfer == null) {
              // Add Mode
              final Batch batch = db.batch();
              batch.insert("cash_flow", <String, Object?>{
                "date": DateTime.now().toIso8601String(),
                "account": _accountListenableOrigin.value!.id,
                "currency": _currencyListenable.value!.id,
                "category": _categoryListenable.value!.id,
                "amount": -amt,
                "description": _descriptionController.text,
                "description_image": _imageBytes,
              });
              batch.insert("cash_flow", <String, Object?>{
                "date": DateTime.now().toIso8601String(),
                "account": _accountListenableTarget.value!.id,
                "currency": _currencyListenable.value!.id,
                "category": _categoryListenable.value!.id,
                "amount": amt,
                "description": _descriptionController.text,
                "description_image": _imageBytes,
              });

              final List<int> ids = (await batch.commit(continueOnError: false))
                  .map((Object? e) => e?.toInt() ?? 0)
                  .toList();

              await db.insert("transfer", <String, Object?>{
                "cash_flow_origin": ids[0],
                "cash_flow_target": ids[1],
              });
            } else {
              // Edit Mode
              final Batch batch = db.batch();
              batch.update(
                "cash_flow",
                <String, Object?>{
                  "account": _accountListenableOrigin.value!.id,
                  "currency": _currencyListenable.value!.id,
                  "category": _categoryListenable.value!.id,
                  "amount": -amt,
                  "description": _descriptionController.text,
                  "description_image": _imageBytes,
                },
                where: "id = ?",
                whereArgs: <Object?>[widget.transfer!.cashFlowOriginId],
              );
              batch.update(
                "cash_flow",
                <String, Object?>{
                  "account": _accountListenableTarget.value!.id,
                  "currency": _currencyListenable.value!.id,
                  "category": _categoryListenable.value!.id,
                  "amount": amt,
                  "description": _descriptionController.text,
                  "description_image": _imageBytes,
                },
                where: "id = ?",
                whereArgs: <Object?>[widget.transfer!.cashFlowTargetId],
              );
              await batch.commit(continueOnError: false);
            }
            if (!context.mounted) return;
            Navigator.pop(context, true);
          },
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ),
    );
  }
}
