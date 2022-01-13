import 'package:shoppinglist/Common/common_util.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import '../Models/todo_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController {
  static Future<Database> get database async {
    const scripts = {
      '2': ['ALTER TABLE todo ADD COLUMN isDelete INTEGER;'],
      '3': ['ALTER TABLE todo ADD COLUMN deleteDay TEXT;'],
      '4': ['ALTER TABLE todo ADD COLUMN groupId INTEGER;'],
    };
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      version: 4,
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
            sortNo INTEGER,
          )''',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          var queries = scripts[i.toString()];
          for (String query in queries!) {
            await db.execute(query);
          }
        }
      },
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

  // Todoテーブルから対象のデータ取得
  static Future<List<TodoStore>> getTodos() async {
    final Database db = await database;
    var prefs = await SharedPreferences.getInstance();
    var konyuZumiView = prefs.getBool('konyuZumiView') ?? false;
    var konyuZumi = konyuZumiView ? 2 : 1;
    final List<Map<String, dynamic>> maps = await db.query(
      'todo',
      where: "konyuZumi <> ? AND isDelete = 0",
      whereArgs: [konyuZumi],
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

  // Todoテーブルの削除フラグを更新
  static Future<void> updateIsDelete(int id, bool isDelete) async {
    var values = <String, dynamic>{"isDelete": boolToInt(isDelete)};
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
