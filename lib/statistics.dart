import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/main.dart";
import "package:my_app/models/account.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/utils/currency_fetch.dart";
import "package:sqflite_common/sqlite_api.dart";

class MonthlyCashFlow {
  final String month;
  final double income;
  final double expense;

  MonthlyCashFlow(this.month, this.income, this.expense);
}

class CategoryExpense {
  final String name;
  final double total;

  CategoryExpense(this.name, this.total);
}

class BalanceOverTime {
  final DateTime date;
  final double balance;

  BalanceOverTime(this.date, this.balance);
}

class DailyCandlestickData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  DailyCandlestickData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
  });

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final DataRequest<List<MonthlyCashFlow>> monthlyCashFlowSnapshot = 
      DataRequest<List<MonthlyCashFlow>>(<MonthlyCashFlow>[]);
  final DataRequest<List<CategoryExpense>> categoryExpenseSnapshot = 
      DataRequest<List<CategoryExpense>>(<CategoryExpense>[]);
  final DataRequest<List<DailyCandlestickData>> balanceOverTimeSnapshot = 
      DataRequest<List<DailyCandlestickData>>(<DailyCandlestickData>[]);

  final List<Color> colors = <Color>[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
  ];

  int accountId = Constants.accountId;

  final Map<int, Currency> _currencyCache = <int, Currency>{};
  final Map<int, double> _rateCache = <int, double>{};

  Future<double> _getRate(int currencyId, Currency mainCurrency) async {
    Currency currency;
    if (_currencyCache.containsKey(currencyId)) {
      currency = _currencyCache[currencyId]!;
    } else {
      final Database db = BudgeteaDatabase.database!;
      final Map<String, Object?> currencyJson = (await db.query("currency", where: "id = ?", whereArgs: <Object?>[currencyId])).first;
      currency = Currency.fromJson(currencyJson);
      _currencyCache[currencyId] = currency;
    }

    double rate;
    if (_rateCache.containsKey(currencyId)) {
      rate = _rateCache[currencyId]!;
    } else {
      rate = await getExchangeRate(currency, mainCurrency);
      _rateCache[currencyId] = rate;
    }
    return rate;
  }

  void fetchData() async {
    final int mainCurrencyId = (await SharedPreferences.getInstance()).getInt("main_currency") ?? 140;
    final Currency mainCurrency = Currency(id: mainCurrencyId);

    // Monthly Cash Flow
    final List<Map<String, Object?>> monthlyRawData = 
        await BudgeteaDatabase().getMonthlyCashFlow(accountId);
    final Map<String, (double, double)> monthlyAggregates = <String, (double, double)>{};
    for (final Map<String, Object?> row in monthlyRawData) {
      final String month = row["month"] as String;
      final int currencyId = row["currency"] as int;
      final double income = (row["income"] as num).toDouble();
      final double expense = (row["expense"] as num).toDouble();

      final double rate = await _getRate(currencyId, mainCurrency);

      final (double currentIncome, double currentExpense) = monthlyAggregates[month] ?? (0.0, 0.0);
      monthlyAggregates[month] = (currentIncome + income * rate, currentExpense + expense * rate);
    }
    final List<MonthlyCashFlow> processedMonthlyData = monthlyAggregates.entries
        .map((MapEntry<String, (double, double)> entry) => MonthlyCashFlow(entry.key, entry.value.$1, entry.value.$2))
        .toList();
    monthlyCashFlowSnapshot.replace(processedMonthlyData);

    // Category Expenses
    final List<Map<String, Object?>> categoryRawData = 
        await BudgeteaDatabase().getCategoryExpenses(accountId);
    final Map<String, double> categoryAggregates = <String, double>{};
    for (final Map<String, Object?> row in categoryRawData) {
      final String name = row["name"] as String;
      final int currencyId = row["currency"] as int;
      final double total = (row["total"] as num).toDouble();

      final double rate = await _getRate(currencyId, mainCurrency);

      categoryAggregates.update(name, (double value) => value + total * rate, ifAbsent: () => total * rate);
    }
    final List<CategoryExpense> processedCategoryData = categoryAggregates.entries
        .map((MapEntry<String, double> entry) => CategoryExpense(entry.key, entry.value))
        .toList();
    categoryExpenseSnapshot.replace(processedCategoryData);

    // Balance Over Time
    final List<Map<String, Object?>> balanceRawData = 
        await BudgeteaDatabase().getBalanceOverTime(accountId);
    
    final Map<DateTime, List<double>> dailyBalances = <DateTime, List<double>>{};
    double currentBalance = 0.0;
    
    // Sort raw data by date to ensure correct running balance calculation
    final List<Map<String, Object?>> sortableBalanceRawData = balanceRawData.toList();
    sortableBalanceRawData.sort((a, b) => DateTime.parse(a["date"] as String).compareTo(DateTime.parse(b["date"] as String)));

    for (final Map<String, Object?> row in sortableBalanceRawData) {
      final DateTime date = DateTime.parse(row["date"] as String);
      final double amount = (row["amount"] as num).toDouble();
      final int currencyId = row["currency"] as int;

      final double rate = await _getRate(currencyId, mainCurrency);

      currentBalance += amount * rate;
      final DateTime truncatedDate = DateTime(date.year, date.month, date.day);
      dailyBalances.putIfAbsent(truncatedDate, () => <double>[]).add(currentBalance);
    }

    final List<DailyCandlestickData> processedCandlestickData = <DailyCandlestickData>[];
    final List<DateTime> sortedDates = dailyBalances.keys.toList()..sort();

    for (final DateTime date in sortedDates) {
      final List<double> balances = dailyBalances[date]!;
      if (balances.isNotEmpty) {
        final double open = balances.first;
        final double close = balances.last;
        final double high = balances.reduce(max);
        final double low = balances.reduce(min);
        processedCandlestickData.add(DailyCandlestickData(
          date: date,
          open: open,
          high: high,
          low: low,
          close: close,
        ));
      }
    }
    balanceOverTimeSnapshot.replace(processedCandlestickData);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight, left: 8, right: 8),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropDownCustom<Account>(
              label: "Account",
              table: "account",
              onSelected: (Account account) {
                setState(() {
                  accountId = account.id;
                });
                fetchData();
              },
              child: (Account account) {
                return Text(account.name);
              },
              getType: (List<Map<String, Object?>> json) {
                return json.map(Account.fromJson).toList();
              },
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Balance Over Time",
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(
                      height: 300,
                      child: ListenableBuilder(
                        listenable: balanceOverTimeSnapshot,
                        builder: (BuildContext context, Widget? _) {
                          if (balanceOverTimeSnapshot.data.isEmpty) {
                            return const Center(
                                child: Text("No balance data"));
                          }
                          final List<DailyCandlestickData> data = balanceOverTimeSnapshot.data;
                          
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width:
                                  max(data.length * 50.0, 500),
                              child: CandlestickChart(
                                CandlestickChartData(
                                  candlestickSpots: data
                                      .map((DailyCandlestickData e) {
                                        return CandlestickSpot(
                                          x: e.date.millisecondsSinceEpoch.toDouble(),
                                          open: e.open,
                                          high: e.high,
                                          low: e.low,
                                          close: e.close,
                                        );
                                      }).toList(),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (double value, 
                                            TitleMeta meta) {
                                          final DateTime date = 
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      value.toInt());
                                          return Text(DateFormat("d MMM").format(date));
                                        },
                                        reservedSize: 30,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (double value, TitleMeta meta) {
                                          final NumberFormat format = NumberFormat.compactSimpleCurrency(locale: Constants.locale);
                                          return Text(format.format(value));
                                        },
                                        reservedSize: 40,
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Monthly Cash Flow",
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(
                      height: 300,
                      child: ListenableBuilder(
                        listenable: monthlyCashFlowSnapshot,
                        builder: (BuildContext context, Widget? _) {
                          if (monthlyCashFlowSnapshot.data.isEmpty) {
                            return const Center(
                                child: Text("No monthly data"));
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width:
                                  max(monthlyCashFlowSnapshot.data.length * 100.0, 500),
                              child: BarChart(
                                BarChartData(
                                  barGroups:
                                      monthlyCashFlowSnapshot.data.map((MonthlyCashFlow e) {
                                    final String month = e.month.split("-").last;
                                    return BarChartGroupData(
                                      x: int.parse(month),
                                      barRods: <BarChartRodData>[
                                        BarChartRodData(
                                          toY: e.income,
                                          color: Colors.green,
                                          width: 8,
                                        ),
                                        BarChartRodData(
                                          toY: e.expense.abs(),
                                          color: Colors.red,
                                          width: 8,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (double value,
                                            TitleMeta meta) {
                                          return Text(
                                            DateFormat.MMM().format(
                                              DateTime(0, value.toInt()),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (double value, TitleMeta meta) {
                                          final NumberFormat format = NumberFormat.compactSimpleCurrency(locale: Constants.locale);
                                          return Text(format.format(value));
                                        },
                                        reservedSize: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Expenses by Category",
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(
                      height: 300,
                      child: ListenableBuilder(
                        listenable: categoryExpenseSnapshot,
                        builder: (BuildContext context, Widget? _) {
                          if (categoryExpenseSnapshot.data.isEmpty) {
                            return const Center(
                                child: Text("No category data"));
                          }
                          final double total = categoryExpenseSnapshot.data
                              .map((CategoryExpense e) => e.total)
                              .reduce((double a, double b) => a + b);
                          return PieChart(
                            PieChartData(
                              sections: categoryExpenseSnapshot.data
                                  .asMap()
                                  .entries
                                  .map((MapEntry<int, CategoryExpense> e) {
                                final double percentage =
                                    (e.value.total / total * 100).abs();
                                return PieChartSectionData(
                                  value: e.value.total.abs(),
                                  title: "",
                                  color: colors[e.key % colors.length],
                                  badgeWidget: _Badge(
                                    "${e.value.name}\n${percentage.toStringAsFixed(2)}%",
                                    size: 40,
                                    borderColor: HSLColor.fromColor(
                                            colors[e.key % colors.length])
                                        .withLightness(0.3)
                                        .toColor(),
                                  ),
                                  badgePositionPercentageOffset: .98,
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });
  final String text;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
