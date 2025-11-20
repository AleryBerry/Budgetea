import "dart:async";
import "dart:convert";
import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:path/path.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:my_app/models/category.dart";
import "package:path_provider/path_provider.dart";

class BudgeteaDatabase {
  static Database? database;

  static const String transactionsTable = "Transactions";
  final String accountsTable = "Accounts";
  final String categoriesTable = "Categories";

  static Future<Database> initDB(String filePath) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    final String dbPath = (await getApplicationDocumentsDirectory()).path;
    final String path = join(dbPath, filePath);
    final Database db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 3,
        onOpen: (Database db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        onCreate: (Database db, int version) async {
          final ByteData bytes = await rootBundle.load("data/data.sql");
          try {
            await db.execute(utf8.decode(bytes.buffer
                .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)));
          } catch (e) {
            debugPrint(e.toString().split(" ").take(100).join(" "));
          }
        },
      ),
    );
    return db;
  }

  // static Future _onCreateDB(Database db, int version) async {
  //   await db.execute('''
  //   ''');
  // }

  Future<int> insert(dynamic item, dynamic table) async {
    final Database? db = database;

    int id = await db!.insert(table, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> delete(int id, dynamic table) async {
    final Database? db = database;
    return await db!.delete(
      table,
      where: "id = ?",
      whereArgs: <Object?>[id],
    );
  }

  Future<int> update(dynamic item, dynamic table) async {
    final Database? db = database;
    return await db!.update(
      table,
      item.toMap(),
      where: "id=?",
      whereArgs: <Object?>[item.id],
    );
  }

  Future<List<CategoryWithUsage>> getCategoriesWithUsageCount() async {
    final Database? db = database;
    const String query = """
      SELECT
        cfc.id,
        cfc.name,
        cfc.icon_name,
        cfc.icon_color,
        cfc.icon_pack,
        COUNT(cf.id) as transaction_count
      FROM
        cash_flow_category cfc
      LEFT JOIN
        cash_flow cf ON cfc.id = cf.category
      GROUP BY
        cfc.id
      ORDER BY
        cfc.name
    """;
    final List<Map<String, Object?>> result = await db!.rawQuery(query);
    return result
        .map((Map<String, Object?> json) => CategoryWithUsage.fromJson(json))
        .toList();
  }
}
