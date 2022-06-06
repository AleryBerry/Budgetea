extension Round on double {
  double roundTo({int amount = 2}) {
    return double.parse(
        (((this * 100).roundToDouble()) * 0.01).toStringAsFixed(amount));
  }
}

extension Doubles on Object {
  double toDouble() {
    if (this is double) {
      return this as double;
    }
    if (this is String) {
      return double.tryParse(this as String) ?? 0.0;
    }
    if (this is int) {
      return (this as int).toDouble();
    }
    return 0.0;
  }

  int toInt() {
    if (this is int) {
      return this as int;
    }
    if (this is String) {
      return int.tryParse(this as String) ?? 0;
    }
    if (this is double) {
      return (this as double).toInt();
    }
    return 0;
  }
}
