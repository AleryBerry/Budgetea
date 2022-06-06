import "package:flutter/material.dart";

extension HexColor on Color {
  static Color? fromHex(String? hexString) {
    if (hexString == null) {
      return null;
    }
    try {
      final StringBuffer buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write("ff");
      }
      buffer.write(hexString.replaceFirst("#", ""));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }

  String toHex({bool leadingHashSign = true}) {
    final String hexA = (a * 255).round().toRadixString(16).padLeft(2, "0");
    final String hexR = (r * 255).round().toRadixString(16).padLeft(2, "0");
    final String hexG = (g * 255).round().toRadixString(16).padLeft(2, "0");
    final String hexB = (b * 255).round().toRadixString(16).padLeft(2, "0");

    return '${leadingHashSign ? '#' : ''}$hexA$hexR$hexG$hexB';
  }
}
