// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get home => 'Início';

  @override
  String get accounts => 'Contas';

  @override
  String get deposit => 'Depósito';

  @override
  String get withdrawal => 'Saque';

  @override
  String get transfer => 'Transferência';

  @override
  String get create_account => 'Criar conta';

  @override
  String get can_receive_cash_flows => 'Pode receber transações';

  @override
  String get select_parent => 'Selecionar conta principal';

  @override
  String get no_parent_selected => 'Nenhuma conta principal selecionada';

  @override
  String get no_parent => 'Sem conta principal';

  @override
  String get currencies => 'Moedas';

  @override
  String get select_a_currency => 'Selecione uma moeda';

  @override
  String get select_a_category => 'Selecione uma categoria';

  @override
  String get account_doesnt_own_currency =>
      'A conta de origem não possui saldo suficiente nesta moeda!';

  @override
  String get currency => 'Moeda';

  @override
  String get origin_account => 'Conta de origem';

  @override
  String get target_account => 'Conta de destino';

  @override
  String get set_main_currency => 'Definir moeda principal';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get select_account => 'Selecionar conta';

  @override
  String get no_account_selected => 'Nenhuma conta selecionada';

  @override
  String get set_main_account => 'Definir conta principal';

  @override
  String get set_as_main_account => 'Definir como conta principal';

  @override
  String get account_delete_sure =>
      'Tem certeza de que deseja excluir esta conta?';

  @override
  String get account_delete_has_children =>
      'A conta possui subcontas. Deseja excluí-las também?';

  @override
  String get children => 'Subcontas';

  @override
  String get reparent => 'Alterar conta principal';

  @override
  String get rename => 'Renomear';

  @override
  String get category => 'Categoria';

  @override
  String get add_transfer => 'Adicionar transferência';

  @override
  String get transfer_delete_sure =>
      'Tem certeza de que deseja excluir esta transferência?';

  @override
  String get transfer_options => 'Opções de transferência';

  @override
  String get add_cash_flow => 'Adicionar transação';

  @override
  String get cash_flow_delete_sure =>
      'Tem certeza de que deseja excluir esta transação?';

  @override
  String get cash_flow_options => 'Opções de transação';

  @override
  String get view_details => 'Ver detalhes';

  @override
  String get empty_number => 'O campo não pode estar vazio';

  @override
  String get accept => 'Confirmar';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get category_list => 'Lista de categorias';

  @override
  String get last_activities => 'Últimas atividades';

  @override
  String get delete => 'Excluir';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get currency_totals => 'Totais por moeda';

  @override
  String get show_all_accounts => 'Show All Accounts';
}
