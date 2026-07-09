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
  String get deposit => 'Пополнение';

  @override
  String get withdrawal => 'Снятие';

  @override
  String get transfer => 'Перевод';

  @override
  String get create_account => 'Создать счёт';

  @override
  String get can_receive_cash_flows => 'Может участвовать в транзакциях';

  @override
  String get select_parent => 'Выберите родительский счет';

  @override
  String get no_parent_selected => 'Родительский счет не выбран';

  @override
  String get no_parent => 'Нет родительского счета';

  @override
  String get currencies => 'Валюты';

  @override
  String get select_a_currency => 'Выберите валюту';

  @override
  String get select_a_category => 'Выберите категорию';

  @override
  String get account_doesnt_own_currency =>
      'На исходном счете недостаточно средств в этой валюте!';

  @override
  String get currency => 'Валюта';

  @override
  String get origin_account => 'Исходный счет';

  @override
  String get target_account => 'Счет зачисления';

  @override
  String get set_main_currency => 'Установите основную валюту';

  @override
  String get name => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get select_account => 'Выберите счет';

  @override
  String get no_account_selected => 'Счет не выбран';

  @override
  String get set_main_account => 'Установите основной счет';

  @override
  String get set_as_main_account => 'Установить как основной счет';

  @override
  String get account_delete_sure => 'Вы уверены, что хотите удалить этот счет?';

  @override
  String get account_delete_has_children =>
      'У счета есть дочерние счета, удалить их тоже?';

  @override
  String get children => 'Дочерние счета';

  @override
  String get reparent => 'Изменить родительский счет';

  @override
  String get rename => 'Переименовать';

  @override
  String get category => 'Категория';

  @override
  String get add_transfer => 'Добавить перевод';

  @override
  String get transfer_delete_sure =>
      'Вы уверены, что хотите удалить этот перевод?';

  @override
  String get transfer_options => 'Параметры перевода';

  @override
  String get add_cash_flow => 'Добавить денежный поток';

  @override
  String get cash_flow_delete_sure =>
      'Вы уверены, что хотите удалить этот денежный поток?';

  @override
  String get cash_flow_options => 'Параметры денежного потока';

  @override
  String get view_details => 'Просмотреть детали';

  @override
  String get empty_number => 'Поле не может быть пустым';

  @override
  String get accept => 'Подтвердить';

  @override
  String get statistics => 'Статистика';

  @override
  String get category_list => 'Список категорий';

  @override
  String get last_activities => 'Последние действия';

  @override
  String get delete => 'Удалить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get currency_totals => 'Итоги по валютам';

  @override
  String get show_all_accounts => 'Показать все счета';
}
