import "dart:async";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/date_time.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/home/budget_card.dart";
import "package:my_app/home/balance.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/cash_flow.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/constants.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/models/transaction.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/cash_flow/cash_flow.dart";
import "package:my_app/screens/cash_flow/transfer_details.dart";
import "package:my_app/screens/overview/transfer_card.dart";
import "package:my_app/screens/transaction/cashflow_add.dart";
import "package:my_app/utils/ask_alertdialog.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:my_app/screens/transaction/transaction_form.dart";
import "package:my_app/home/date_selector.dart";

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  DateTimeRange? _dateRange;

  final DataRequest<(List<CashFlow>, List<Transfer>)> snapshot =
      DataRequest<(List<CashFlow>, List<Transfer>)>(
    (<CashFlow>[], <Transfer>[]),
  );

  StreamSubscription<List<Map<String, Object?>>>? _subscription;

  @override
  void initState() {
    super.initState();
    _watchData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _watchData() async {
    snapshot.fetched = true;
    _subscription?.cancel();
    final Database db = BudgeteaDatabase.database!;
    final int? accId = (await SharedPreferences.getInstance()).getInt(PreferencesKeys.mainAccount);
    final String accountFilter = (accId != null && accId != 0) ? "ca.account = $accId" : "1 = 1";
    late final String request;
    if (_dateRange != null) {
      request = """SELECT ca.*, tra.id as transfer from cash_flow as ca
LEFT JOIN transfer as tra on (tra.cash_flow_target = ca.id) or (tra.cash_flow_origin = ca.id)
WHERE ($accountFilter) AND ca.date < '${_dateRange!.end}' AND ca.date > '${_dateRange!.start}'
ORDER BY datetime(ca.date) DESC""";
    } else {
      request = """SELECT ca.*, tra.id as transfer from cash_flow as ca
LEFT JOIN transfer as tra on (tra.cash_flow_target = ca.id) or (tra.cash_flow_origin = ca.id)
WHERE $accountFilter
ORDER BY datetime(ca.date) DESC""";
    }

    _subscription = db.watchQuery(request, readsFrom: {db.driftDb.cashFlows, db.driftDb.transfers}).listen((res) async {
      snapshot.replace(
        (
          res
              .where((Map<String, Object?> e) => e["transfer"] == null)
              .map(CashFlow.fromJson)
              .toList(),
          (await Future.wait(
            res.where((Map<String, Object?> e) => e["transfer"] != null).map(
              (Map<String, Object?> e) async {
                final String request2 =
                    """SELECT tra.id, tra.cash_flow_origin, tra.cash_flow_target, ca.amount, ca.account as origin, acc.name as origin_name, cas.account as target, accs.name as target_name, ca.date, ca.description from transfer as tra
JOIN cash_flow as ca on tra.cash_flow_origin = ca.id
JOIN account as acc on acc.id = ca.account
JOIN cash_flow as cas on tra.cash_flow_target = cas.id
JOIN account as accs on accs.id = cas.account
WHERE tra.id = ${e["transfer"]}""";
                final Map<String, Object?> json =
                    (await db.rawQuery(request2)).first;
                final Currency currency = Currency.fromJson((await db
                        .query("currency", where: "id = ${e["currency"]}"))
                    .first);
                return Transfer(
                  id: json["id"]?.toInt() ?? 0,
                  cashFlowOriginId: json["cash_flow_origin"]?.toInt() ?? 0,
                  cashFlowTargetId: json["cash_flow_target"]?.toInt() ?? 0,
                  account1: Account(
                    id: json["origin"]?.toInt() ?? 0,
                    name: json["origin_name"] as String,
                  ),
                  date: DateTime.tryParse(json["date"].toString()) ??
                      DateTime.now(),
                  observacion: json["description"]?.toString() ?? "",
                  account2: Account(
                    id: json["target"]?.toInt() ?? 0,
                    name: json["target_name"] as String,
                  ),
                  category: Category.fromJson(
                    (await db.query("cash_flow_category",
                            where: "id = ${e["category"]}"))
                        .first,
                  ),
                  amount: (currency, (e["amount"]?.toDouble() ?? 0.0).abs()),
                );
              },
            ),
          ))
              .toSet()
              .toList()
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Balance(range: _dateRange),
              Positioned(
                bottom: 0,
                right: 1,
                child: DateSelector(
                  onSelected: (DateTimeRange? range) {
                    setState(() {
                      _dateRange = range;
                    });
                    _watchData();
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: snapshot,
              builder: (BuildContext context, Widget? _) {
                final List<StatelessWidget> widgets =
                    <(DateTime, StatelessWidget)>[
                  ...snapshot.data.$2.map(
                    (Transfer e) => (
                      e.date,
                      TransferCard(
                        transfer: e,
                        onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                AppLocalizations.of(context)!.transfer_options,
                              ),
                              children: <Widget>[
                                SimpleDialogOption(
                                  child: Text(
                                    AppLocalizations.of(context)!.view_details,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => TransferDetails(
                                          transfer: e,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final bool? edited = await Navigator.of(context).push<bool>(
                                      MaterialPageRoute<bool>(
                                        builder: (BuildContext context) => TransactionForm(
                                          transfer: e,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(AppLocalizations.of(context)!.localeName == "es" ? "Editar" : "Edit"),
                                ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    bool response = await alertDialogAsk(
                                      context,
                                      AppLocalizations.of(context)!
                                          .transfer_delete_sure,
                                    );

                                    if (!response) return;
                                    final Batch db =
                                        BudgeteaDatabase.database!.batch();
                                    db.delete("cash_flow",
                                        where: "id = ${e.cashFlowOriginId}");
                                    db.delete("cash_flow",
                                        where: "id = ${e.cashFlowTargetId}");
                                    await db.commit(
                                      continueOnError: false,
                                      noResult: true,
                                    );
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.delete),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ...snapshot.data.$1.map(
                    (CashFlow e) => (
                      e.date,
                      CashFlowCard(
                        e,
                        onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                AppLocalizations.of(context)!.cash_flow_options,
                              ),
                              children: <Widget>[
                                SimpleDialogOption(
                                  child: Text(
                                    AppLocalizations.of(context)!.view_details,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => CashFlowDetails(
                                          cashFlow: e,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final bool? edited = await Navigator.of(context).push<bool>(
                                      MaterialPageRoute<bool>(
                                        builder: (BuildContext context) => CashFlowForm(
                                          type: e.amount.$1 < 0
                                              ? TransactionType.gasto
                                              : TransactionType.ingreso,
                                          cashFlow: e,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(AppLocalizations.of(context)!.localeName == "es" ? "Editar" : "Edit"),
                                ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    bool response = await alertDialogAsk(
                                      context,
                                      AppLocalizations.of(context)!
                                          .cash_flow_delete_sure,
                                    );
                                    if (!response) return;
                                    final Database db =
                                        BudgeteaDatabase.database!;
                                    await db.delete("cash_flow",
                                        where: "id = ${e.id}");
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.delete),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ]
                        .sortedBy(((DateTime, StatelessWidget) e) => e.$1)
                        .map(((DateTime, StatelessWidget) e) => e.$2)
                        .toList()
                        .reversed
                        .toList();
                return ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widgets,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


