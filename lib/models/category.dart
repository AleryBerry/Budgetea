import "package:equatable/equatable.dart";
import "package:flutter/material.dart";
import "package:flutter_iconpicker/Serialization/icondata_serialization.dart";
import "package:my_app/models/dropdown_model.dart";

class Category with DropDownType, EquatableMixin {
  Category.fromJson(Map<String, Object?> json)
      : id = json["id"] as int,
        name = json["name"] as String,
        iconName = json["icon_name"] as String?,
        iconColor = json["icon_color"] as String?,
        iconPack = json["icon_pack"] as String?;

  const Category({
    this.name = "",
    this.id = -1,
    this.iconName,
    this.iconPack,
    this.iconColor,
  });
  final int id;
  @override
  final String name;
  final String? iconName;
  final String? iconPack;
  final String? iconColor;

  IconData? getIconData() =>
      deserializeIcon(<String, Object?>{"key": iconName, "pack": iconPack})
          ?.data;

  Color? getIconColor() {
    if (iconColor == null) {
      return null;
    }
    String colorString = iconColor!;
    if (colorString.startsWith('#')) {
      colorString = colorString.substring(1);
    }
    if (colorString.length == 6) {
      colorString = "ff$colorString";
    }
    if (colorString.length == 8) {
      try {
        return Color(int.parse("0x$colorString"));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, Object?>{
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object?> get props => <Object?>[id, name];
}

class CategoryWithUsage extends Category {
  final int transactionCount;

  const CategoryWithUsage({
    required super.name,
    required super.id,
    required this.transactionCount,
    super.iconName,
    super.iconPack,
    super.iconColor,
  });

  CategoryWithUsage.fromJson(Map<String, Object?> json)
      : transactionCount = json["transaction_count"] as int,
        super.fromJson(json);
}
