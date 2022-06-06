// ignore: prefer_double_quotes
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
  });

  final String label;
  final Widget? suffix;
  final TextEditingController value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: value,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        suffix: suffix,
      ),
    );
  }
}
