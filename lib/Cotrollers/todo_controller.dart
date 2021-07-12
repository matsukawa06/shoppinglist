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
          "CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, memo TEXT, price INTEGER,release INTEGER,releaseDay TEXT, isSum INTEGER, konyuZumi INTEGER, sortNo INTEGER)",
        );
      },
      version: 1,
    );
    return _database;
  }

  static Future<void> insertTodo(TodoStore todo) async {
    final Database db = await database;
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<TodoStore>> getAllTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('todo', orderBy: "sortNo ASC");
    return List.generate(maps.length, (i) {
      return TodoStore(
        id: maps[i]['id'],
        title: maps[i]['title'],
        memo: maps[i]['memo'],
        price: maps[i]['price'],
        release: maps[i]['release'],
        releaseDay: DateTime.now(), //maps[i]['releaseDay'],
        isSum: maps[i]['isSum'],
        konyuZumi: maps[i]['konyuZumi'],
        sortNo: maps[i]['sortNo'],
      );
    });
  }

  static Future<int> getListCount() async {
    final Database db = await database;
    var result1 = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM todo)',
    );
    var result2 = await db.rawQuery(
      'SELECT COUNT(*) FROM todo',
    );
    int? exists = Sqflite.firstIntValue(result1);
    return exists == 1 ? Sqflite.firstIntValue(result2)! : 0;
  }

  static Future<int> getSumPrice() async {
    final Database db = await database;
    var result1 = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM todo)',
    );
    var result2 = await db.rawQuery(
      'SELECT SUM(price) FROM todo',
    );
    int? exists = Sqflite.firstIntValue(result1);
    return exists == 1 ? Sqflite.firstIntValue(result2)! : 0;
  }

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

  static Future<void> updateSotrNo(int id, int sortNo) async {
    var values = <String, dynamic>{"sortNo": sortNo};
    final db = await database;
    await db.update('todo', values, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todo',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
