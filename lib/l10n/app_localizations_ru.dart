// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get home => 'Главная';

  @override
  String get accounts => 'Счета';

  @override
  String get deposit => 'Депозит';

  @override
  String get withdrawal => 'Вывести';

  @override
  String get transfer => 'Передача';

  @override
  String get create_account => 'Создать аккаунт';

  @override
  String get can_receive_cash_flows => 'может получать денежные потоки';

  @override
  String get select_parent => 'Выберите родителя';

  @override
  String get no_parent_selected => 'Родители не выбраны';

  @override
  String get no_parent => 'Нет родителей';

  @override
  String get currencies => 'Валюты';

  @override
  String get select_a_currency => 'Выберите валюту';

  @override
  String get select_a_category => 'Выберите категорию';

  @override
  String get account_doesnt_own_currency =>
      'Аккаунт Origin не владеет такой большой из этой валюты!';

  @override
  String get currency => 'Валюта';

  @override
  String get origin_account => 'Учетная запись происхождения';

  @override
  String get target_account => 'Целевой счет';

  @override
  String get set_main_currency => 'Установите основную валюту';

  @override
  String get name => 'Имя';

  @override
  String get description => 'Описание';

  @override
  String get select_account => 'Выберите счет';

  @override
  String get no_account_selected => 'Счет не выбран';

  @override
  String get set_main_account => 'Установите основной счет';

  @override
  String get set_as_main_account =>
      'Установите в качестве основной учетной записи';

  @override
  String get account_delete_sure =>
      'Вы уверены, что хотите удалить эту учетную запись?';

  @override
  String get account_delete_has_children =>
      'У аккаунта есть дети, хотите ли вы, чтобы они тоже были удалены?';

  @override
  String get children => 'дети';

  @override
  String get reparent => 'Репарант';

  @override
  String get rename => 'переименовать';

  @override
  String get category => 'Категория';

  @override
  String get add_transfer => 'Добавить трансфер';

  @override
  String get transfer_delete_sure =>
      'Вы уверены, что хотите удалить эту передачу?';

  @override
  String get transfer_options => 'Варианты передачи';

  @override
  String get add_cash_flow => 'Добавить денежный поток';

  @override
  String get cash_flow_delete_sure =>
      'Вы уверены, что хотите удалить этот денежный поток?';

  @override
  String get cash_flow_options => 'Варианты денежных потоков';

  @override
  String get view_details => 'просмотреть детали';

  @override
  String get empty_number => 'Пустой номер';

  @override
  String get accept => 'Принимать';

  @override
  String get statistics => 'Статистика';

  @override
  String get category_list => 'Список категорий';

  @override
  String get last_activities => 'Последнее занятие';

  @override
  String get delete => 'Удалить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get currency_totals => 'Итоги по валютам';
}
