// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get accounts => 'Comptes';

  @override
  String get deposit => 'Dépôt';

  @override
  String get withdrawal => 'Retrait';

  @override
  String get transfer => 'Virement';

  @override
  String get create_account => 'Créer un compte';

  @override
  String get can_receive_cash_flows => 'Peut recevoir des transactions';

  @override
  String get select_parent => 'Sélectionner le compte principal';

  @override
  String get no_parent_selected => 'Aucun compte principal sélectionné';

  @override
  String get no_parent => 'Pas de compte principal';

  @override
  String get currencies => 'Devises';

  @override
  String get select_a_currency => 'Sélectionner une devise';

  @override
  String get select_a_category => 'Sélectionner une catégorie';

  @override
  String get account_doesnt_own_currency =>
      'Le compte d\'origine ne possède pas suffisamment de fonds dans cette devise !';

  @override
  String get currency => 'Devise';

  @override
  String get origin_account => 'Compte source';

  @override
  String get target_account => 'Compte de destination';

  @override
  String get set_main_currency => 'Définir la devise principale';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Description';

  @override
  String get select_account => 'Sélectionner un compte';

  @override
  String get no_account_selected => 'Aucun compte sélectionné';

  @override
  String get set_main_account => 'Définir le compte principal';

  @override
  String get set_as_main_account => 'Définir comme compte principal';

  @override
  String get account_delete_sure =>
      'Êtes-vous sûr de vouloir supprimer ce compte ?';

  @override
  String get account_delete_has_children =>
      'Le compte a des sous-comptes. Voulez-vous également les supprimer ?';

  @override
  String get children => 'Sous-comptes';

  @override
  String get reparent => 'Modifier le compte principal';

  @override
  String get rename => 'Renommer';

  @override
  String get category => 'Catégorie';

  @override
  String get add_transfer => 'Ajouter un virement';

  @override
  String get transfer_delete_sure =>
      'Êtes-vous sûr de vouloir supprimer ce virement ?';

  @override
  String get transfer_options => 'Options de virement';

  @override
  String get add_cash_flow => 'Ajouter une transaction';

  @override
  String get cash_flow_delete_sure =>
      'Êtes-vous sûr de vouloir supprimer cette transaction ?';

  @override
  String get cash_flow_options => 'Options de transaction';

  @override
  String get view_details => 'Voir les détails';

  @override
  String get empty_number => 'Le champ ne peut pas être vide';

  @override
  String get accept => 'Confirmer';

  @override
  String get statistics => 'Statistiques';

  @override
  String get category_list => 'Liste des catégories';

  @override
  String get last_activities => 'Dernières activités';

  @override
  String get delete => 'Supprimer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get currency_totals => 'Totaux par devise';

  @override
  String get show_all_accounts => 'Show All Accounts';
}
