// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('""'));
  static const VerificationMeta _canReceiveCashFlowsMeta =
      const VerificationMeta('canReceiveCashFlows');
  @override
  late final GeneratedColumn<bool> canReceiveCashFlows = GeneratedColumn<bool>(
      'can_receive_cash_flows', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_receive_cash_flows" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, name, canReceiveCashFlows];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('can_receive_cash_flows')) {
      context.handle(
          _canReceiveCashFlowsMeta,
          canReceiveCashFlows.isAcceptableOrUnknown(
              data['can_receive_cash_flows']!, _canReceiveCashFlowsMeta));
    } else if (isInserting) {
      context.missing(_canReceiveCashFlowsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      canReceiveCashFlows: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}can_receive_cash_flows'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final bool canReceiveCashFlows;
  const Account(
      {required this.id,
      required this.name,
      required this.canReceiveCashFlows});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['can_receive_cash_flows'] = Variable<bool>(canReceiveCashFlows);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      canReceiveCashFlows: Value(canReceiveCashFlows),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      canReceiveCashFlows:
          serializer.fromJson<bool>(json['canReceiveCashFlows']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'canReceiveCashFlows': serializer.toJson<bool>(canReceiveCashFlows),
    };
  }

  Account copyWith({int? id, String? name, bool? canReceiveCashFlows}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        canReceiveCashFlows: canReceiveCashFlows ?? this.canReceiveCashFlows,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      canReceiveCashFlows: data.canReceiveCashFlows.present
          ? data.canReceiveCashFlows.value
          : this.canReceiveCashFlows,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('canReceiveCashFlows: $canReceiveCashFlows')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, canReceiveCashFlows);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.canReceiveCashFlows == this.canReceiveCashFlows);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> canReceiveCashFlows;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.canReceiveCashFlows = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required bool canReceiveCashFlows,
  }) : canReceiveCashFlows = Value(canReceiveCashFlows);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? canReceiveCashFlows,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (canReceiveCashFlows != null)
        'can_receive_cash_flows': canReceiveCashFlows,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<bool>? canReceiveCashFlows}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      canReceiveCashFlows: canReceiveCashFlows ?? this.canReceiveCashFlows,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (canReceiveCashFlows.present) {
      map['can_receive_cash_flows'] = Variable<bool>(canReceiveCashFlows.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('canReceiveCashFlows: $canReceiveCashFlows')
          ..write(')'))
        .toString();
  }
}

class $AccountRelationshipsTable extends AccountRelationships
    with TableInfo<$AccountRelationshipsTable, AccountRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountRelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _parentAccountMeta =
      const VerificationMeta('parentAccount');
  @override
  late final GeneratedColumn<int> parentAccount = GeneratedColumn<int>(
      'parent_account', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _childAccountMeta =
      const VerificationMeta('childAccount');
  @override
  late final GeneratedColumn<int> childAccount = GeneratedColumn<int>(
      'child_account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, parentAccount, childAccount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_relationship';
  @override
  VerificationContext validateIntegrity(
      Insertable<AccountRelationship> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_account')) {
      context.handle(
          _parentAccountMeta,
          parentAccount.isAcceptableOrUnknown(
              data['parent_account']!, _parentAccountMeta));
    } else if (isInserting) {
      context.missing(_parentAccountMeta);
    }
    if (data.containsKey('child_account')) {
      context.handle(
          _childAccountMeta,
          childAccount.isAcceptableOrUnknown(
              data['child_account']!, _childAccountMeta));
    } else if (isInserting) {
      context.missing(_childAccountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRelationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRelationship(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      parentAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_account'])!,
      childAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}child_account'])!,
    );
  }

  @override
  $AccountRelationshipsTable createAlias(String alias) {
    return $AccountRelationshipsTable(attachedDatabase, alias);
  }
}

class AccountRelationship extends DataClass
    implements Insertable<AccountRelationship> {
  final int id;
  final int parentAccount;
  final int childAccount;
  const AccountRelationship(
      {required this.id,
      required this.parentAccount,
      required this.childAccount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_account'] = Variable<int>(parentAccount);
    map['child_account'] = Variable<int>(childAccount);
    return map;
  }

  AccountRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return AccountRelationshipsCompanion(
      id: Value(id),
      parentAccount: Value(parentAccount),
      childAccount: Value(childAccount),
    );
  }

  factory AccountRelationship.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRelationship(
      id: serializer.fromJson<int>(json['id']),
      parentAccount: serializer.fromJson<int>(json['parentAccount']),
      childAccount: serializer.fromJson<int>(json['childAccount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentAccount': serializer.toJson<int>(parentAccount),
      'childAccount': serializer.toJson<int>(childAccount),
    };
  }

  AccountRelationship copyWith(
          {int? id, int? parentAccount, int? childAccount}) =>
      AccountRelationship(
        id: id ?? this.id,
        parentAccount: parentAccount ?? this.parentAccount,
        childAccount: childAccount ?? this.childAccount,
      );
  AccountRelationship copyWithCompanion(AccountRelationshipsCompanion data) {
    return AccountRelationship(
      id: data.id.present ? data.id.value : this.id,
      parentAccount: data.parentAccount.present
          ? data.parentAccount.value
          : this.parentAccount,
      childAccount: data.childAccount.present
          ? data.childAccount.value
          : this.childAccount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRelationship(')
          ..write('id: $id, ')
          ..write('parentAccount: $parentAccount, ')
          ..write('childAccount: $childAccount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentAccount, childAccount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRelationship &&
          other.id == this.id &&
          other.parentAccount == this.parentAccount &&
          other.childAccount == this.childAccount);
}

class AccountRelationshipsCompanion
    extends UpdateCompanion<AccountRelationship> {
  final Value<int> id;
  final Value<int> parentAccount;
  final Value<int> childAccount;
  const AccountRelationshipsCompanion({
    this.id = const Value.absent(),
    this.parentAccount = const Value.absent(),
    this.childAccount = const Value.absent(),
  });
  AccountRelationshipsCompanion.insert({
    this.id = const Value.absent(),
    required int parentAccount,
    required int childAccount,
  })  : parentAccount = Value(parentAccount),
        childAccount = Value(childAccount);
  static Insertable<AccountRelationship> custom({
    Expression<int>? id,
    Expression<int>? parentAccount,
    Expression<int>? childAccount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentAccount != null) 'parent_account': parentAccount,
      if (childAccount != null) 'child_account': childAccount,
    });
  }

  AccountRelationshipsCompanion copyWith(
      {Value<int>? id, Value<int>? parentAccount, Value<int>? childAccount}) {
    return AccountRelationshipsCompanion(
      id: id ?? this.id,
      parentAccount: parentAccount ?? this.parentAccount,
      childAccount: childAccount ?? this.childAccount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentAccount.present) {
      map['parent_account'] = Variable<int>(parentAccount.value);
    }
    if (childAccount.present) {
      map['child_account'] = Variable<int>(childAccount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountRelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('parentAccount: $parentAccount, ')
          ..write('childAccount: $childAccount')
          ..write(')'))
        .toString();
  }
}

class $CashFlowCategoriesTable extends CashFlowCategories
    with TableInfo<$CashFlowCategoriesTable, CashFlowCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashFlowCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconColorMeta =
      const VerificationMeta('iconColor');
  @override
  late final GeneratedColumn<String> iconColor = GeneratedColumn<String>(
      'icon_color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconPackMeta =
      const VerificationMeta('iconPack');
  @override
  late final GeneratedColumn<String> iconPack = GeneratedColumn<String>(
      'icon_pack', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconName, iconColor, iconPack];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_flow_category';
  @override
  VerificationContext validateIntegrity(Insertable<CashFlowCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('icon_color')) {
      context.handle(_iconColorMeta,
          iconColor.isAcceptableOrUnknown(data['icon_color']!, _iconColorMeta));
    }
    if (data.containsKey('icon_pack')) {
      context.handle(_iconPackMeta,
          iconPack.isAcceptableOrUnknown(data['icon_pack']!, _iconPackMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashFlowCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashFlowCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      iconColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_color']),
      iconPack: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_pack']),
    );
  }

  @override
  $CashFlowCategoriesTable createAlias(String alias) {
    return $CashFlowCategoriesTable(attachedDatabase, alias);
  }
}

class CashFlowCategory extends DataClass
    implements Insertable<CashFlowCategory> {
  final int id;
  final String name;
  final String? iconName;
  final String? iconColor;
  final String? iconPack;
  const CashFlowCategory(
      {required this.id,
      required this.name,
      this.iconName,
      this.iconColor,
      this.iconPack});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || iconColor != null) {
      map['icon_color'] = Variable<String>(iconColor);
    }
    if (!nullToAbsent || iconPack != null) {
      map['icon_pack'] = Variable<String>(iconPack);
    }
    return map;
  }

  CashFlowCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CashFlowCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      iconColor: iconColor == null && nullToAbsent
          ? const Value.absent()
          : Value(iconColor),
      iconPack: iconPack == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPack),
    );
  }

  factory CashFlowCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashFlowCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      iconColor: serializer.fromJson<String?>(json['iconColor']),
      iconPack: serializer.fromJson<String?>(json['iconPack']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String?>(iconName),
      'iconColor': serializer.toJson<String?>(iconColor),
      'iconPack': serializer.toJson<String?>(iconPack),
    };
  }

  CashFlowCategory copyWith(
          {int? id,
          String? name,
          Value<String?> iconName = const Value.absent(),
          Value<String?> iconColor = const Value.absent(),
          Value<String?> iconPack = const Value.absent()}) =>
      CashFlowCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        iconName: iconName.present ? iconName.value : this.iconName,
        iconColor: iconColor.present ? iconColor.value : this.iconColor,
        iconPack: iconPack.present ? iconPack.value : this.iconPack,
      );
  CashFlowCategory copyWithCompanion(CashFlowCategoriesCompanion data) {
    return CashFlowCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      iconColor: data.iconColor.present ? data.iconColor.value : this.iconColor,
      iconPack: data.iconPack.present ? data.iconPack.value : this.iconPack,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashFlowCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('iconColor: $iconColor, ')
          ..write('iconPack: $iconPack')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iconName, iconColor, iconPack);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashFlowCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.iconColor == this.iconColor &&
          other.iconPack == this.iconPack);
}

class CashFlowCategoriesCompanion extends UpdateCompanion<CashFlowCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> iconName;
  final Value<String?> iconColor;
  final Value<String?> iconPack;
  const CashFlowCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.iconPack = const Value.absent(),
  });
  CashFlowCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.iconName = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.iconPack = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CashFlowCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<String>? iconColor,
    Expression<String>? iconPack,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (iconColor != null) 'icon_color': iconColor,
      if (iconPack != null) 'icon_pack': iconPack,
    });
  }

  CashFlowCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? iconName,
      Value<String?>? iconColor,
      Value<String?>? iconPack}) {
    return CashFlowCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      iconColor: iconColor ?? this.iconColor,
      iconPack: iconPack ?? this.iconPack,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (iconColor.present) {
      map['icon_color'] = Variable<String>(iconColor.value);
    }
    if (iconPack.present) {
      map['icon_pack'] = Variable<String>(iconPack.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashFlowCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('iconColor: $iconColor, ')
          ..write('iconPack: $iconPack')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, CurrencyModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isoMeta = const VerificationMeta('iso');
  @override
  late final GeneratedColumn<String> iso = GeneratedColumn<String>(
      'iso', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('FIAT'));
  static const VerificationMeta _decimalPointsMeta =
      const VerificationMeta('decimalPoints');
  @override
  late final GeneratedColumn<int> decimalPoints = GeneratedColumn<int>(
      'decimal_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _symbolOnLeftMeta =
      const VerificationMeta('symbolOnLeft');
  @override
  late final GeneratedColumn<bool> symbolOnLeft = GeneratedColumn<bool>(
      'symbol_on_left', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("symbol_on_left" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, symbol, iso, logoUrl, type, decimalPoints, symbolOnLeft];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    }
    if (data.containsKey('iso')) {
      context.handle(
          _isoMeta, iso.isAcceptableOrUnknown(data['iso']!, _isoMeta));
    } else if (isInserting) {
      context.missing(_isoMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('decimal_points')) {
      context.handle(
          _decimalPointsMeta,
          decimalPoints.isAcceptableOrUnknown(
              data['decimal_points']!, _decimalPointsMeta));
    }
    if (data.containsKey('symbol_on_left')) {
      context.handle(
          _symbolOnLeftMeta,
          symbolOnLeft.isAcceptableOrUnknown(
              data['symbol_on_left']!, _symbolOnLeftMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrencyModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol']),
      iso: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}iso'])!,
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      decimalPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}decimal_points'])!,
      symbolOnLeft: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}symbol_on_left'])!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class CurrencyModel extends DataClass implements Insertable<CurrencyModel> {
  final int id;
  final String name;
  final String? symbol;
  final String iso;
  final String? logoUrl;
  final String type;
  final int decimalPoints;
  final bool symbolOnLeft;
  const CurrencyModel(
      {required this.id,
      required this.name,
      this.symbol,
      required this.iso,
      this.logoUrl,
      required this.type,
      required this.decimalPoints,
      required this.symbolOnLeft});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    map['iso'] = Variable<String>(iso);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['type'] = Variable<String>(type);
    map['decimal_points'] = Variable<int>(decimalPoints);
    map['symbol_on_left'] = Variable<bool>(symbolOnLeft);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      name: Value(name),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      iso: Value(iso),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      type: Value(type),
      decimalPoints: Value(decimalPoints),
      symbolOnLeft: Value(symbolOnLeft),
    );
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyModel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String?>(json['symbol']),
      iso: serializer.fromJson<String>(json['iso']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      type: serializer.fromJson<String>(json['type']),
      decimalPoints: serializer.fromJson<int>(json['decimalPoints']),
      symbolOnLeft: serializer.fromJson<bool>(json['symbolOnLeft']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String?>(symbol),
      'iso': serializer.toJson<String>(iso),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'type': serializer.toJson<String>(type),
      'decimalPoints': serializer.toJson<int>(decimalPoints),
      'symbolOnLeft': serializer.toJson<bool>(symbolOnLeft),
    };
  }

  CurrencyModel copyWith(
          {int? id,
          String? name,
          Value<String?> symbol = const Value.absent(),
          String? iso,
          Value<String?> logoUrl = const Value.absent(),
          String? type,
          int? decimalPoints,
          bool? symbolOnLeft}) =>
      CurrencyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol.present ? symbol.value : this.symbol,
        iso: iso ?? this.iso,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        type: type ?? this.type,
        decimalPoints: decimalPoints ?? this.decimalPoints,
        symbolOnLeft: symbolOnLeft ?? this.symbolOnLeft,
      );
  CurrencyModel copyWithCompanion(CurrenciesCompanion data) {
    return CurrencyModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      iso: data.iso.present ? data.iso.value : this.iso,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      type: data.type.present ? data.type.value : this.type,
      decimalPoints: data.decimalPoints.present
          ? data.decimalPoints.value
          : this.decimalPoints,
      symbolOnLeft: data.symbolOnLeft.present
          ? data.symbolOnLeft.value
          : this.symbolOnLeft,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('iso: $iso, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('type: $type, ')
          ..write('decimalPoints: $decimalPoints, ')
          ..write('symbolOnLeft: $symbolOnLeft')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, symbol, iso, logoUrl, type, decimalPoints, symbolOnLeft);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.iso == this.iso &&
          other.logoUrl == this.logoUrl &&
          other.type == this.type &&
          other.decimalPoints == this.decimalPoints &&
          other.symbolOnLeft == this.symbolOnLeft);
}

class CurrenciesCompanion extends UpdateCompanion<CurrencyModel> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> symbol;
  final Value<String> iso;
  final Value<String?> logoUrl;
  final Value<String> type;
  final Value<int> decimalPoints;
  final Value<bool> symbolOnLeft;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.iso = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.decimalPoints = const Value.absent(),
    this.symbolOnLeft = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.symbol = const Value.absent(),
    required String iso,
    this.logoUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.decimalPoints = const Value.absent(),
    this.symbolOnLeft = const Value.absent(),
  })  : name = Value(name),
        iso = Value(iso);
  static Insertable<CurrencyModel> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<String>? iso,
    Expression<String>? logoUrl,
    Expression<String>? type,
    Expression<int>? decimalPoints,
    Expression<bool>? symbolOnLeft,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (iso != null) 'iso': iso,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (type != null) 'type': type,
      if (decimalPoints != null) 'decimal_points': decimalPoints,
      if (symbolOnLeft != null) 'symbol_on_left': symbolOnLeft,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? symbol,
      Value<String>? iso,
      Value<String?>? logoUrl,
      Value<String>? type,
      Value<int>? decimalPoints,
      Value<bool>? symbolOnLeft}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      iso: iso ?? this.iso,
      logoUrl: logoUrl ?? this.logoUrl,
      type: type ?? this.type,
      decimalPoints: decimalPoints ?? this.decimalPoints,
      symbolOnLeft: symbolOnLeft ?? this.symbolOnLeft,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (iso.present) {
      map['iso'] = Variable<String>(iso.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (decimalPoints.present) {
      map['decimal_points'] = Variable<int>(decimalPoints.value);
    }
    if (symbolOnLeft.present) {
      map['symbol_on_left'] = Variable<bool>(symbolOnLeft.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('iso: $iso, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('type: $type, ')
          ..write('decimalPoints: $decimalPoints, ')
          ..write('symbolOnLeft: $symbolOnLeft')
          ..write(')'))
        .toString();
  }
}

class $CashFlowsTable extends CashFlows
    with TableInfo<$CashFlowsTable, CashFlow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashFlowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<int> currency = GeneratedColumn<int>(
      'currency', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _descriptionImageMeta =
      const VerificationMeta('descriptionImage');
  @override
  late final GeneratedColumn<Uint8List> descriptionImage =
      GeneratedColumn<Uint8List>('description_image', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        amount,
        account,
        currency,
        category,
        description,
        descriptionImage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_flow';
  @override
  VerificationContext validateIntegrity(Insertable<CashFlow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('description_image')) {
      context.handle(
          _descriptionImageMeta,
          descriptionImage.isAcceptableOrUnknown(
              data['description_image']!, _descriptionImageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashFlow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashFlow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      descriptionImage: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}description_image']),
    );
  }

  @override
  $CashFlowsTable createAlias(String alias) {
    return $CashFlowsTable(attachedDatabase, alias);
  }
}

class CashFlow extends DataClass implements Insertable<CashFlow> {
  final int id;
  final String date;
  final double amount;
  final int account;
  final int currency;
  final int? category;
  final String description;
  final Uint8List? descriptionImage;
  const CashFlow(
      {required this.id,
      required this.date,
      required this.amount,
      required this.account,
      required this.currency,
      this.category,
      required this.description,
      this.descriptionImage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['amount'] = Variable<double>(amount);
    map['account'] = Variable<int>(account);
    map['currency'] = Variable<int>(currency);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(category);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || descriptionImage != null) {
      map['description_image'] = Variable<Uint8List>(descriptionImage);
    }
    return map;
  }

  CashFlowsCompanion toCompanion(bool nullToAbsent) {
    return CashFlowsCompanion(
      id: Value(id),
      date: Value(date),
      amount: Value(amount),
      account: Value(account),
      currency: Value(currency),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: Value(description),
      descriptionImage: descriptionImage == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionImage),
    );
  }

  factory CashFlow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashFlow(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      account: serializer.fromJson<int>(json['account']),
      currency: serializer.fromJson<int>(json['currency']),
      category: serializer.fromJson<int?>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      descriptionImage:
          serializer.fromJson<Uint8List?>(json['descriptionImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'amount': serializer.toJson<double>(amount),
      'account': serializer.toJson<int>(account),
      'currency': serializer.toJson<int>(currency),
      'category': serializer.toJson<int?>(category),
      'description': serializer.toJson<String>(description),
      'descriptionImage': serializer.toJson<Uint8List?>(descriptionImage),
    };
  }

  CashFlow copyWith(
          {int? id,
          String? date,
          double? amount,
          int? account,
          int? currency,
          Value<int?> category = const Value.absent(),
          String? description,
          Value<Uint8List?> descriptionImage = const Value.absent()}) =>
      CashFlow(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        account: account ?? this.account,
        currency: currency ?? this.currency,
        category: category.present ? category.value : this.category,
        description: description ?? this.description,
        descriptionImage: descriptionImage.present
            ? descriptionImage.value
            : this.descriptionImage,
      );
  CashFlow copyWithCompanion(CashFlowsCompanion data) {
    return CashFlow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      account: data.account.present ? data.account.value : this.account,
      currency: data.currency.present ? data.currency.value : this.currency,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      descriptionImage: data.descriptionImage.present
          ? data.descriptionImage.value
          : this.descriptionImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashFlow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('account: $account, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionImage: $descriptionImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, amount, account, currency, category,
      description, $driftBlobEquality.hash(descriptionImage));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashFlow &&
          other.id == this.id &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.account == this.account &&
          other.currency == this.currency &&
          other.category == this.category &&
          other.description == this.description &&
          $driftBlobEquality.equals(
              other.descriptionImage, this.descriptionImage));
}

class CashFlowsCompanion extends UpdateCompanion<CashFlow> {
  final Value<int> id;
  final Value<String> date;
  final Value<double> amount;
  final Value<int> account;
  final Value<int> currency;
  final Value<int?> category;
  final Value<String> description;
  final Value<Uint8List?> descriptionImage;
  const CashFlowsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.account = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionImage = const Value.absent(),
  });
  CashFlowsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required double amount,
    required int account,
    required int currency,
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionImage = const Value.absent(),
  })  : date = Value(date),
        amount = Value(amount),
        account = Value(account),
        currency = Value(currency);
  static Insertable<CashFlow> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<double>? amount,
    Expression<int>? account,
    Expression<int>? currency,
    Expression<int>? category,
    Expression<String>? description,
    Expression<Uint8List>? descriptionImage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (account != null) 'account': account,
      if (currency != null) 'currency': currency,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (descriptionImage != null) 'description_image': descriptionImage,
    });
  }

  CashFlowsCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<double>? amount,
      Value<int>? account,
      Value<int>? currency,
      Value<int?>? category,
      Value<String>? description,
      Value<Uint8List?>? descriptionImage}) {
    return CashFlowsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      account: account ?? this.account,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      description: description ?? this.description,
      descriptionImage: descriptionImage ?? this.descriptionImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (currency.present) {
      map['currency'] = Variable<int>(currency.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionImage.present) {
      map['description_image'] = Variable<Uint8List>(descriptionImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashFlowsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('account: $account, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionImage: $descriptionImage')
          ..write(')'))
        .toString();
  }
}

class $CurrencyPairsTable extends CurrencyPairs
    with TableInfo<$CurrencyPairsTable, CurrencyPair> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyPairsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _currencyOriginMeta =
      const VerificationMeta('currencyOrigin');
  @override
  late final GeneratedColumn<int> currencyOrigin = GeneratedColumn<int>(
      'currency_origin', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyTargetMeta =
      const VerificationMeta('currencyTarget');
  @override
  late final GeneratedColumn<int> currencyTarget = GeneratedColumn<int>(
      'currency_target', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, currencyOrigin, currencyTarget];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_pair';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyPair> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_origin')) {
      context.handle(
          _currencyOriginMeta,
          currencyOrigin.isAcceptableOrUnknown(
              data['currency_origin']!, _currencyOriginMeta));
    } else if (isInserting) {
      context.missing(_currencyOriginMeta);
    }
    if (data.containsKey('currency_target')) {
      context.handle(
          _currencyTargetMeta,
          currencyTarget.isAcceptableOrUnknown(
              data['currency_target']!, _currencyTargetMeta));
    } else if (isInserting) {
      context.missing(_currencyTargetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrencyPair map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyPair(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyOrigin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency_origin'])!,
      currencyTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency_target'])!,
    );
  }

  @override
  $CurrencyPairsTable createAlias(String alias) {
    return $CurrencyPairsTable(attachedDatabase, alias);
  }
}

class CurrencyPair extends DataClass implements Insertable<CurrencyPair> {
  final int id;
  final int currencyOrigin;
  final int currencyTarget;
  const CurrencyPair(
      {required this.id,
      required this.currencyOrigin,
      required this.currencyTarget});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_origin'] = Variable<int>(currencyOrigin);
    map['currency_target'] = Variable<int>(currencyTarget);
    return map;
  }

  CurrencyPairsCompanion toCompanion(bool nullToAbsent) {
    return CurrencyPairsCompanion(
      id: Value(id),
      currencyOrigin: Value(currencyOrigin),
      currencyTarget: Value(currencyTarget),
    );
  }

  factory CurrencyPair.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyPair(
      id: serializer.fromJson<int>(json['id']),
      currencyOrigin: serializer.fromJson<int>(json['currencyOrigin']),
      currencyTarget: serializer.fromJson<int>(json['currencyTarget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyOrigin': serializer.toJson<int>(currencyOrigin),
      'currencyTarget': serializer.toJson<int>(currencyTarget),
    };
  }

  CurrencyPair copyWith({int? id, int? currencyOrigin, int? currencyTarget}) =>
      CurrencyPair(
        id: id ?? this.id,
        currencyOrigin: currencyOrigin ?? this.currencyOrigin,
        currencyTarget: currencyTarget ?? this.currencyTarget,
      );
  CurrencyPair copyWithCompanion(CurrencyPairsCompanion data) {
    return CurrencyPair(
      id: data.id.present ? data.id.value : this.id,
      currencyOrigin: data.currencyOrigin.present
          ? data.currencyOrigin.value
          : this.currencyOrigin,
      currencyTarget: data.currencyTarget.present
          ? data.currencyTarget.value
          : this.currencyTarget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyPair(')
          ..write('id: $id, ')
          ..write('currencyOrigin: $currencyOrigin, ')
          ..write('currencyTarget: $currencyTarget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currencyOrigin, currencyTarget);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyPair &&
          other.id == this.id &&
          other.currencyOrigin == this.currencyOrigin &&
          other.currencyTarget == this.currencyTarget);
}

class CurrencyPairsCompanion extends UpdateCompanion<CurrencyPair> {
  final Value<int> id;
  final Value<int> currencyOrigin;
  final Value<int> currencyTarget;
  const CurrencyPairsCompanion({
    this.id = const Value.absent(),
    this.currencyOrigin = const Value.absent(),
    this.currencyTarget = const Value.absent(),
  });
  CurrencyPairsCompanion.insert({
    this.id = const Value.absent(),
    required int currencyOrigin,
    required int currencyTarget,
  })  : currencyOrigin = Value(currencyOrigin),
        currencyTarget = Value(currencyTarget);
  static Insertable<CurrencyPair> custom({
    Expression<int>? id,
    Expression<int>? currencyOrigin,
    Expression<int>? currencyTarget,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyOrigin != null) 'currency_origin': currencyOrigin,
      if (currencyTarget != null) 'currency_target': currencyTarget,
    });
  }

  CurrencyPairsCompanion copyWith(
      {Value<int>? id,
      Value<int>? currencyOrigin,
      Value<int>? currencyTarget}) {
    return CurrencyPairsCompanion(
      id: id ?? this.id,
      currencyOrigin: currencyOrigin ?? this.currencyOrigin,
      currencyTarget: currencyTarget ?? this.currencyTarget,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyOrigin.present) {
      map['currency_origin'] = Variable<int>(currencyOrigin.value);
    }
    if (currencyTarget.present) {
      map['currency_target'] = Variable<int>(currencyTarget.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyPairsCompanion(')
          ..write('id: $id, ')
          ..write('currencyOrigin: $currencyOrigin, ')
          ..write('currencyTarget: $currencyTarget')
          ..write(')'))
        .toString();
  }
}

class $CurrencyPairRatesTable extends CurrencyPairRates
    with TableInfo<$CurrencyPairRatesTable, CurrencyPairRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyPairRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyPairMeta =
      const VerificationMeta('currencyPair');
  @override
  late final GeneratedColumn<int> currencyPair = GeneratedColumn<int>(
      'currency_pair', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, currencyPair, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_pair_rate';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyPairRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('currency_pair')) {
      context.handle(
          _currencyPairMeta,
          currencyPair.isAcceptableOrUnknown(
              data['currency_pair']!, _currencyPairMeta));
    } else if (isInserting) {
      context.missing(_currencyPairMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrencyPairRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyPairRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      currencyPair: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency_pair'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $CurrencyPairRatesTable createAlias(String alias) {
    return $CurrencyPairRatesTable(attachedDatabase, alias);
  }
}

class CurrencyPairRate extends DataClass
    implements Insertable<CurrencyPairRate> {
  final int id;
  final String date;
  final int currencyPair;
  final double rate;
  const CurrencyPairRate(
      {required this.id,
      required this.date,
      required this.currencyPair,
      required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['currency_pair'] = Variable<int>(currencyPair);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  CurrencyPairRatesCompanion toCompanion(bool nullToAbsent) {
    return CurrencyPairRatesCompanion(
      id: Value(id),
      date: Value(date),
      currencyPair: Value(currencyPair),
      rate: Value(rate),
    );
  }

  factory CurrencyPairRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyPairRate(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      currencyPair: serializer.fromJson<int>(json['currencyPair']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'currencyPair': serializer.toJson<int>(currencyPair),
      'rate': serializer.toJson<double>(rate),
    };
  }

  CurrencyPairRate copyWith(
          {int? id, String? date, int? currencyPair, double? rate}) =>
      CurrencyPairRate(
        id: id ?? this.id,
        date: date ?? this.date,
        currencyPair: currencyPair ?? this.currencyPair,
        rate: rate ?? this.rate,
      );
  CurrencyPairRate copyWithCompanion(CurrencyPairRatesCompanion data) {
    return CurrencyPairRate(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      currencyPair: data.currencyPair.present
          ? data.currencyPair.value
          : this.currencyPair,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyPairRate(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('currencyPair: $currencyPair, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, currencyPair, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyPairRate &&
          other.id == this.id &&
          other.date == this.date &&
          other.currencyPair == this.currencyPair &&
          other.rate == this.rate);
}

class CurrencyPairRatesCompanion extends UpdateCompanion<CurrencyPairRate> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> currencyPair;
  final Value<double> rate;
  const CurrencyPairRatesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.currencyPair = const Value.absent(),
    this.rate = const Value.absent(),
  });
  CurrencyPairRatesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int currencyPair,
    required double rate,
  })  : date = Value(date),
        currencyPair = Value(currencyPair),
        rate = Value(rate);
  static Insertable<CurrencyPairRate> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? currencyPair,
    Expression<double>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (currencyPair != null) 'currency_pair': currencyPair,
      if (rate != null) 'rate': rate,
    });
  }

  CurrencyPairRatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<int>? currencyPair,
      Value<double>? rate}) {
    return CurrencyPairRatesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      currencyPair: currencyPair ?? this.currencyPair,
      rate: rate ?? this.rate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (currencyPair.present) {
      map['currency_pair'] = Variable<int>(currencyPair.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyPairRatesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('currencyPair: $currencyPair, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cashFlowOriginMeta =
      const VerificationMeta('cashFlowOrigin');
  @override
  late final GeneratedColumn<int> cashFlowOrigin = GeneratedColumn<int>(
      'cash_flow_origin', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _cashFlowTargetMeta =
      const VerificationMeta('cashFlowTarget');
  @override
  late final GeneratedColumn<int> cashFlowTarget = GeneratedColumn<int>(
      'cash_flow_target', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, cashFlowOrigin, cashFlowTarget];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer';
  @override
  VerificationContext validateIntegrity(Insertable<Transfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cash_flow_origin')) {
      context.handle(
          _cashFlowOriginMeta,
          cashFlowOrigin.isAcceptableOrUnknown(
              data['cash_flow_origin']!, _cashFlowOriginMeta));
    } else if (isInserting) {
      context.missing(_cashFlowOriginMeta);
    }
    if (data.containsKey('cash_flow_target')) {
      context.handle(
          _cashFlowTargetMeta,
          cashFlowTarget.isAcceptableOrUnknown(
              data['cash_flow_target']!, _cashFlowTargetMeta));
    } else if (isInserting) {
      context.missing(_cashFlowTargetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cashFlowOrigin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cash_flow_origin'])!,
      cashFlowTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cash_flow_target'])!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int cashFlowOrigin;
  final int cashFlowTarget;
  const Transfer(
      {required this.id,
      required this.cashFlowOrigin,
      required this.cashFlowTarget});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cash_flow_origin'] = Variable<int>(cashFlowOrigin);
    map['cash_flow_target'] = Variable<int>(cashFlowTarget);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      cashFlowOrigin: Value(cashFlowOrigin),
      cashFlowTarget: Value(cashFlowTarget),
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      cashFlowOrigin: serializer.fromJson<int>(json['cashFlowOrigin']),
      cashFlowTarget: serializer.fromJson<int>(json['cashFlowTarget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cashFlowOrigin': serializer.toJson<int>(cashFlowOrigin),
      'cashFlowTarget': serializer.toJson<int>(cashFlowTarget),
    };
  }

  Transfer copyWith({int? id, int? cashFlowOrigin, int? cashFlowTarget}) =>
      Transfer(
        id: id ?? this.id,
        cashFlowOrigin: cashFlowOrigin ?? this.cashFlowOrigin,
        cashFlowTarget: cashFlowTarget ?? this.cashFlowTarget,
      );
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
      id: data.id.present ? data.id.value : this.id,
      cashFlowOrigin: data.cashFlowOrigin.present
          ? data.cashFlowOrigin.value
          : this.cashFlowOrigin,
      cashFlowTarget: data.cashFlowTarget.present
          ? data.cashFlowTarget.value
          : this.cashFlowTarget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('cashFlowOrigin: $cashFlowOrigin, ')
          ..write('cashFlowTarget: $cashFlowTarget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cashFlowOrigin, cashFlowTarget);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.cashFlowOrigin == this.cashFlowOrigin &&
          other.cashFlowTarget == this.cashFlowTarget);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> cashFlowOrigin;
  final Value<int> cashFlowTarget;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.cashFlowOrigin = const Value.absent(),
    this.cashFlowTarget = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int cashFlowOrigin,
    required int cashFlowTarget,
  })  : cashFlowOrigin = Value(cashFlowOrigin),
        cashFlowTarget = Value(cashFlowTarget);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? cashFlowOrigin,
    Expression<int>? cashFlowTarget,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashFlowOrigin != null) 'cash_flow_origin': cashFlowOrigin,
      if (cashFlowTarget != null) 'cash_flow_target': cashFlowTarget,
    });
  }

  TransfersCompanion copyWith(
      {Value<int>? id,
      Value<int>? cashFlowOrigin,
      Value<int>? cashFlowTarget}) {
    return TransfersCompanion(
      id: id ?? this.id,
      cashFlowOrigin: cashFlowOrigin ?? this.cashFlowOrigin,
      cashFlowTarget: cashFlowTarget ?? this.cashFlowTarget,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cashFlowOrigin.present) {
      map['cash_flow_origin'] = Variable<int>(cashFlowOrigin.value);
    }
    if (cashFlowTarget.present) {
      map['cash_flow_target'] = Variable<int>(cashFlowTarget.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('cashFlowOrigin: $cashFlowOrigin, ')
          ..write('cashFlowTarget: $cashFlowTarget')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $AccountRelationshipsTable accountRelationships =
      $AccountRelationshipsTable(this);
  late final $CashFlowCategoriesTable cashFlowCategories =
      $CashFlowCategoriesTable(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $CashFlowsTable cashFlows = $CashFlowsTable(this);
  late final $CurrencyPairsTable currencyPairs = $CurrencyPairsTable(this);
  late final $CurrencyPairRatesTable currencyPairRates =
      $CurrencyPairRatesTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        accountRelationships,
        cashFlowCategories,
        currencies,
        cashFlows,
        currencyPairs,
        currencyPairRates,
        transfers
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  required bool canReceiveCashFlows,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> canReceiveCashFlows,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canReceiveCashFlows => $composableBuilder(
      column: $table.canReceiveCashFlows,
      builder: (column) => ColumnFilters(column));
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canReceiveCashFlows => $composableBuilder(
      column: $table.canReceiveCashFlows,
      builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get canReceiveCashFlows => $composableBuilder(
      column: $table.canReceiveCashFlows, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> canReceiveCashFlows = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            canReceiveCashFlows: canReceiveCashFlows,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            required bool canReceiveCashFlows,
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            canReceiveCashFlows: canReceiveCashFlows,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()>;
typedef $$AccountRelationshipsTableCreateCompanionBuilder
    = AccountRelationshipsCompanion Function({
  Value<int> id,
  required int parentAccount,
  required int childAccount,
});
typedef $$AccountRelationshipsTableUpdateCompanionBuilder
    = AccountRelationshipsCompanion Function({
  Value<int> id,
  Value<int> parentAccount,
  Value<int> childAccount,
});

class $$AccountRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountRelationshipsTable> {
  $$AccountRelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentAccount => $composableBuilder(
      column: $table.parentAccount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get childAccount => $composableBuilder(
      column: $table.childAccount, builder: (column) => ColumnFilters(column));
}

class $$AccountRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountRelationshipsTable> {
  $$AccountRelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentAccount => $composableBuilder(
      column: $table.parentAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get childAccount => $composableBuilder(
      column: $table.childAccount,
      builder: (column) => ColumnOrderings(column));
}

class $$AccountRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountRelationshipsTable> {
  $$AccountRelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentAccount => $composableBuilder(
      column: $table.parentAccount, builder: (column) => column);

  GeneratedColumn<int> get childAccount => $composableBuilder(
      column: $table.childAccount, builder: (column) => column);
}

class $$AccountRelationshipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountRelationshipsTable,
    AccountRelationship,
    $$AccountRelationshipsTableFilterComposer,
    $$AccountRelationshipsTableOrderingComposer,
    $$AccountRelationshipsTableAnnotationComposer,
    $$AccountRelationshipsTableCreateCompanionBuilder,
    $$AccountRelationshipsTableUpdateCompanionBuilder,
    (
      AccountRelationship,
      BaseReferences<_$AppDatabase, $AccountRelationshipsTable,
          AccountRelationship>
    ),
    AccountRelationship,
    PrefetchHooks Function()> {
  $$AccountRelationshipsTableTableManager(
      _$AppDatabase db, $AccountRelationshipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountRelationshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountRelationshipsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountRelationshipsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> parentAccount = const Value.absent(),
            Value<int> childAccount = const Value.absent(),
          }) =>
              AccountRelationshipsCompanion(
            id: id,
            parentAccount: parentAccount,
            childAccount: childAccount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int parentAccount,
            required int childAccount,
          }) =>
              AccountRelationshipsCompanion.insert(
            id: id,
            parentAccount: parentAccount,
            childAccount: childAccount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountRelationshipsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AccountRelationshipsTable,
        AccountRelationship,
        $$AccountRelationshipsTableFilterComposer,
        $$AccountRelationshipsTableOrderingComposer,
        $$AccountRelationshipsTableAnnotationComposer,
        $$AccountRelationshipsTableCreateCompanionBuilder,
        $$AccountRelationshipsTableUpdateCompanionBuilder,
        (
          AccountRelationship,
          BaseReferences<_$AppDatabase, $AccountRelationshipsTable,
              AccountRelationship>
        ),
        AccountRelationship,
        PrefetchHooks Function()>;
typedef $$CashFlowCategoriesTableCreateCompanionBuilder
    = CashFlowCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> iconName,
  Value<String?> iconColor,
  Value<String?> iconPack,
});
typedef $$CashFlowCategoriesTableUpdateCompanionBuilder
    = CashFlowCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> iconName,
  Value<String?> iconColor,
  Value<String?> iconPack,
});

class $$CashFlowCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CashFlowCategoriesTable> {
  $$CashFlowCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconPack => $composableBuilder(
      column: $table.iconPack, builder: (column) => ColumnFilters(column));
}

class $$CashFlowCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashFlowCategoriesTable> {
  $$CashFlowCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconPack => $composableBuilder(
      column: $table.iconPack, builder: (column) => ColumnOrderings(column));
}

class $$CashFlowCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashFlowCategoriesTable> {
  $$CashFlowCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get iconColor =>
      $composableBuilder(column: $table.iconColor, builder: (column) => column);

  GeneratedColumn<String> get iconPack =>
      $composableBuilder(column: $table.iconPack, builder: (column) => column);
}

class $$CashFlowCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashFlowCategoriesTable,
    CashFlowCategory,
    $$CashFlowCategoriesTableFilterComposer,
    $$CashFlowCategoriesTableOrderingComposer,
    $$CashFlowCategoriesTableAnnotationComposer,
    $$CashFlowCategoriesTableCreateCompanionBuilder,
    $$CashFlowCategoriesTableUpdateCompanionBuilder,
    (
      CashFlowCategory,
      BaseReferences<_$AppDatabase, $CashFlowCategoriesTable, CashFlowCategory>
    ),
    CashFlowCategory,
    PrefetchHooks Function()> {
  $$CashFlowCategoriesTableTableManager(
      _$AppDatabase db, $CashFlowCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashFlowCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashFlowCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashFlowCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> iconColor = const Value.absent(),
            Value<String?> iconPack = const Value.absent(),
          }) =>
              CashFlowCategoriesCompanion(
            id: id,
            name: name,
            iconName: iconName,
            iconColor: iconColor,
            iconPack: iconPack,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> iconName = const Value.absent(),
            Value<String?> iconColor = const Value.absent(),
            Value<String?> iconPack = const Value.absent(),
          }) =>
              CashFlowCategoriesCompanion.insert(
            id: id,
            name: name,
            iconName: iconName,
            iconColor: iconColor,
            iconPack: iconPack,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CashFlowCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CashFlowCategoriesTable,
    CashFlowCategory,
    $$CashFlowCategoriesTableFilterComposer,
    $$CashFlowCategoriesTableOrderingComposer,
    $$CashFlowCategoriesTableAnnotationComposer,
    $$CashFlowCategoriesTableCreateCompanionBuilder,
    $$CashFlowCategoriesTableUpdateCompanionBuilder,
    (
      CashFlowCategory,
      BaseReferences<_$AppDatabase, $CashFlowCategoriesTable, CashFlowCategory>
    ),
    CashFlowCategory,
    PrefetchHooks Function()>;
typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> symbol,
  required String iso,
  Value<String?> logoUrl,
  Value<String> type,
  Value<int> decimalPoints,
  Value<bool> symbolOnLeft,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> symbol,
  Value<String> iso,
  Value<String?> logoUrl,
  Value<String> type,
  Value<int> decimalPoints,
  Value<bool> symbolOnLeft,
});

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iso => $composableBuilder(
      column: $table.iso, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get decimalPoints => $composableBuilder(
      column: $table.decimalPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get symbolOnLeft => $composableBuilder(
      column: $table.symbolOnLeft, builder: (column) => ColumnFilters(column));
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iso => $composableBuilder(
      column: $table.iso, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get decimalPoints => $composableBuilder(
      column: $table.decimalPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get symbolOnLeft => $composableBuilder(
      column: $table.symbolOnLeft,
      builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get iso =>
      $composableBuilder(column: $table.iso, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get decimalPoints => $composableBuilder(
      column: $table.decimalPoints, builder: (column) => column);

  GeneratedColumn<bool> get symbolOnLeft => $composableBuilder(
      column: $table.symbolOnLeft, builder: (column) => column);
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    CurrencyModel,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (
      CurrencyModel,
      BaseReferences<_$AppDatabase, $CurrenciesTable, CurrencyModel>
    ),
    CurrencyModel,
    PrefetchHooks Function()> {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<String> iso = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> decimalPoints = const Value.absent(),
            Value<bool> symbolOnLeft = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            id: id,
            name: name,
            symbol: symbol,
            iso: iso,
            logoUrl: logoUrl,
            type: type,
            decimalPoints: decimalPoints,
            symbolOnLeft: symbolOnLeft,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> symbol = const Value.absent(),
            required String iso,
            Value<String?> logoUrl = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> decimalPoints = const Value.absent(),
            Value<bool> symbolOnLeft = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            id: id,
            name: name,
            symbol: symbol,
            iso: iso,
            logoUrl: logoUrl,
            type: type,
            decimalPoints: decimalPoints,
            symbolOnLeft: symbolOnLeft,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    CurrencyModel,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (
      CurrencyModel,
      BaseReferences<_$AppDatabase, $CurrenciesTable, CurrencyModel>
    ),
    CurrencyModel,
    PrefetchHooks Function()>;
typedef $$CashFlowsTableCreateCompanionBuilder = CashFlowsCompanion Function({
  Value<int> id,
  required String date,
  required double amount,
  required int account,
  required int currency,
  Value<int?> category,
  Value<String> description,
  Value<Uint8List?> descriptionImage,
});
typedef $$CashFlowsTableUpdateCompanionBuilder = CashFlowsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<double> amount,
  Value<int> account,
  Value<int> currency,
  Value<int?> category,
  Value<String> description,
  Value<Uint8List?> descriptionImage,
});

class $$CashFlowsTableFilterComposer
    extends Composer<_$AppDatabase, $CashFlowsTable> {
  $$CashFlowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get account => $composableBuilder(
      column: $table.account, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get descriptionImage => $composableBuilder(
      column: $table.descriptionImage,
      builder: (column) => ColumnFilters(column));
}

class $$CashFlowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashFlowsTable> {
  $$CashFlowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get account => $composableBuilder(
      column: $table.account, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get descriptionImage => $composableBuilder(
      column: $table.descriptionImage,
      builder: (column) => ColumnOrderings(column));
}

class $$CashFlowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashFlowsTable> {
  $$CashFlowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get account =>
      $composableBuilder(column: $table.account, builder: (column) => column);

  GeneratedColumn<int> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<Uint8List> get descriptionImage => $composableBuilder(
      column: $table.descriptionImage, builder: (column) => column);
}

class $$CashFlowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashFlowsTable,
    CashFlow,
    $$CashFlowsTableFilterComposer,
    $$CashFlowsTableOrderingComposer,
    $$CashFlowsTableAnnotationComposer,
    $$CashFlowsTableCreateCompanionBuilder,
    $$CashFlowsTableUpdateCompanionBuilder,
    (CashFlow, BaseReferences<_$AppDatabase, $CashFlowsTable, CashFlow>),
    CashFlow,
    PrefetchHooks Function()> {
  $$CashFlowsTableTableManager(_$AppDatabase db, $CashFlowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashFlowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashFlowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashFlowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<int> currency = const Value.absent(),
            Value<int?> category = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<Uint8List?> descriptionImage = const Value.absent(),
          }) =>
              CashFlowsCompanion(
            id: id,
            date: date,
            amount: amount,
            account: account,
            currency: currency,
            category: category,
            description: description,
            descriptionImage: descriptionImage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required double amount,
            required int account,
            required int currency,
            Value<int?> category = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<Uint8List?> descriptionImage = const Value.absent(),
          }) =>
              CashFlowsCompanion.insert(
            id: id,
            date: date,
            amount: amount,
            account: account,
            currency: currency,
            category: category,
            description: description,
            descriptionImage: descriptionImage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CashFlowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CashFlowsTable,
    CashFlow,
    $$CashFlowsTableFilterComposer,
    $$CashFlowsTableOrderingComposer,
    $$CashFlowsTableAnnotationComposer,
    $$CashFlowsTableCreateCompanionBuilder,
    $$CashFlowsTableUpdateCompanionBuilder,
    (CashFlow, BaseReferences<_$AppDatabase, $CashFlowsTable, CashFlow>),
    CashFlow,
    PrefetchHooks Function()>;
typedef $$CurrencyPairsTableCreateCompanionBuilder = CurrencyPairsCompanion
    Function({
  Value<int> id,
  required int currencyOrigin,
  required int currencyTarget,
});
typedef $$CurrencyPairsTableUpdateCompanionBuilder = CurrencyPairsCompanion
    Function({
  Value<int> id,
  Value<int> currencyOrigin,
  Value<int> currencyTarget,
});

class $$CurrencyPairsTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyPairsTable> {
  $$CurrencyPairsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currencyOrigin => $composableBuilder(
      column: $table.currencyOrigin,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currencyTarget => $composableBuilder(
      column: $table.currencyTarget,
      builder: (column) => ColumnFilters(column));
}

class $$CurrencyPairsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyPairsTable> {
  $$CurrencyPairsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currencyOrigin => $composableBuilder(
      column: $table.currencyOrigin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currencyTarget => $composableBuilder(
      column: $table.currencyTarget,
      builder: (column) => ColumnOrderings(column));
}

class $$CurrencyPairsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyPairsTable> {
  $$CurrencyPairsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currencyOrigin => $composableBuilder(
      column: $table.currencyOrigin, builder: (column) => column);

  GeneratedColumn<int> get currencyTarget => $composableBuilder(
      column: $table.currencyTarget, builder: (column) => column);
}

class $$CurrencyPairsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyPairsTable,
    CurrencyPair,
    $$CurrencyPairsTableFilterComposer,
    $$CurrencyPairsTableOrderingComposer,
    $$CurrencyPairsTableAnnotationComposer,
    $$CurrencyPairsTableCreateCompanionBuilder,
    $$CurrencyPairsTableUpdateCompanionBuilder,
    (
      CurrencyPair,
      BaseReferences<_$AppDatabase, $CurrencyPairsTable, CurrencyPair>
    ),
    CurrencyPair,
    PrefetchHooks Function()> {
  $$CurrencyPairsTableTableManager(_$AppDatabase db, $CurrencyPairsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyPairsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyPairsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyPairsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> currencyOrigin = const Value.absent(),
            Value<int> currencyTarget = const Value.absent(),
          }) =>
              CurrencyPairsCompanion(
            id: id,
            currencyOrigin: currencyOrigin,
            currencyTarget: currencyTarget,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int currencyOrigin,
            required int currencyTarget,
          }) =>
              CurrencyPairsCompanion.insert(
            id: id,
            currencyOrigin: currencyOrigin,
            currencyTarget: currencyTarget,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrencyPairsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyPairsTable,
    CurrencyPair,
    $$CurrencyPairsTableFilterComposer,
    $$CurrencyPairsTableOrderingComposer,
    $$CurrencyPairsTableAnnotationComposer,
    $$CurrencyPairsTableCreateCompanionBuilder,
    $$CurrencyPairsTableUpdateCompanionBuilder,
    (
      CurrencyPair,
      BaseReferences<_$AppDatabase, $CurrencyPairsTable, CurrencyPair>
    ),
    CurrencyPair,
    PrefetchHooks Function()>;
typedef $$CurrencyPairRatesTableCreateCompanionBuilder
    = CurrencyPairRatesCompanion Function({
  Value<int> id,
  required String date,
  required int currencyPair,
  required double rate,
});
typedef $$CurrencyPairRatesTableUpdateCompanionBuilder
    = CurrencyPairRatesCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<int> currencyPair,
  Value<double> rate,
});

class $$CurrencyPairRatesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyPairRatesTable> {
  $$CurrencyPairRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currencyPair => $composableBuilder(
      column: $table.currencyPair, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));
}

class $$CurrencyPairRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyPairRatesTable> {
  $$CurrencyPairRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currencyPair => $composableBuilder(
      column: $table.currencyPair,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));
}

class $$CurrencyPairRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyPairRatesTable> {
  $$CurrencyPairRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get currencyPair => $composableBuilder(
      column: $table.currencyPair, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$CurrencyPairRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyPairRatesTable,
    CurrencyPairRate,
    $$CurrencyPairRatesTableFilterComposer,
    $$CurrencyPairRatesTableOrderingComposer,
    $$CurrencyPairRatesTableAnnotationComposer,
    $$CurrencyPairRatesTableCreateCompanionBuilder,
    $$CurrencyPairRatesTableUpdateCompanionBuilder,
    (
      CurrencyPairRate,
      BaseReferences<_$AppDatabase, $CurrencyPairRatesTable, CurrencyPairRate>
    ),
    CurrencyPairRate,
    PrefetchHooks Function()> {
  $$CurrencyPairRatesTableTableManager(
      _$AppDatabase db, $CurrencyPairRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyPairRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyPairRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyPairRatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> currencyPair = const Value.absent(),
            Value<double> rate = const Value.absent(),
          }) =>
              CurrencyPairRatesCompanion(
            id: id,
            date: date,
            currencyPair: currencyPair,
            rate: rate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required int currencyPair,
            required double rate,
          }) =>
              CurrencyPairRatesCompanion.insert(
            id: id,
            date: date,
            currencyPair: currencyPair,
            rate: rate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrencyPairRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyPairRatesTable,
    CurrencyPairRate,
    $$CurrencyPairRatesTableFilterComposer,
    $$CurrencyPairRatesTableOrderingComposer,
    $$CurrencyPairRatesTableAnnotationComposer,
    $$CurrencyPairRatesTableCreateCompanionBuilder,
    $$CurrencyPairRatesTableUpdateCompanionBuilder,
    (
      CurrencyPairRate,
      BaseReferences<_$AppDatabase, $CurrencyPairRatesTable, CurrencyPairRate>
    ),
    CurrencyPairRate,
    PrefetchHooks Function()>;
typedef $$TransfersTableCreateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  required int cashFlowOrigin,
  required int cashFlowTarget,
});
typedef $$TransfersTableUpdateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  Value<int> cashFlowOrigin,
  Value<int> cashFlowTarget,
});

class $$TransfersTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cashFlowOrigin => $composableBuilder(
      column: $table.cashFlowOrigin,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cashFlowTarget => $composableBuilder(
      column: $table.cashFlowTarget,
      builder: (column) => ColumnFilters(column));
}

class $$TransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cashFlowOrigin => $composableBuilder(
      column: $table.cashFlowOrigin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cashFlowTarget => $composableBuilder(
      column: $table.cashFlowTarget,
      builder: (column) => ColumnOrderings(column));
}

class $$TransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cashFlowOrigin => $composableBuilder(
      column: $table.cashFlowOrigin, builder: (column) => column);

  GeneratedColumn<int> get cashFlowTarget => $composableBuilder(
      column: $table.cashFlowTarget, builder: (column) => column);
}

class $$TransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransfersTable,
    Transfer,
    $$TransfersTableFilterComposer,
    $$TransfersTableOrderingComposer,
    $$TransfersTableAnnotationComposer,
    $$TransfersTableCreateCompanionBuilder,
    $$TransfersTableUpdateCompanionBuilder,
    (Transfer, BaseReferences<_$AppDatabase, $TransfersTable, Transfer>),
    Transfer,
    PrefetchHooks Function()> {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> cashFlowOrigin = const Value.absent(),
            Value<int> cashFlowTarget = const Value.absent(),
          }) =>
              TransfersCompanion(
            id: id,
            cashFlowOrigin: cashFlowOrigin,
            cashFlowTarget: cashFlowTarget,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int cashFlowOrigin,
            required int cashFlowTarget,
          }) =>
              TransfersCompanion.insert(
            id: id,
            cashFlowOrigin: cashFlowOrigin,
            cashFlowTarget: cashFlowTarget,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransfersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransfersTable,
    Transfer,
    $$TransfersTableFilterComposer,
    $$TransfersTableOrderingComposer,
    $$TransfersTableAnnotationComposer,
    $$TransfersTableCreateCompanionBuilder,
    $$TransfersTableUpdateCompanionBuilder,
    (Transfer, BaseReferences<_$AppDatabase, $TransfersTable, Transfer>),
    Transfer,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$AccountRelationshipsTableTableManager get accountRelationships =>
      $$AccountRelationshipsTableTableManager(_db, _db.accountRelationships);
  $$CashFlowCategoriesTableTableManager get cashFlowCategories =>
      $$CashFlowCategoriesTableTableManager(_db, _db.cashFlowCategories);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$CashFlowsTableTableManager get cashFlows =>
      $$CashFlowsTableTableManager(_db, _db.cashFlows);
  $$CurrencyPairsTableTableManager get currencyPairs =>
      $$CurrencyPairsTableTableManager(_db, _db.currencyPairs);
  $$CurrencyPairRatesTableTableManager get currencyPairRates =>
      $$CurrencyPairRatesTableTableManager(_db, _db.currencyPairRates);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
}
