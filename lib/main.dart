import "package:adaptive_theme/adaptive_theme.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:currency_text_input_formatter/currency_text_input_formatter.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_speed_dial/flutter_speed_dial.dart";
import "package:intl/intl.dart";
import "package:intl/intl_standalone.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/constants.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/models/category.dart";
import "package:my_app/screens/accounts/account_creation.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:my_app/screens/overview/overview.dart";
import "package:my_app/screens/transaction/cashflow_add.dart";
import "package:my_app/screens/transaction/dropdown_custom.dart";
import "package:my_app/screens/transaction/transaction_form.dart";
import "package:my_app/statistics.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BudgeteaDatabase.database =
      await BudgeteaDatabase.initDB("budgetea/budgetea_database.db");
  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  Constants.locale = await findSystemLocale();
  Constants.accountId =
      (await SharedPreferences.getInstance()).getInt("main_account") ?? 0;

  runApp(
    AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData(
        tooltipTheme: TooltipThemeData(
          decoration: ShapeDecoration(
            color: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ).surfaceBright,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          textStyle: TextStyle(
            color: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ).onSurface,
          ),
        ),
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (ThemeData theme, ThemeData darkTheme) {
        return MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale("en"),
            Locale("es"),
            Locale("pl"),
            Locale("ru"),
          ],
          theme: theme,
          darkTheme: darkTheme,
          title: "Budgeta",
          home: const Home(),
        );
      },
    ),
  );
}

class Constants {
  static String locale = "en_US";
  static int accountId = 0;
  static CurrencyTextInputFormatter formatter(Currency? currency) {
    return CurrencyTextInputFormatter.simpleCurrency(
      name: "",
      enableNegative: false,
      locale: Constants.locale,
      decimalDigits: currency?.decimalPoints ?? 2,
    );
  }

  static CurrencyTextInputFormatter formatterCompact(Currency? currency) {
    return CurrencyTextInputFormatter(NumberFormat.compactSimpleCurrency(
      name: "",
      locale: Constants.locale,
      decimalDigits: currency?.decimalPoints ?? 2,
    ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _page = 0;
  late PageController _c;
  final AccountsList _accountsPage = AccountsList();
  final Overview _overviewPage = Overview();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Provider<HomeState>.value(
      value: this,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Padding(
          padding: MediaQuery.of(context).padding,
          child: Drawer(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.account_tree),
                  title: Text(AppLocalizations.of(context)!.set_main_account),
                  onTap: () => accountSelector(context).then(
                    (Account? account) async {
                      if (account != null) {
                        (await SharedPreferences.getInstance())
                            .setInt("main_account", account.id);
                      }
                      if (!context.mounted) return;
                      _overviewPage.fetchData();
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: Text(AppLocalizations.of(context)!.set_main_currency),
                  onTap: () async {
                    final Currency? currency = await showDialog<Currency>(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: DropDownCustom<Currency>(
                            label: AppLocalizations.of(context)!.currency,
                            table: "currency",
                            getType: (List<Map<String, Object?>> json) =>
                                json.map(Currency.fromJson).toList(),
                            onSelected: (Currency currency) {
                              Navigator.pop(context, currency);
                            },
                            child: (Currency element) => Row(
                              children: <StatelessWidget?>[
                                element.logoUrl.isEmpty
                                    ? null
                                    : CachedNetworkImage(
                                        imageUrl: element.logoUrl,
                                        width: 22,
                                        height: 22,
                                      ),
                                Text(
                                    "${element.type == CurrencyType.crypto ? "" : element.getEmoji()} ${element.name} (${element.iso})"),
                              ].nonNulls.toList(),
                            ),
                          ),
                        );
                      },
                    );
                    if (currency == null) return;
                    (await SharedPreferences.getInstance())
                        .setInt("main_currency", currency.id);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    _overviewPage.fetchData();
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.category_list),
                  onTap: () async {
                    final List<CategoryWithUsage> categories =
                        await BudgeteaDatabase().getCategoriesWithUsageCount();
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(
                              AppLocalizations.of(context)!.category_list),
                          children: [
                            SizedBox(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final CategoryWithUsage category =
                                      categories[index];
                                  final IconData? iconData =
                                      category.getIconData();
                                  final Color? iconColor =
                                      category.getIconColor();
                                  return ListTile(
                                    leading: iconData != null
                                        ? Icon(iconData, color: iconColor)
                                        : null,
                                    title: Text(category.name),
                                    trailing: Text(
                                        category.transactionCount.toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: <Widget?>[
            ValueListenableBuilder<AdaptiveThemeMode>(
              valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
              builder:
                  (BuildContext context, AdaptiveThemeMode mode, Widget? _) {
                return IconButton(
                  onPressed: () {
                    AdaptiveTheme.of(context).toggleThemeMode(useSystem: false);
                  },
                  icon: Icon(
                    mode == AdaptiveThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () => _openEndDrawer(),
              icon: const Icon(Icons.settings),
            ),
          ].nonNulls.toList(),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: (int index) {
            _c.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.pie_chart),
              label: AppLocalizations.of(context)!.statistics,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.wallet),
              label: AppLocalizations.of(context)!.accounts,
            ),
          ],
        ),
        body: Padding(
          padding: MediaQuery.of(context).padding,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: _c,
              onPageChanged: (int newPage) => setState(() => _page = newPage),
              children: <Widget>[
                _overviewPage,
                Statistics(),
                _accountsPage,
              ],
            ),
          ),
        ),
        floatingActionButton: _page == 0
            ? SpeedDial(
                renderOverlay: false,
                icon: (Icons.add),
                spacing: 12,
                animatedIcon: AnimatedIcons.menu_close,
                spaceBetweenChildren: 15,
                children: <SpeedDialChild>[
                    SpeedDialChild(
                      child: const Icon(Icons.compare_arrows),
                      label: AppLocalizations.of(context)!.transfer,
                      onTap: () async {
                        final bool result = await Navigator.push<bool>(
                              context,
                              PageRouteBuilder<bool>(
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  const Offset begin = Offset(0.0, 1.0);
                                  const Offset end = Offset.zero;
                                  const Cubic curve = Curves.ease;

                                  Animatable<Offset> tween =
                                      Tween<Offset>(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                        Animation<double> _,
                                        Animation<double> __) =>
                                    TransactionForm(),
                              ),
                            ) ??
                            false;
                        if (result) {
                          _overviewPage.fetchData();
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.arrow_upward),
                      label: AppLocalizations.of(context)!.withdrawal,
                      onTap: () async {
                        final bool result = await Navigator.push<bool>(
                              context,
                              PageRouteBuilder<bool>(
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  const Offset begin = Offset(0.0, 1.0);
                                  const Offset end = Offset.zero;
                                  const Cubic curve = Curves.ease;

                                  Animatable<Offset> tween =
                                      Tween<Offset>(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> _, Animation<double> __) {
                                  return CashFlowForm(
                                    type: TransactionType.gasto,
                                  );
                                },
                              ),
                            ) ??
                            false;
                        if (result) {
                          _overviewPage.fetchData();
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(
                        Icons.arrow_downward,
                      ),
                      label: AppLocalizations.of(context)!.deposit,
                      onTap: () async {
                        final bool result = await Navigator.push<bool>(
                              context,
                              PageRouteBuilder<bool>(
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  const Offset begin = Offset(0.0, 1.0);
                                  const Offset end = Offset.zero;
                                  const Cubic curve = Curves.ease;

                                  Animatable<Offset> tween =
                                      Tween<Offset>(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> _, Animation<double> __) {
                                  return CashFlowForm(
                                    type: TransactionType.ingreso,
                                  );
                                },
                              ),
                            ) ??
                            false;
                        if (result && context.mounted) {
                          _overviewPage.fetchData(context: context);
                        }
                      },
                    )
                  ])
            : _page == 2
                ? FloatingActionButton(
                    onPressed: () async {
                      if (await Navigator.push<bool>(
                            context,
                            PageRouteBuilder<bool>(
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                const Offset begin = Offset(0.0, 1.0);
                                const Offset end = Offset.zero;
                                const Cubic curve = Curves.ease;

                                Animatable<Offset> tween =
                                    Tween<Offset>(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context,
                                  Animation<double> _, Animation<double> __) {
                                return const AccountCreation();
                              },
                            ),
                          ) ??
                          false) {
                        _accountsPage.fetchData();
                      }
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
      ),
    );
  }

  void fetchData() {
    _accountsPage.fetchData();
    _overviewPage.fetchData();
  }

  @override
  void initState() {
    _c = PageController(
      initialPage: _page,
    );
    super.initState();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  static HomeState of(BuildContext context) => context.read<HomeState>();
}
