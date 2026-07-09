// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home => 'Startseite';

  @override
  String get accounts => 'Konten';

  @override
  String get deposit => 'Einzahlung';

  @override
  String get withdrawal => 'Auszahlung';

  @override
  String get transfer => 'Überweisung';

  @override
  String get create_account => 'Konto erstellen';

  @override
  String get can_receive_cash_flows => 'Kann Transaktionen empfangen';

  @override
  String get select_parent => 'Hauptkonto auswählen';

  @override
  String get no_parent_selected => 'Kein Hauptkonto ausgewählt';

  @override
  String get no_parent => 'Kein Hauptkonto';

  @override
  String get currencies => 'Währungen';

  @override
  String get select_a_currency => 'Währung auswählen';

  @override
  String get select_a_category => 'Kategorie auswählen';

  @override
  String get account_doesnt_own_currency =>
      'Das Quellkonto hat nicht genügend Guthaben in dieser Währung!';

  @override
  String get currency => 'Währung';

  @override
  String get origin_account => 'Quellkonto';

  @override
  String get target_account => 'Zielkonto';

  @override
  String get set_main_currency => 'Hauptwährung festlegen';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get select_account => 'Konto auswählen';

  @override
  String get no_account_selected => 'Kein Konto ausgewählt';

  @override
  String get set_main_account => 'Hauptkonto festlegen';

  @override
  String get set_as_main_account => 'Als Hauptkonto festlegen';

  @override
  String get account_delete_sure =>
      'Sind Sie sicher, dass Sie dieses Konto löschen möchten?';

  @override
  String get account_delete_has_children =>
      'Das Konto hat Unterkonten. Möchten Sie diese ebenfalls löschen?';

  @override
  String get children => 'Unterkonten';

  @override
  String get reparent => 'Hauptkonto ändern';

  @override
  String get rename => 'Umbenennen';

  @override
  String get category => 'Kategorie';

  @override
  String get add_transfer => 'Überweisung hinzufügen';

  @override
  String get transfer_delete_sure =>
      'Sind Sie sicher, dass Sie diese Überweisung löschen möchten?';

  @override
  String get transfer_options => 'Überweisungsoptionen';

  @override
  String get add_cash_flow => 'Transaktion hinzufügen';

  @override
  String get cash_flow_delete_sure =>
      'Sind Sie sicher, dass Sie diese Transaktion löschen möchten?';

  @override
  String get cash_flow_options => 'Transaktionsoptionen';

  @override
  String get view_details => 'Details anzeigen';

  @override
  String get empty_number => 'Das Feld darf nicht leer sein';

  @override
  String get accept => 'Bestätigen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get category_list => 'Kategorieliste';

  @override
  String get last_activities => 'Letzte Aktivitäten';

  @override
  String get delete => 'Löschen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get currency_totals => 'Währungssummen';

  @override
  String get show_all_accounts => 'Show All Accounts';
}
