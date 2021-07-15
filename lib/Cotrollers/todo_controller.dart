import 'package:shoppinglist/Common/common_util.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import '../Models/todo_store.dart';

class TodoController {
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE todo(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            memo TEXT, 
            price INTEGER,
            release INTEGER,
            releaseDay TEXT, 
            isSum INTEGER, 
            konyuZumi INTEGER, 
            sortNo INTEGER
          )''',
        );
      },
      version: 1,
    );
    return _database;
  }

  // Todoテーブルに1件追加
  static Future<void> insertTodo(TodoStore todo) async {
    final Database db = await database;
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Todoテーブルから全件取得
  static Future<List<TodoStore>> getTodos(int konyuZumi) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todo',
        where: "konyuZumi<>?", whereArgs: [konyuZumi], orderBy: "sortNo ASC");
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
        );
      },
    );
  }

  // Todoテーブルから件数を取得
  static Future<int> getListCount() async {
    final Database db = await database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) FROM todo',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == null ? 0 : Sqflite.firstIntValue(result)!;
  }

  // Todoテーブルの1件を更新
  static Future<void> updateTodo(TodoStore todo) async {
    // Get a reference to the database.
    final db = await database;
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
    final db = await database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルの金額合計対象フラグを更新
  static Future<void> updateReleaseDay(int id, bool isSum) async {
    var values = <String, dynamic>{"isSum": boolToInt(isSum)};
    final db = await database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルの購入済みフラグを更新
  static Future<void> updateKonyuZumi(int id, bool konyuZumi) async {
    var values = <String, dynamic>{"konyuZumi": boolToInt(konyuZumi)};
    final db = await database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  // Todoテーブルから1件を削除
  static Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todo',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
