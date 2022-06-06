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
  String get create_account => 'Create Account';

  @override
  String get can_receive_cash_flows => 'Can Receive Cash Flows';

  @override
  String get select_parent => 'Select Parent';

  @override
  String get no_parent_selected => 'No parent selected';

  @override
  String get no_parent => 'No parent';

  @override
  String get currencies => 'Currencies';

  @override
  String get select_a_currency => 'Select a Currency';

  @override
  String get select_a_category => 'Select a Category';

  @override
  String get account_doesnt_own_currency =>
      'Origin account doesn\'t own that much of this currency!';

  @override
  String get currency => 'Currency';

  @override
  String get origin_account => 'Origin Account';

  @override
  String get target_account => 'Target Account';

  @override
  String get set_main_currency => 'Set Main Currency';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get select_account => 'Select Account';

  @override
  String get no_account_selected => 'No Account Selected';

  @override
  String get set_main_account => 'Set Main Account';

  @override
  String get set_as_main_account => 'Set As Main Account';

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
  String get add_transfer => 'Add Transfer';

  @override
  String get transfer_delete_sure =>
      'Are you sure you want to delete this transfer?';

  @override
  String get transfer_options => 'Transfer Options';

  @override
  String get add_cash_flow => 'Add Cash Flow';

  @override
  String get cash_flow_delete_sure =>
      'Are you sure you want to delete this cash flow?';

  @override
  String get cash_flow_options => 'Cash Flow Options';

  @override
  String get view_details => 'View Details';

  @override
  String get empty_number => 'Empty Number';

  @override
  String get accept => 'Accept';

  @override
  String get statistics => 'Statistics';

  @override
  String get category_list => 'Category List';

  @override
  String get last_activities => 'Last Activities';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get currency_totals => 'Currency Totals';
}
