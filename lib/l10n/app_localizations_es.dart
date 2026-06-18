// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get accounts => 'Cuentas';

  @override
  String get deposit => 'Depositar';

  @override
  String get withdrawal => 'Retirar';

  @override
  String get transfer => 'Transferir';

  @override
  String get create_account => 'Crear cuenta';

  @override
  String get can_receive_cash_flows => 'Puede recibir flujos de dinero';

  @override
  String get select_parent => 'Seleccionar padre';

  @override
  String get no_parent_selected => 'Ningún padre seleccionado';

  @override
  String get no_parent => 'Sin padre';

  @override
  String get currencies => 'Monedas';

  @override
  String get select_a_currency => 'Selecciona una moneda';

  @override
  String get select_a_category => 'Selecciona una categoría';

  @override
  String get account_doesnt_own_currency =>
      'La cuenta de origen no posee tanta cantidad de esta moneda!';

  @override
  String get currency => 'Moneda';

  @override
  String get origin_account => 'Cuenta origen';

  @override
  String get target_account => 'Cuenta destino';

  @override
  String get set_main_currency => 'Establecer moneda principal';

  @override
  String get name => 'Nombre';

  @override
  String get description => 'Descripción';

  @override
  String get select_account => 'Seleccionar cuenta';

  @override
  String get no_account_selected => 'Ninguna cuenta seleccionada';

  @override
  String get set_main_account => 'Establecer cuenta principal';

  @override
  String get set_as_main_account => 'Establecer como cuenta principal';

  @override
  String get account_delete_sure =>
      '¿Estás seguro de que quieres eliminar esta cuenta?';

  @override
  String get account_delete_has_children =>
      'La cuenta tiene hijos, ¿quieres que también se eliminen?';

  @override
  String get children => 'Hijos';

  @override
  String get reparent => 'Reasignar padre';

  @override
  String get rename => 'Cambiar nombre';

  @override
  String get category => 'Categoría';

  @override
  String get add_transfer => 'Agregar transferencia';

  @override
  String get transfer_delete_sure =>
      '¿Estás seguro de que quieres eliminar esta transferencia?';

  @override
  String get transfer_options => 'Opciones de transferencia';

  @override
  String get add_cash_flow => 'Agregar flujo de efectivo';

  @override
  String get cash_flow_delete_sure =>
      '¿Estás seguro de que quieres eliminar este flujo de efectivo?';

  @override
  String get cash_flow_options => 'Opciones de flujo de efectivo';

  @override
  String get view_details => 'Ver detalles';

  @override
  String get empty_number => 'Número vacío';

  @override
  String get accept => 'Aceptar';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get category_list => 'Lista de categorías';

  @override
  String get last_activities => 'Últimas actividades';

  @override
  String get delete => 'Eliminar';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get currency_totals => 'Totales de Moneda';

  @override
  String get show_all_accounts => 'Mostrar todas las cuentas';
}
