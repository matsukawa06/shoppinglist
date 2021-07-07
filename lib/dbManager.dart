import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class Todo {
  final int? id;
  final String title;
  final String memo;
  final int price;
  final int release;
  final DateTime releaseDay;
  final int isSum;
  final int konyuZumi;

  Todo(
      {this.id,
      required this.title,
      required this.memo,
      required this.price,
      required this.release,
      required this.releaseDay,
      required this.isSum,
      required this.konyuZumi});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'price': price,
      'release': release,
      'releaseDay': releaseDay.toUtc().toIso8601String(),
      'isSum': isSum,
      'konyuZumi': konyuZumi,
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, memo: $memo, price: $price}';
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, memo TEXT, price INTEGER,release INTEGER,releaseDay TEXT, isSum INTEGER, konyuZumi INTEGER)",
        );
      },
      version: 1,
    );
    return _database;
  }

  static Future<void> insertTodo(Todo todo) async {
    final Database db = await database;
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Todo>> getTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todo');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        memo: maps[i]['memo'],
        price: maps[i]['price'],
        release: maps[i]['release'],
        releaseDay: DateTime.now(), //maps[i]['releaseDay'],
        isSum: maps[i]['isSum'],
        konyuZumi: maps[i]['konyuZumi'],
      );
    });
  }

  static Future<void> updateTodo(Todo todo) async {
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

  static Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todo',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
//   var memo = Memo(
//     id: 0,
//     title: 'Flutterで遊ぶ',
//     memo: 'メモ',
//     price: 0,
//     release: 0,
//     releaseDay: DateTime.now(),
//     isSum: 0,
//     konyuZumi: 0,
//   );

//   await insertMemo(memo);

//   print(await getMemos());

//   memo = Memo(
//     id: memo.id,
//     title: memo.title,
//     memo: memo.memo,
//     price: memo.price,
//     release: memo.release,
//     releaseDay: memo.releaseDay,
//     isSum: memo.isSum,
//     konyuZumi: memo.konyuZumi,
//   );
//   await updateMemo(memo);

//   // Print Fido's updated information.
//   print(await getMemos());

//   // Delete Fido from the database.
//   await deleteMemo(memo.id!);

//   // Print the list of dogs (empty).
//   print(await getMemos());
// }
