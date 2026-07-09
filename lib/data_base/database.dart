import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'dart:convert';

part 'database.g.dart';

@DataClassName('Account')
class Accounts extends Table {
  @override
  String get tableName => 'account';
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('""'))();
  BoolColumn get canReceiveCashFlows => boolean()();
}

class AccountRelationships extends Table {
  @override
  String get tableName => 'account_relationship';
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentAccount => integer().references(Accounts, #id)();
  IntColumn get childAccount => integer().unique().references(Accounts, #id)();
}

@DataClassName('CashFlowCategory')
class CashFlowCategories extends Table {
  @override
  String get tableName => 'cash_flow_category';
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconName => text().nullable()();
  TextColumn get iconColor => text().nullable()();
  TextColumn get iconPack => text().nullable()();
}

@DataClassName('CurrencyModel')
class Currencies extends Table {
  @override
  String get tableName => 'currency';
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get symbol => text().nullable()();
  TextColumn get iso => text().unique()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('FIAT'))();
  IntColumn get decimalPoints => integer().withDefault(const Constant(2))();
  BoolColumn get symbolOnLeft => boolean().withDefault(const Constant(true))();
}

@DataClassName('CashFlow')
class CashFlows extends Table {
  @override
  String get tableName => 'cash_flow';
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  RealColumn get amount => real()();
  IntColumn get account => integer().references(Accounts, #id)();
  IntColumn get currency => integer().references(Currencies, #id)();
  IntColumn get category => integer().nullable().references(CashFlowCategories, #id)();
  TextColumn get description => text().withDefault(const Constant(''))();
  BlobColumn get descriptionImage => blob().nullable()();
}

class CurrencyPairs extends Table {
  @override
  String get tableName => 'currency_pair';
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currencyOrigin => integer().references(Currencies, #id)();
  IntColumn get currencyTarget => integer().references(Currencies, #id)();
}

class CurrencyPairRates extends Table {
  @override
  String get tableName => 'currency_pair_rate';
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  IntColumn get currencyPair => integer().references(CurrencyPairs, #id)();
  RealColumn get rate => real()();
}

class Transfers extends Table {
  @override
  String get tableName => 'transfer';
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cashFlowOrigin => integer().unique().references(CashFlows, #id)();
  IntColumn get cashFlowTarget => integer().unique().references(CashFlows, #id)();
}

@DriftDatabase(tables: [
  Accounts,
  AccountRelationships,
  CashFlowCategories,
  Currencies,
  CashFlows,
  CurrencyPairs,
  CurrencyPairRates,
  Transfers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Since data.sql already has CREATE TABLE statements, we just execute it directly
        // and bypass Drift's createAll() to ensure exact schema matching and populated data.
        final bytes = await rootBundle.load("data/data.sql");
        final sqlScript = utf8.decode(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        
        final statements = sqlScript.split(';');
        for (final statement in statements) {
          if (statement.trim().isNotEmpty) {
            try {
              await customStatement(statement);
            } catch (e) {
              print('Error executing: $statement');
              print(e);
            }
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'budgetea/drift_database.db'));
    return NativeDatabase.createInBackground(file);
  });
}
