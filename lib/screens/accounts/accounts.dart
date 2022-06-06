import "dart:async";
import "package:animated_tree_view/animated_tree_view.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_iconpicker/extensions/string_extensions.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/extension_methods/iterable.dart";
import "package:my_app/home/budget_card.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/cash_flow.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/account_creation.dart";
import "package:my_app/screens/transaction/cashflow_add.dart";
import "package:my_app/utils/ask_alertdialog.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class AccountDetails extends StatelessWidget {
  const AccountDetails({required this.account, super.key});
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details (${account.name})"),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          CurrencyTotals(account: account),
          const Divider(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(AppLocalizations.of(context)!.last_activities),
              FutureBuilder<List<CashFlow>>(
                future: (() async {
                  final List<Account> descendants =
                      await account.getAllDescendants();
                  final List<int> accountIds = <int>[
                    account.id,
                    ...descendants.map((Account e) => e.id)
                  ];
                  return (await BudgeteaDatabase.database!.query("cash_flow",
                          where: "account IN (${accountIds.join(', ')})",
                          limit: 5,
                          orderBy: "datetime(date) desc"))
                      .map(CashFlow.fromJson)
                      .toList();
                })(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CashFlow>> snapshot) {
                  return Column(
                    children: snapshot.data
                            ?.map((CashFlow e) => CashFlowCard(e))
                            .toList() ??
                        <Widget>[],
                  );
                },
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: 200,
            child: FutureBuilder<TreeNode<Account>>(
              future: (() async => TreeNode<Account>.root()
                ..addAll(
                  await Future.wait(
                    (await account.getChildren()).map(
                      (Account e) async => TreeNode<Account>(
                        key: e.id.toString(),
                        data: e,
                      )..addAll(
                          (await e.getChildren()).map(
                            (Account e) => TreeNode<Account>(
                              key: e.id.toString(),
                              data: e,
                            ),
                          ),
                        ),
                    ),
                  ),
                ))(),
              builder: (BuildContext context,
                  AsyncSnapshot<TreeNode<Account>> snapshot) {
                if (snapshot.data?.children.isEmpty ?? true) {
                  return const Center();
                }
                return Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.children,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: AccountsTree(
                        widget: (TreeNode<Account> item,
                                TreeViewController<Account, TreeNode<Account>>?
                                    tree) =>
                            AccountTile(account: item.data!),
                        snapshot: DataRequest<TreeNode<Account>>(
                            snapshot.data ?? TreeNode<Account>.root()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountsList extends StatelessWidget {
  AccountsList({super.key});
  final DataRequest<TreeNode<Account>> snapshot =
      DataRequest<TreeNode<Account>>(TreeNode<Account>.root());

  @override
  Widget build(BuildContext context) {
    if (!snapshot.fetched) fetchData();
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Column(
        children: <Widget>[
          const CurrencyTotals(),
          const Divider(),
          Expanded(
            child: AccountsTree(
              snapshot: snapshot,
              widget: (TreeNode<Account> item,
                      TreeViewController<Account, TreeNode<Account>>?
                          myTree) =>
                  AccountTile(
                account: item.data!,
                onTap: () async {
                  if (myTree == null) return;
                  myTree.toggleExpansion(item);
                  for (final ListenableNode e in item.childrenAsList) {
                    if (e.children.isNotEmpty) continue;
                    final Account? data = myTree.elementAt(e.path).data;
                    if (data == null) continue;
                    e.addAll(
                      (await data.getChildren()).map(
                        (Account e) =>
                            TreeNode<Account>(key: e.id.toString(), data: e),
                      ),
                    );
                  }
                },
                onLongPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext newContext) {
                      return SimpleDialog(
                        title: const Text("Account Options"),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              if (item.data == null) return;
                              Navigator.of(context).push(
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
                                      child: child,
                                    );
                                  },
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return AccountDetails(account: item.data!);
                                  },
                                ),
                              );
                            },
                            child: const Text("View Details"),
                          ),
                          SimpleDialogOption(
                            onPressed: () async {
                              if (await Navigator.push<bool>(
                                    context,
                                    PageRouteBuilder<bool>(
                                      transitionsBuilder:
                                          (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation,
                                              Widget child) {
                                        const Offset begin = Offset(0.0, 1.0);
                                        const Offset end = Offset.zero;
                                        const Cubic curve = Curves.ease;

                                        Animatable<Offset> tween = Tween<
                                                Offset>(
                                            begin: begin,
                                            end: end).chain(CurveTween(
                                            curve: curve));

                                        return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child);
                                      },
                                      pageBuilder: (BuildContext context,
                                          Animation<double> _,
                                          Animation<double> __) {
                                        return AccountCreation(
                                          parent: item.data,
                                        );
                                      },
                                    ),
                                  ) ??
                                  false) {
                                fetchData();
                              }
                            },
                            child: const Text("Add Child"),
                          ),
                          SimpleDialogOption(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final GlobalKey<FormState> formKey =
                                    GlobalKey<FormState>();
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                      key: formKey,
                                      child: TextFormField(
                                        autofocus: true,
                                        onFieldSubmitted: (String val) async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            (
                                              await BudgeteaDatabase.database!
                                                  .update("account",
                                                      <String, Object?>{
                                                    "name": val
                                                  },
                                                      where:
                                                          "id = ${item.data!.id}"),
                                            );
                                            if (!context.mounted) return;
                                            fetchData();
                                            Navigator.pop(context);
                                          }
                                        },
                                        validator: (String? val) {
                                          if (val.isNullOrBlank) {
                                            return "Empty field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            child: Text(AppLocalizations.of(context)!.rename),
                          ),
                          SimpleDialogOption(
                            onPressed: () async {
                              final DataRequest<TreeNode<Account>> snapshot =
                                  DataRequest<TreeNode<Account>>(
                                      await fullAccountTree());
                              if (!context.mounted) return;
                              final Account? account =
                                  await showDialog<Account>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 600,
                                      width: 400,
                                      child: Column(
                                        children: <Widget>[
                                          Card(
                                            clipBehavior: Clip.antiAlias,
                                            child: ListTile(
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .no_parent),
                                              onTap: () => Navigator.pop(
                                                  context,
                                                  const Account(id: 0)),
                                            ),
                                          ),
                                          const Divider(),
                                          Expanded(
                                            child: AccountsTree(
                                              snapshot: snapshot,
                                              widget: (TreeNode<Account> val,
                                                  TreeViewController<
                                                          Account,
                                                          TreeNode<Account>>?
                                                      tree) {
                                                final bool isParent = val
                                                    .children.keys
                                                    .any((String e) =>
                                                        e == item.key);
                                                return AccountTile(
                                                  selected:
                                                      val.data! == item.data! ||
                                                          isParent,
                                                  account: val.data!,
                                                  onTap: val.data! ==
                                                              item.data! ||
                                                          isParent
                                                      ? null
                                                      : () {
                                                          Navigator.pop(context,
                                                              val.data!);
                                                        },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (account == null) return;

                              final Database db = BudgeteaDatabase.database!;
                              if (account.id == 0) {
                                await db.delete(
                                  "account_relationship",
                                  where: "child_account = ${item.data!.id}",
                                );
                                fetchData();
                                return;
                              }
                              if ((await db.query(
                                "account_relationship",
                                where: "child_account = ${item.data!.id}",
                                limit: 1,
                              ))
                                  .isEmpty) {
                                await db.insert(
                                  "account_relationship",
                                  <String, Object?>{
                                    "parent_account": account.id,
                                    "child_account": item.data!.id,
                                  },
                                );
                              } else {
                                await db.update(
                                  "account_relationship",
                                  <String, Object?>{
                                    "parent_account": account.id,
                                  },
                                  where: "child_account = ${item.data!.id}",
                                );
                              }
                              fetchData();
                            },
                            child:
                                Text(AppLocalizations.of(context)!.reparent),
                          ),
                          SimpleDialogOption(
                            onPressed: () async {
                              if (item.data == null) return;
                              bool delete = await alertDialogAsk(
                                context,
                                AppLocalizations.of(context)!
                                    .account_delete_sure,
                              );
                              if (!delete) return;
                              final List<Account> children =
                                  await item.data!.getChildren();
                              if (!context.mounted) return;
                              bool deleteChildren = children.isEmpty ||
                                  await alertDialogAsk(
                                    context,
                                    AppLocalizations.of(context)!
                                        .account_delete_has_children,
                                  );

                              final Batch batch =
                                  BudgeteaDatabase.database!.batch();
                              batch.delete("account",
                                  where: "id = ${item.data!.id}");
                              if (deleteChildren) {
                                for (final Account account in children) {
                                  batch.delete("account",
                                      where: "id = ${account.id}");
                                }
                              }
                              await batch.commit(continueOnError: true);
                              if (!newContext.mounted || !context.mounted) return;
                              HomeState.of(context).fetchData();
                              Navigator.pop(newContext);
                            },
                            child: Text(AppLocalizations.of(context)!.delete),
                          ),
                          SimpleDialogOption(
                            child: Text(AppLocalizations.of(context)!
                                .set_as_main_account),
                            onPressed: () async {
                              if (item.data != null) {
                                (await SharedPreferences.getInstance())
                                    .setInt("main_account", item.data!.id);
                                Constants.accountId = item.data!.id;
                              }
                              if (!context.mounted) return;
                              HomeState.of(context).fetchData();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchData() async {
    Database db = BudgeteaDatabase.database!;
    List<Map<String, Object?>> json = await db.query("account_roots");
    snapshot.replace(
      TreeNode<Account>.root()
        ..addAll(
          await Future.wait(
            json.map(
              (Map<String, Object?> e) async {
                return TreeNode<Account>(
                  data: Account.fromJson(e),
                )..addAll(
                    (await Account.getAccountChildren(e["id"]?.toInt() ?? 1))
                        .map(
                      (Account e) => TreeNode<Account>(
                        key: e.id.toString(),
                        data: e,
                      ),
                    ),
                  );
              },
            ),
          ),
        ),
    );
  }
}

class CurrencyTotals extends StatelessWidget {
  const CurrencyTotals({this.account, super.key});
  final Account? account;

  Future<List<Map<String, Object?>>> _getCurrencyTotals() async {
    final Database db = BudgeteaDatabase.database!;
    String whereClause = "";
    if (account != null) {
      final List<Account> descendants = await account!.getAllDescendants();
      final List<int> accountIds = <int>[
        account!.id,
        ...descendants.map((Account e) => e.id)
      ];
      whereClause = 'WHERE cf.account IN (${accountIds.join(', ')})';
    }
    return db.rawQuery("""
      SELECT
        c.name as currency_name,
        c.logo_url,
        c.type,
        c.symbol,
        c.iso,
        SUM(cf.amount) as total
      FROM cash_flow cf
      JOIN currency c ON cf.currency = c.id
      $whereClause
      GROUP BY cf.currency
    """);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Map<String, Object?>>>(
        future: _getCurrencyTotals(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data"));
          }

          final List<Map<String, Object?>> totals = snapshot.data!;

          return ListView(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.currency_totals,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                ),
                itemCount: totals.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, Object?> total = totals[index];
                  final Currency currency = Currency(
                    name: total["currency_name"] as String,
                    logoUrl: total["logo_url"]?.toString() ?? "",
                    type: (total["type"] as String) == "FIAT"
                        ? CurrencyType.fiat
                        : CurrencyType.crypto,
                    symbol: total["symbol"]?.toString() ?? "",
                    iso: total["iso"] as String,
                  );
                  final double amount = total["total"]?.toDouble() ?? 0.0;

                  return Card(
                    child: ListTile(
                      leading: currency.type == CurrencyType.crypto
                          ? CachedNetworkImage(
                              imageUrl: currency.logoUrl,
                              width: 40,
                              height: 40,
                            )
                          : Text(
                              currency.getEmoji(),
                              style: const TextStyle(fontSize: 24),
                            ),
                      title: Text(currency.name),
                      subtitle: Text(
                        NumberFormat.compactSimpleCurrency(
                          decimalDigits: 2,
                          name: currency.iso,
                        ).format(amount),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


class AccountsTree extends StatelessWidget {
  const AccountsTree({
    super.key,
    required this.snapshot,
    required this.widget,
  });
  final DataRequest<TreeNode<Account>> snapshot;

  final Widget Function(
          TreeNode<Account>, TreeViewController<Account, TreeNode<Account>>?)
      widget;

  @override
  Widget build(BuildContext context) {
    TreeViewController<Account, TreeNode<Account>>? myTree;
    return ListenableBuilder(
      listenable: snapshot,
      builder: (BuildContext context, Widget? _) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverTreeView.simpleTyped(
              showRootNode: false,
              indentation: const Indentation(style: IndentStyle.roundJoint),
              onItemTap: (TreeNode<Account> item) async {
                if (myTree == null) return;
                for (final ListenableNode e in item.childrenAsList) {
                  if (e.children.isNotEmpty) continue;
                  final Account? data = myTree!.elementAt(e.path).data;
                  if (data == null) continue;
                  e.addAll(
                    (await Account.getAccountChildren(data.id)).map(
                      (Account e) =>
                          TreeNode<Account>(key: e.id.toString(), data: e),
                    ),
                  );
                }
              },
              onTreeReady:
                  (TreeViewController<Account, TreeNode<Account>> newTree) =>
                      myTree = newTree,
              builder: (BuildContext context, TreeNode<Account> item) =>
                  widget(item, myTree),
              tree: snapshot.data,
            )
          ],
        );
      },
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.margin,
  });

  final Account account;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final EdgeInsetsGeometry? margin;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(double, List<Currency>)>(
      future: () async {
        return (
          await account.getTotal(),
          await account.getCurrencies(),
        );
      }(),
      builder: (BuildContext context,
          AsyncSnapshot<(double, List<Currency>)> snapshot) {
        return Tooltip(
          message: account.id == Constants.accountId ? "Main Account" : "",
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: margin,
            shape: RoundedRectangleBorder(
              side: account.id == Constants.accountId
                  ? const BorderSide(
                      width: 1,
                      color: Colors.amber,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              selected: selected,
              onTap: onTap,
              onLongPress: onLongPress,
              title: Text(account.name),
              subtitle: Row(
                children: <Widget>[
                  Text("${AppLocalizations.of(context)!.currencies}: "),
                  ...(snapshot.data?.$2 ?? <Currency>[]).map<Widget>(
                    (Currency e) {
                      if (e.type == CurrencyType.crypto) {
                        return CachedNetworkImage(
                            imageUrl: e.logoUrl, width: 22, height: 22);
                      }
                      return Text(e.getEmoji());
                    },
                  ).intersperse(const Text(", "))
                ],
              ),
              trailing: Text(
                NumberFormat.compactSimpleCurrency(decimalDigits: 2)
                    .format(snapshot.data?.$1 ?? 0.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DataRequest<T> with ChangeNotifier {
  DataRequest(this.data);
  T data;
  bool fetched = false;

  void replace(T newData) {
    data = newData;
    fetched = true;
    notifyListeners();
  }
}
