import "package:animated_tree_view/tree_view/tree_node.dart";
import "package:animated_tree_view/tree_view/tree_view.dart";
import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/models/account.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class AccountCreation extends StatefulWidget {
  const AccountCreation({this.parent, super.key});
  final Account? parent;

  @override
  State<AccountCreation> createState() => AccountCreationState();
}

class AccountCreationState extends State<AccountCreation> {
  final TextEditingController name = TextEditingController();
  Account? parent;
  bool canReceiveCashFlows = true;

  @override
  void initState() {
    parent = widget.parent;
    super.initState();
  }

  void submit(BuildContext context) async {
    final Database db = BudgeteaDatabase.database!;
    final int id = await db.insert(
      "account",
      <String, Object?>{
        "name": name.text,
        "can_receive_cash_flows": canReceiveCashFlows ? 1 : 0,
      },
    );
    if (parent != null) {
      await db.insert("account_relationship", <String, Object?>{
        "parent_account": parent!.id,
        "child_account": id,
      });
    }
    if (!context.mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_account),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: name,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  onFieldSubmitted: (String _) => submit(context),
                ),
                Row(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.can_receive_cash_flows),
                    Checkbox(
                      value: canReceiveCashFlows,
                      onChanged: (bool? val) =>
                          setState(() => canReceiveCashFlows = val ?? true),
                    )
                  ],
                ),
                parent == null
                    ? ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.no_parent_selected),
                        trailing: TextButton(
                          onPressed: () async {
                            Database db = BudgeteaDatabase.database!;
                            List<Map<String, Object?>> json =
                                await db.query("account_roots");
                            final DataRequest<TreeNode<Account>> snapshot =
                                DataRequest<TreeNode<Account>>(
                              TreeNode<Account>.root()
                                ..addAll(
                                  await Future.wait(
                                    json.map(
                                      (Map<String, Object?> e) async {
                                        return TreeNode<Account>(
                                          data: Account.fromJson(e),
                                        )..addAll(
                                            (await Account.getAccountChildren(
                                                    e["id"]?.toInt() ?? 1))
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
                            if (!context.mounted) return;
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
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        const Divider(),
                                        Expanded(
                                          child: AccountsTree(
                                            snapshot: snapshot,
                                            widget: (TreeNode<Account> item,
                                                TreeViewController<Account,
                                                        TreeNode<Account>>?
                                                    tree) {
                                              return AccountTile(
                                                account: item.data!,
                                                onTap: () {
                                                  Navigator.pop(
                                                    context,
                                                    item.data,
                                                  );
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
                            ).then((Account? temp) =>
                                setState(() => parent = temp));
                          },
                          child:
                              Text(AppLocalizations.of(context)!.select_parent),
                        ),
                      )
                    : Row(
                        children: <Widget>[
                          Expanded(child: AccountTile(account: parent!)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                parent = null;
                              });
                            },
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () => submit(context),
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ),
    );
  }
}
