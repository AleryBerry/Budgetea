// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get home => 'Strona główna';

  @override
  String get accounts => 'Konta';

  @override
  String get deposit => 'Wpłata';

  @override
  String get withdrawal => 'Wypłata';

  @override
  String get transfer => 'Przelew';

  @override
  String get create_account => 'Utwórz konto';

  @override
  String get can_receive_cash_flows => 'Może przyjmować transakcje';

  @override
  String get select_parent => 'Wybierz konto nadrzędne';

  @override
  String get no_parent_selected => 'Nie wybrano konta nadrzędnego';

  @override
  String get no_parent => 'Brak konta nadrzędnego';

  @override
  String get currencies => 'Waluty';

  @override
  String get select_a_currency => 'Wybierz walutę';

  @override
  String get select_a_category => 'Wybierz kategorię';

  @override
  String get account_doesnt_own_currency =>
      'Na koncie źródłowym brak wystarczających środków w tej walucie!';

  @override
  String get currency => 'Waluta';

  @override
  String get origin_account => 'Konto źródłowe';

  @override
  String get target_account => 'Konto docelowe';

  @override
  String get set_main_currency => 'Ustaw główną walutę';

  @override
  String get name => 'Nazwa';

  @override
  String get description => 'Opis';

  @override
  String get select_account => 'Wybierz konto';

  @override
  String get no_account_selected => 'Nie wybrano konta';

  @override
  String get set_main_account => 'Ustaw główne konto';

  @override
  String get set_as_main_account => 'Ustaw jako konto główne';

  @override
  String get account_delete_sure => 'Czy na pewno chcesz usunąć to konto?';

  @override
  String get account_delete_has_children =>
      'Konto posiada konta podrzędne. Czy chcesz usunąć również je?';

  @override
  String get children => 'Konta podrzędne';

  @override
  String get reparent => 'Zmień konto nadrzędne';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get category => 'Kategoria';

  @override
  String get add_transfer => 'Dodaj transfer';

  @override
  String get transfer_delete_sure => 'Czy na pewno chcesz usunąć ten transfer?';

  @override
  String get transfer_options => 'Opcje transferu';

  @override
  String get add_cash_flow => 'Dodaj transakcję';

  @override
  String get cash_flow_delete_sure =>
      'Czy na pewno chcesz usunąć tę transakcję?';

  @override
  String get cash_flow_options => 'Opcje transakcji';

  @override
  String get view_details => 'Zobacz szczegóły';

  @override
  String get empty_number => 'Pole nie może być puste';

  @override
  String get accept => 'Zatwierdź';

  @override
  String get statistics => 'Statystyka';

  @override
  String get category_list => 'Lista kategorii';

  @override
  String get last_activities => 'Ostatnie aktywności';

  @override
  String get delete => 'Usuń';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get currency_totals => 'Sumy Walut';

  @override
  String get show_all_accounts => 'Pokaż wszystkie konta';
}
