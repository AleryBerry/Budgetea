import 'package:my_app/data_base/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:my_app/models/category.dart';

class DatabaseRepository {
  final AppDatabase driftDb;

  DatabaseRepository(this.driftDb);

  Future<List<CategoryWithUsage>> getCategoriesWithUsageCount() async {
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
    final result = await driftDb.customSelect(query).get();
    return result.map((row) => CategoryWithUsage.fromJson(row.data)).toList();
  }

  Future<List<Map<String, Object?>>> getMonthlyCashFlow(int accountId) async {
    const String query = """
    SELECT
        strftime('%Y-%m', date) as month,
        currency,
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) as expense
    FROM
        cash_flow
    WHERE
        account = ?
    GROUP BY
        month, currency
    ORDER BY
        month;
    """;
    final result = await driftDb.customSelect(query, variables: [drift.Variable.withInt(accountId)]).get();
    return result.map((r) => r.data).toList();
  }

  Future<List<Map<String, Object?>>> getCategoryExpenses(int accountId) async {
    const String query = """
    SELECT
        cfc.name,
        cf.currency,
        SUM(cf.amount) as total
    FROM
        cash_flow cf
    JOIN
        cash_flow_category cfc ON cf.category = cfc.id
    WHERE
        cf.account = ? AND cf.amount < 0
    GROUP BY
        cfc.name, cf.currency
    ORDER BY
        total;
    """;
    final result = await driftDb.customSelect(query, variables: [drift.Variable.withInt(accountId)]).get();
    return result.map((r) => r.data).toList();
  }

  Future<List<Map<String, Object?>>> getBalanceOverTime(int accountId) async {
    const String query = """
    SELECT
        date,
        amount,
        currency
    FROM
        cash_flow
    WHERE
        account = ?
    ORDER BY
        date;
    """;
    final result = await driftDb.customSelect(query, variables: [drift.Variable.withInt(accountId)]).get();
    return result.map((r) => r.data).toList();
  }

  // Old budgetea_database.dart compat methods

  Future<int> insertItem(dynamic item, String table) async {
    final map = item.toMap() as Map<String, dynamic>;
    return await insert(table, map);
  }

  Future<int> updateItem(dynamic item, String table) async {
    final map = item.toMap() as Map<String, dynamic>;
    final id = map.remove('id');
    return await update(table, map, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id, String table) async {
    return await delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // SQLite-like methods to replace raw Database access

  Future<List<Map<String, Object?>>> query(String table, {String? where, List<Object?>? whereArgs, int? limit, String? orderBy}) async {
    String sql = 'SELECT * FROM $table';
    if (where != null) {
      sql += ' WHERE $where';
    }
    if (orderBy != null) {
      sql += ' ORDER BY $orderBy';
    }
    if (limit != null) {
      sql += ' LIMIT $limit';
    }
    final result = await driftDb.customSelect(
      sql,
      variables: whereArgs?.map((e) => drift.Variable(e)).toList() ?? [],
    ).get();
    return result.map((r) => r.data).toList();
  }

  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final result = await driftDb.customSelect(
      sql,
      variables: arguments?.map((e) => drift.Variable(e)).toList() ?? [],
    ).get();
    return result.map((r) => r.data).toList();
  }

  Stream<List<Map<String, Object?>>> watchQuery(String sql, {Set<drift.ResultSetImplementation>? readsFrom, List<Object?>? arguments}) {
    return driftDb.customSelect(
      sql,
      variables: arguments?.map((e) => drift.Variable(e)).toList() ?? [],
      readsFrom: readsFrom ?? const {},
    ).watch().map((rows) => rows.map((r) => r.data).toList());
  }

  Future<int> insert(String table, Map<String, Object?> values, {dynamic conflictAlgorithm}) async {
    final columns = values.keys.join(', ');
    final placeholders = values.keys.map((_) => '?').join(', ');
    final args = values.values.toList();
    
    // customInsert returns the id if supported
    return await driftDb.customInsert(
      'INSERT OR REPLACE INTO $table ($columns) VALUES ($placeholders)',
      variables: args.map((v) => drift.Variable(v)).toList(),
    );
  }

  Future<int> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs}) async {
    final setClause = values.keys.map((k) => '$k = ?').join(', ');
    var sql = 'UPDATE $table SET $setClause';
    final args = values.values.toList();
    if (where != null) {
      sql += ' WHERE $where';
      if (whereArgs != null) {
        args.addAll(whereArgs);
      }
    }
    await driftDb.customStatement(
      sql,
      args,
    );
    return 1; // Return count isn't natively supported by customStatement in drift
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    var sql = 'DELETE FROM $table';
    final args = <Object?>[];
    if (where != null) {
      sql += ' WHERE $where';
      if (whereArgs != null) {
        args.addAll(whereArgs);
      }
    }
    await driftDb.customStatement(sql, args);
    return 1;
  }

  DriftBatchWrapper batch() => DriftBatchWrapper(this);
}

class DriftBatchWrapper {
  final DatabaseRepository db;
  final List<Future<dynamic> Function()> _operations = [];

  DriftBatchWrapper(this.db);

  void insert(String table, Map<String, Object?> values, {dynamic conflictAlgorithm}) {
    _operations.add(() => db.insert(table, values, conflictAlgorithm: conflictAlgorithm));
  }

  void update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs}) {
    _operations.add(() => db.update(table, values, where: where, whereArgs: whereArgs));
  }

  void delete(String table, {String? where, List<Object?>? whereArgs}) {
    _operations.add(() => db.delete(table, where: where, whereArgs: whereArgs));
  }

  Future<List<dynamic>> commit({bool? continueOnError, bool? noResult}) async {
    final results = <dynamic>[];
    await db.driftDb.transaction(() async {
      for (final op in _operations) {
        if (continueOnError == true) {
          try {
            results.add(await op());
          } catch (e) {
            results.add(e);
          }
        } else {
          results.add(await op());
        }
      }
    });
    return results;
  }
}
