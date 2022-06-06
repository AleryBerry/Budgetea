import "dart:async";

import "package:collection/collection.dart";
import "package:equatable/equatable.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/models/dropdown_model.dart";
import "package:my_app/utils/currency_fetch.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class Account with DropDownType, EquatableMixin {
  const Account({
    this.id = -1,
    this.name = "",
    this.account = const <int>[],
    this.canReceiveCashFlow = false,
  });
  Account.fromJson(Map<String, Object?> json)
      : id = json["id"] as int,
        name = json["name"] as String,
        account = <int>[],
        canReceiveCashFlow =
            (json["can_receive_cash_flows"]?.toInt() ?? 0) == 1;

  final int id;
  @override
  final String name;
  final List<int> account;
  final bool canReceiveCashFlow;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      "id": id,
      "name": name,
    };
  }

  Future<List<Currency>> getCurrencies() => Account.getAccountCurrencies(id);
  Future<double> getTotal() => Account.getAccountTotal(id);
  Future<List<(Currency, double)>> getTotals() => Account.getAccountTotals(id);
  Future<List<Account>> getChildren() => Account.getAccountChildren(id);
  Future<List<Account>> getAllDescendants() =>
      Account.getAccountAllDescendants(id);

  static Future<List<Account>> getAccountAllDescendants(int id) async {
    final List<Account> descendants = <Account>[];
    final List<Account> children = await getAccountChildren(id);
    descendants.addAll(children);
    for (final Account child in children) {
      descendants.addAll(await getAccountAllDescendants(child.id));
    }
    return descendants;
  }

  static Future<List<Account>> getAccountChildren(int id) async {
    Database db = BudgeteaDatabase.database!;
    return (await db.rawQuery(
            """SELECT acc.*, re.parent_account as parent FROM account as acc
JOIN account_relationship as re on re.child_account = acc.id
WHERE re.parent_account = $id
"""))
        .map(Account.fromJson)
        .toList();
  }

  static Future<List<(Currency, double)>> getAccountTotals(int id) async {
    final Database db = BudgeteaDatabase.database!;
    final List<Map<String, Object?>> json =
        await db.query("account_totals", where: "id = $id");
    await db.query("currency");
    final Iterable<Currency> currencies = (await db.query("currency",
            where: json
                .map((Map<String, Object?> e) => "id = ${e['currency']}")
                .join(" OR ")))
        .map(Currency.fromJson);

    return json
        .map((Map<String, Object?> e) => (
              currencies
                  .firstWhere((Currency n) => n.id == e["currency"]?.toInt()),
              e["amount"]?.toDouble() ?? 0.0
            ))
        .toList();
  }

  static Future<double> getAccountTotal(int id) async {
    final Database db = BudgeteaDatabase.database!;
    final List<Map<String, Object?>> json =
        await db.query("account_totals", where: "id = $id");
    final double selfTotal = await json.fold(
      Future<double>.value(0.0),
      (FutureOr<double> acc, Map<String, Object?> val) async =>
          (await acc) +
          val["amount"]!.toDouble() *
              await getExchangeRate(Currency(id: val["currency"]?.toInt() ?? 0),
                  const Currency(id: 140)),
    );

    final double childrenTotal = await (await getAccountChildren(id)).fold(
      Future<double>.value(0.0),
      (FutureOr<double> acc, Account e) async {
        return (await acc) + (await getAccountTotal(e.id));
      },
    );
    return selfTotal + childrenTotal;
  }

  static Future<List<Currency>> getAccountCurrencies(int id) async {
    final Database db = BudgeteaDatabase.database!;
    final Set<Currency> selfCurrencies =
        (await db.rawQuery("""SELECT curr.* FROM currency as curr
JOIN account_totals as tot on tot.currency = curr.id
WHERE tot.id = $id
""")).map(Currency.fromJson).toSet();
    final Set<Currency> childrenCurrencies = (await Future.wait(
            (await Account.getAccountChildren(id))
                .map((Account e) => Account.getAccountCurrencies(e.id))))
        .flattenedToSet;
    return selfCurrencies.union(childrenCurrencies).toList();
  }

  @override
  List<Object?> get props => <Object?>[id, name];
}
