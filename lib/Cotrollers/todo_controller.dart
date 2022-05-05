import '../Common/importer.dart';

import 'dart:async';
import 'database.dart';

class TodoController {
  // Todoテーブルに1件追加
  static Future<void> insertTodo(TodoStore todo) async {
    final Database db = await MyDataBase.database;
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Todoテーブルから対象のデータ取得
  static Future<List<TodoStore>> getTodos() async {
    final Database db = await MyDataBase.database;
    // ローカル設定の取得
    var prefs = await SharedPreferences.getInstance();
    // 購入済みを表示する区分
    var konyuZumiView = prefs.getBool(keyKonyuzumiView) ?? false;
    var konyuZumi = konyuZumiView ? 2 : 1;
    // 選択中のグループリストID
    var selectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);

    final List<Map<String, dynamic>> maps = await db.query(
      'todo',
      where: "konyuZumi <> ? AND isDelete = 0 AND groupId = ?",
      // where: "konyuZumi <> ?",
      whereArgs: [konyuZumi, selectedId],
      orderBy: "sortNo ASC",
    );
    return List.generate(
      maps.length,
      (i) {
        return TodoStore(
          id: maps[i]['id'],
          title: maps[i]['title'],
          memo: maps[i]['memo'],
          price: maps[i]['price'],
          release: maps[i]['release'],
          releaseDay: DateTime.parse(maps[i]['releaseDay']).toLocal(),
          isSum: maps[i]['isSum'],
          konyuZumi: maps[i]['konyuZumi'],
          sortNo: maps[i]['sortNo'],
          isDelete: maps[i]['isDelete'],
          deleteDay: DateTime.parse(maps[i]['deleteDay']).toLocal(),
          groupId: maps[i]['groupId'],
          konyuDay: DateTime.parse(maps[i]['konyuDay']).toLocal(),
        );
      },
    );
  }

  // Todoテーブルから件数を取得
  static Future<int> getListCount(int selectedId) async {
    final Database db = await MyDataBase.database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) FROM todo where isDelete = 0 AND groupId = ?',
      [selectedId],
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == null ? 0 : Sqflite.firstIntValue(result)!;
  }

  // Todoテーブルの1件を更新
  static Future<void> updateTodo(TodoStore todo) async {
    // Get a reference to the database.
    final db = await MyDataBase.database;
    await db.update(
      'todo',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Todoテーブルソート番号を更新
  static Future<void> updateSotrNo(int id, int sortNo) async {
    var values = <String, dynamic>{"sortNo": sortNo};
    final db = await MyDataBase.database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルの金額合計対象フラグを更新
  static Future<void> updateIsSum(int id, bool isSum) async {
    var values = <String, dynamic>{"isSum": boolToInt(isSum)};
    final db = await MyDataBase.database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルの購入済みフラグを更新
  static Future<void> updateKonyuZumi(int id, bool konyuZumi) async {
    var values = <String, dynamic>{"konyuZumi": boolToInt(konyuZumi)};
    final db = await MyDataBase.database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
    if (konyuZumi == true) {
      var values = <String, dynamic>{
        "konyuDay": DateTime.now().toUtc().toIso8601String()
      };
      await db.update('todo', values, where: "id = ?", whereArgs: [id]);
    }
  }

  // Todoテーブルの削除フラグを更新
  static Future<void> updateIsDelete(int id, bool isDelete) async {
    var values = <String, dynamic>{"isDelete": boolToInt(isDelete)};
    final db = await MyDataBase.database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルから1件を削除
  static Future<void> deleteTodo(int id) async {
    final db = await MyDataBase.database;
    await db.delete(
      'todo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Todoテーブルから対象グループIDのデータを削除
  static Future<void> deleteTodoGroup(int groupId) async {
    final db = await MyDataBase.database;
    await db.delete(
      'todo',
      where: "groupId = ?",
      whereArgs: [groupId],
    );
  }
}
