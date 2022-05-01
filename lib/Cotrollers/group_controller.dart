// import 'package:shared_preferences/shared_preferences.dart';

import '../Common/importer.dart';
import 'database.dart';

class GroupController {
  // Groupテーブルに1件追加
  static Future<void> insertGroup(GroupStore group) async {
    final Database db = await MyDataBase.database;
    await db.insert(
      'grouplist',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Groupテーブルから対象のデータ取得
  static Future<List<GroupStore>> getGroup() async {
    final Database db = await MyDataBase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grouplist',
      orderBy: "id ASC",
    );
    return List.generate(
      maps.length,
      (i) {
        return GroupStore(
          id: maps[i]['id'],
          title: maps[i]['title'],
          color: maps[i]['color'],
        );
      },
    );
  }

  ///
  /// grouplistからselect中のデータを取得
  ///
  static Future<List<GroupStore>> getGroupSelect(int? id) async {
    final Database db = await MyDataBase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grouplist',
      where: "id = ?",
      whereArgs: [id],
    );
    return List.generate(
      maps.length,
      (i) {
        return GroupStore(
          id: maps[i]['id'],
          title: maps[i]['title'],
          color: maps[i]['color'],
        );
      },
    );
  }

  ///
  /// grouplistからIDを指定してデータ取得
  ///
  static Future<List<GroupStore>> getGroupId(int? id) async {
    final Database db = await MyDataBase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grouplist',
      where: "id = ?",
      whereArgs: [id],
    );
    return List.generate(
      maps.length,
      (i) {
        return GroupStore(
          title: maps[i]['title'],
          color: maps[i]['color'],
        );
      },
    );
  }

  // Groupテーブルの1件を更新
  static Future<void> updateGroup(GroupStore store) async {
    final db = await MyDataBase.database;
    await db.update(
      'grouplist',
      store.toMap(),
      where: "id = ?",
      whereArgs: [store.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  ///
  /// Groupテーブルから1件削除
  ///
  static Future<void> deleteGroup(int id) async {
    final db = await MyDataBase.database;
    await db.delete(
      'grouplist',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
