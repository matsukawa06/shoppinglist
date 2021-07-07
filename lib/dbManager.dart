import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void dbManager() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'memo_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE memo(id INTEGER PRIMARY KEY, title TEXT, memo TEXT, price INTEGER,release INTEGER,releaseDay TEXT, isSum INTEGER, konyuZumi INTEGER)",
      );
    },
    version: 1,
  );

  Future<void> insertMemo(Memo memo) async {
    final Database db = await database;
    await db.insert(
      'memo',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> getMemos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        memo: maps[i]['memo'],
        price: maps[i]['price'],
        release: maps[i]['release'],
        releaseDay: maps[i]['releaseDay'],
        isSum: maps[i]['isSum'],
        konyuZumi: maps[i]['konyuZumi'],
      );
    });
  }

  Future<void> updateMemo(Memo memo) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      'memo',
      memo.toMap(),
      where: "id = ?",
      whereArgs: [memo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'memo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  var memo = Memo(
    id: 0,
    title: 'Flutterで遊ぶ',
    memo: 'メモ',
    price: 0,
    release: 0,
    releaseDay: DateTime.now(),
    isSum: 0,
    konyuZumi: 0,
  );

  await insertMemo(memo);

  print(await getMemos());

  memo = Memo(
    id: memo.id,
    title: memo.title,
    memo: memo.memo,
    price: memo.price,
    release: memo.release,
    releaseDay: memo.releaseDay,
    isSum: memo.isSum,
    konyuZumi: memo.konyuZumi,
  );
  await updateMemo(memo);

  // Print Fido's updated information.
  print(await getMemos());

  // Delete Fido from the database.
  await deleteMemo(memo.id!);

  // Print the list of dogs (empty).
  print(await getMemos());
}

class Memo {
  final int? id;
  final String title;
  final String memo;
  final int price;
  final int release;
  final DateTime releaseDay;
  final int isSum;
  final int konyuZumi;

  const Memo(
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
    return 'Memo{id: $id, title: $title, memo: $memo, price: $price}';
  }
}
