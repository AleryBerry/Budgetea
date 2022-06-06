extension DateFormatting on DateTime {
  String formatStandard() {
    return '${day < 10 ? "0$day" : day}/${month < 10 ? "0$month" : month}/$year';
  }

  String formatStandardWithTime() {
    return '${day < 10 ? "0$day" : day}/${month < 10 ? "0$month" : month}/$year ${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}:${second < 10 ? "0$second" : second}';
  }

  DateTime onlyDate() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }
}
