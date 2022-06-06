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
  String get deposit => 'Depozyt';

  @override
  String get withdrawal => 'Wycofanie';

  @override
  String get transfer => 'Transfer';

  @override
  String get create_account => 'Utwórz Konto';

  @override
  String get can_receive_cash_flows => 'Może otrzywać przepływy pieniężne';

  @override
  String get select_parent => 'Wybierz rodzica';

  @override
  String get no_parent_selected => 'Nie wybrano żadnego rodzica';

  @override
  String get no_parent => 'Żadnego rodzica';

  @override
  String get currencies => 'Waluty';

  @override
  String get select_a_currency => 'Wybierz walutę';

  @override
  String get select_a_category => 'Wybierz kategorię';

  @override
  String get account_doesnt_own_currency =>
      'Konto Origin nie posiada tak dużej ilości tej waluty!';

  @override
  String get currency => 'Waluta';

  @override
  String get origin_account => 'Konto pochodzenia';

  @override
  String get target_account => 'Konto docelowe';

  @override
  String get set_main_currency => 'Ustaw główną walutę';

  @override
  String get name => 'Nazwa';

  @override
  String get description => 'Opis';

  @override
  String get select_account => 'Wybierz Konto';

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
      'Konto ma dzieci, czy mają one również zostać usunięte?';

  @override
  String get children => 'Dzieci';

  @override
  String get reparent => 'Reparentny';

  @override
  String get rename => 'zmiana nazwy';

  @override
  String get category => 'Kategoria';

  @override
  String get add_transfer => 'Dodaj transfer';

  @override
  String get transfer_delete_sure => 'Czy na pewno chcesz usunąć ten transfer?';

  @override
  String get transfer_options => 'Opcje transferu';

  @override
  String get add_cash_flow => 'Dodaj przepływy pieniężne';

  @override
  String get cash_flow_delete_sure =>
      'Czy na pewno chcesz usunąć ten przepływ gotówki?';

  @override
  String get cash_flow_options => 'Opcje przepływów pieniężnych';

  @override
  String get view_details => 'zobacz szczegóły';

  @override
  String get empty_number => 'Pusta liczba';

  @override
  String get accept => 'Przyjąć';

  @override
  String get statistics => 'Statystyka';

  @override
  String get category_list => 'Lista kategorii';

  @override
  String get last_activities => 'Ostatnie zajęcia';

  @override
  String get delete => 'Usuń';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get currency_totals => 'Sumy Walut';
}
