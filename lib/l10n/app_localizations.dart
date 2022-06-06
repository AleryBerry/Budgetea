import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pl'),
    Locale('ru')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @can_receive_cash_flows.
  ///
  /// In en, this message translates to:
  /// **'Can Receive Cash Flows'**
  String get can_receive_cash_flows;

  /// No description provided for @select_parent.
  ///
  /// In en, this message translates to:
  /// **'Select Parent'**
  String get select_parent;

  /// No description provided for @no_parent_selected.
  ///
  /// In en, this message translates to:
  /// **'No parent selected'**
  String get no_parent_selected;

  /// No description provided for @no_parent.
  ///
  /// In en, this message translates to:
  /// **'No parent'**
  String get no_parent;

  /// No description provided for @currencies.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currencies;

  /// No description provided for @select_a_currency.
  ///
  /// In en, this message translates to:
  /// **'Select a Currency'**
  String get select_a_currency;

  /// No description provided for @select_a_category.
  ///
  /// In en, this message translates to:
  /// **'Select a Category'**
  String get select_a_category;

  /// No description provided for @account_doesnt_own_currency.
  ///
  /// In en, this message translates to:
  /// **'Origin account doesn\'t own that much of this currency!'**
  String get account_doesnt_own_currency;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @origin_account.
  ///
  /// In en, this message translates to:
  /// **'Origin Account'**
  String get origin_account;

  /// No description provided for @target_account.
  ///
  /// In en, this message translates to:
  /// **'Target Account'**
  String get target_account;

  /// No description provided for @set_main_currency.
  ///
  /// In en, this message translates to:
  /// **'Set Main Currency'**
  String get set_main_currency;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @select_account.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get select_account;

  /// No description provided for @no_account_selected.
  ///
  /// In en, this message translates to:
  /// **'No Account Selected'**
  String get no_account_selected;

  /// No description provided for @set_main_account.
  ///
  /// In en, this message translates to:
  /// **'Set Main Account'**
  String get set_main_account;

  /// No description provided for @set_as_main_account.
  ///
  /// In en, this message translates to:
  /// **'Set As Main Account'**
  String get set_as_main_account;

  /// No description provided for @account_delete_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account?'**
  String get account_delete_sure;

  /// No description provided for @account_delete_has_children.
  ///
  /// In en, this message translates to:
  /// **'The account has children, do you want them to be deleted too?'**
  String get account_delete_has_children;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @reparent.
  ///
  /// In en, this message translates to:
  /// **'Reparent'**
  String get reparent;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @add_transfer.
  ///
  /// In en, this message translates to:
  /// **'Add Transfer'**
  String get add_transfer;

  /// No description provided for @transfer_delete_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transfer?'**
  String get transfer_delete_sure;

  /// No description provided for @transfer_options.
  ///
  /// In en, this message translates to:
  /// **'Transfer Options'**
  String get transfer_options;

  /// No description provided for @add_cash_flow.
  ///
  /// In en, this message translates to:
  /// **'Add Cash Flow'**
  String get add_cash_flow;

  /// No description provided for @cash_flow_delete_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this cash flow?'**
  String get cash_flow_delete_sure;

  /// No description provided for @cash_flow_options.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Options'**
  String get cash_flow_options;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @empty_number.
  ///
  /// In en, this message translates to:
  /// **'Empty Number'**
  String get empty_number;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @category_list.
  ///
  /// In en, this message translates to:
  /// **'Category List'**
  String get category_list;

  /// No description provided for @last_activities.
  ///
  /// In en, this message translates to:
  /// **'Last Activities'**
  String get last_activities;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @currency_totals.
  ///
  /// In en, this message translates to:
  /// **'Currency Totals'**
  String get currency_totals;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pl', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
