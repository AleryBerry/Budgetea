import "package:my_app/extension_methods/double.dart";

class CashFlow {
  CashFlow({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.accountId,
  });
  final int id;
  final DateTime date;
  final (double, int) amount;
  final int category;
  final int accountId;

  static CashFlow fromJson(Map<String, Object?> json) {
    return CashFlow(
      id: json["id"] as int,
      date: DateTime.parse(json["date"] as String),
      amount: (json["amount"]?.toDouble() as double, json["currency"] as int),
      category: json["category"] as int,
      accountId: json["account"] as int,
    );
  }
}
