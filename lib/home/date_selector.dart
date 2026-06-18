import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:my_app/extension_methods/date_time.dart";

class DateSelector extends StatefulWidget {
  const DateSelector({super.key, this.onSelected});
  final void Function(DateTimeRange?)? onSelected;

  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  String? dropdownValue;
  DateTimeRange? range;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences instance) {
      final List<String>? list = instance.getStringList("date_range");
      if (list != null) {
        setState(
          () => range = DateTimeRange(
            start: DateTime.parse(list[0]),
            end: DateTime.parse(list[1]),
          ),
        );
        if (widget.onSelected != null) {
          widget.onSelected!(range);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (dropdownValue != null && dropdownValue != "All Time")
          Text(dropdownValue!),
        PopupMenuButton<String>(
          icon: const Icon(Icons.calendar_today),
          onSelected: (String newValue) async {
            if (newValue == "Custom Range...") {
              final DateTime now = DateTime.now().onlyDate();
              final DateTimeRange? pickedRange = await showDateRangePicker(
                context: context,
                firstDate: now.subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
              );
              if (pickedRange == null) return; // User cancelled
              setState(() {
                range = pickedRange;
                dropdownValue = newValue;
              });
            } else {
              setState(() {
                dropdownValue = newValue;
                final DateTime now = DateTime.now().onlyDate();
                switch (newValue) {
                  case "Today":
                    range = DateTimeRange(
                        start: now.subtract(const Duration(days: 1)),
                        end: now);
                    break;
                  case "Last Week":
                    range = DateTimeRange(
                        start: now.subtract(const Duration(days: 7)),
                        end: now);
                    break;
                  case "Last Month":
                    range = DateTimeRange(
                        start: now.subtract(const Duration(days: 30)),
                        end: now);
                    break;
                  case "Last Year":
                    range = DateTimeRange(
                        start: now.subtract(const Duration(days: 365)),
                        end: now);
                    break;
                  case "All Time":
                    range = null;
                    break;
                }
              });
            }

            if (widget.onSelected != null) {
              widget.onSelected!(range);
            }

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            if (range == null) {
              await prefs.remove("date_range");
            } else {
              await prefs.setStringList(
                "date_range",
                <String>[
                  range!.start.toIso8601String(),
                  range!.end.toIso8601String()
                ],
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <String>[
              "Today",
              "Last Week",
              "Last Month",
              "Last Year",
              "All Time",
              "Custom Range...",
            ].map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: (dropdownValue ?? "All Time") == value
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
