import "package:equatable/equatable.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/category.dart";
import "package:my_app/models/currency.dart";

class Transfer with EquatableMixin {
  const Transfer({
    this.id = -1,
    required this.date,
    this.observacion = "",
    this.account1 = const Account(),
    this.account2 = const Account(),
    this.amount = (const Currency(), 0.0),
    this.category = const Category(),
    this.cashFlowOriginId = 0,
    this.cashFlowTargetId = 0,
  });

  final int id;
  final DateTime date;
  final Account account1;
  final Account account2;
  final Category category;
  final int cashFlowOriginId;
  final int cashFlowTargetId;
  final (Currency, double) amount;
  final String observacion;

  @override
  List<Object?> get props => <Object?>[id];
}
