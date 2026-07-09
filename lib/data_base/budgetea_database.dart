import "dart:async";
import "dart:convert";
import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:path/path.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:my_app/models/category.dart";
import "package:path_provider/path_provider.dart";

import 'package:my_app/data_base/database.dart';
import 'package:my_app/data_base/repository.dart';

// Export DatabaseRepository as Database to avoid breaking UI code imports
typedef Database = DatabaseRepository;
typedef Batch = DriftBatchWrapper;

enum ConflictAlgorithm {
  replace, rollback, abort, fail, ignore
}

class BudgeteaDatabase {
  static DatabaseRepository? database;
  static AppDatabase? _driftDb;

  static Future<void> initDB(String filePath) async {
    _driftDb = AppDatabase();
    database = DatabaseRepository(_driftDb!);
  }

  Future<int> insert(dynamic item, dynamic table) async {
    return await database!.insertItem(item, table as String);
  }

  Future<int> delete(int id, dynamic table) async {
    return await database!.deleteItem(id, table as String);
  }

  Future<int> update(dynamic item, dynamic table) async {
    return await database!.updateItem(item, table as String);
  }

  Future<dynamic> getCategoriesWithUsageCount() async {
    return await database!.getCategoriesWithUsageCount();
  }

  Future<dynamic> getMonthlyCashFlow(int accountId) async {
    return await database!.getMonthlyCashFlow(accountId);
  }

  Future<dynamic> getCategoryExpenses(int accountId) async {
    return await database!.getCategoryExpenses(accountId);
  }

  Future<dynamic> getBalanceOverTime(int accountId) async {
    return await database!.getBalanceOverTime(accountId);
  }
}

