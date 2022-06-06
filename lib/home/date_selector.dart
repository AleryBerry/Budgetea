import "package:flutter/material.dart";

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String dropdownValue = "Today";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text("Recent Activities"),
        DropdownButton<String>(
          value: dropdownValue,
          items: <String>[
            "Today",
            "Last Week",
            "Last Month",
            "Last Year",
            "All Time",
            "Custom Range",
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              dropdownValue = newValue!;
            });

            if (dropdownValue == "Custom Range") {
              DateTimeRange? pickedDate = await showDateRangePicker(
                context: context,
                initialDateRange: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now(),
                ),
                firstDate: DateTime(1991),
                lastDate: DateTime(2101),
              );
              debugPrint(pickedDate.toString());
            }
          },
          underline: const SizedBox(),
        ),
      ],
    );
  }
}
