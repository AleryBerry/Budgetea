// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get accounts => 'Accounts';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get transfer => 'Transfer';

  @override
  String get create_account => 'Create account';

  @override
  String get can_receive_cash_flows => 'Can receive cash flows';

  @override
  String get select_parent => 'Select parent';

  @override
  String get no_parent_selected => 'No parent selected';

  @override
  String get no_parent => 'No parent';

  @override
  String get currencies => 'Currencies';

  @override
  String get select_a_currency => 'Select a currency';

  @override
  String get select_a_category => 'Select a category';

  @override
  String get account_doesnt_own_currency =>
      'Origin account doesn\'t own that much of this currency!';

  @override
  String get currency => 'Currency';

  @override
  String get origin_account => 'Origin account';

  @override
  String get target_account => 'Target account';

  @override
  String get set_main_currency => 'Set main currency';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get select_account => 'Select account';

  @override
  String get no_account_selected => 'No account selected';

  @override
  String get set_main_account => 'Set main account';

  @override
  String get set_as_main_account => 'Set as main account';

  @override
  String get account_delete_sure =>
      'Are you sure you want to delete this account?';

  @override
  String get account_delete_has_children =>
      'The account has children, do you want them to be deleted too?';

  @override
  String get children => 'Children';

  @override
  String get reparent => 'Reparent';

  @override
  String get rename => 'Rename';

  @override
  String get category => 'Category';

  @override
  String get add_transfer => 'Add transfer';

  @override
  String get transfer_delete_sure =>
      'Are you sure you want to delete this transfer?';

  @override
  String get transfer_options => 'Transfer options';

  @override
  String get add_cash_flow => 'Add cash flow';

  @override
  String get cash_flow_delete_sure =>
      'Are you sure you want to delete this cash flow?';

  @override
  String get cash_flow_options => 'Cash flow options';

  @override
  String get view_details => 'View details';

  @override
  String get empty_number => 'Empty number';

  @override
  String get accept => 'Accept';

  @override
  String get statistics => 'Statistics';

  @override
  String get category_list => 'Category list';

  @override
  String get last_activities => 'Last activities';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get currency_totals => 'Currency Totals';

  @override
  String get show_all_accounts => 'Show All Accounts';
}
