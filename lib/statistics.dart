import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:my_app/home/balance.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/screens/accounts/accounts.dart";

class Statistics extends StatelessWidget {
  Statistics({
    super.key,
  });
  final DataRequest<(Currency, double, double, double)> snapshot =
      DataRequest<(Currency, double, double, double)>(
          (const Currency(), 1, 1, 0));
  void fetchData() async {
    snapshot.replace(await getWinsAndLosses());
  }

  @override
  Widget build(BuildContext context) {
    if (!snapshot.fetched) fetchData();
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListenableBuilder(
              listenable: snapshot,
              builder: (BuildContext context, Widget? _) {
                final double total =
                    snapshot.data.$3.abs() + snapshot.data.$4.abs();
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double radius =
                        min(constraints.maxWidth, constraints.maxHeight) * 0.5;
                    return PieChart(
                      duration: Durations.long1,
                      curve: Curves.linear,
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: <PieChartSectionData>[
                          PieChartSectionData(
                            titleStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                              shadows: <Shadow>[
                                Shadow(color: Colors.black, blurRadius: 2)
                              ],
                            ),
                            radius: radius,
                            value: total == 0
                                ? 1
                                : ((snapshot.data.$3.abs() / total) * 10)
                                    .roundToDouble(),
                            color: total == 0 ? Colors.grey : Colors.green[300],
                            title: total == 0 ? "No data" : "Gains",
                          ),
                          PieChartSectionData(
                            titleStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                              shadows: <Shadow>[
                                Shadow(color: Colors.black, blurRadius: 2)
                              ],
                            ),
                            radius: radius,
                            value: total == 0
                                ? 0
                                : ((snapshot.data.$4.abs() / total) * 10)
                                    .roundToDouble(),
                            color: Colors.red[300],
                            title: "Expenses",
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
