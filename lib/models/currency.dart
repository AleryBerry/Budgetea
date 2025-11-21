import "package:collection/collection.dart";
import "package:equatable/equatable.dart";
import "package:my_app/extension_methods/double.dart";
import "package:my_app/models/dropdown_model.dart";

enum CurrencyType { crypto, stock, fiat }

class Currency with DropDownType, EquatableMixin {
  Currency.fromJson(Map<String, Object?> json)
      : id = json["id"] as int,
        name = json["name"] as String,
        symbol = json["symbol"] as String? ?? "",
        symbolOnLeft = json["symbol_on_left"]?.toInt() == 1,
        iso = json["iso"] as String,
        decimalPoints = json["decimal_points"] as int,
        type = CurrencyType.values.firstWhereOrNull((CurrencyType e) =>
                e.name.toLowerCase() ==
                json["type"].toString().toLowerCase()) ??
            CurrencyType.fiat,
        logoUrl = json["logo_url"] as String? ?? "";
  const Currency({
    this.name = "",
    this.id = -1,
    this.symbol = "",
    this.iso = "",
    this.type = CurrencyType.fiat,
    this.logoUrl = "",
    this.decimalPoints = 2,
    this.symbolOnLeft = true,
  });

  final int id;
  @override
  final String name;
  final int decimalPoints;
  final String symbol;
  final String iso;
  final CurrencyType type;
  final String logoUrl;
  final bool symbolOnLeft;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      "id": id,
      "name": name,
      "symbol": symbol,
    };
  }

  String getEmoji() {
    final String currencyFlag = iso;
    final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  List<Object?> get props => <Object?>[id];

  @override
  String? get fullName => "$name ($iso)";
}
