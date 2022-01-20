import '../Common/importer.dart';

import 'package:path/path.dart';

class MyDataBase {
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      // このversionで実行するスクリプトを制御する
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database;
  }

  // Table新規作成処理
  static _onCreate(
    Database database,
    int version,
  ) async {
    await _migrate(database, 0, version);
  }

  // Tableバージョンアップ処理
  static _onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    await _migrate(database, oldVersion, newVersion);
  }

  ///
  /// テーブル新規作成 及び バージョンアップ
  static Future<void> _migrate(
      Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      final queries = migrationScripts[i.toString()]!;
      for (final query in queries) {
        await db.execute(query);
      }
    }
  }

  static const migrationScripts = {
    '1': [
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
          )'''
    ],
    '2': [
      'ALTER TABLE todo ADD COLUMN isDelete INTEGER DEFAULT 0;',
      "ALTER TABLE todo ADD COLUMN deleteDay TEXT DEFAULT '2200-01-01';",
      'ALTER TABLE todo ADD COLUMN groupId INTEGER DEFAULT 0;'
    ],
    '3': [
      '''
        CREATE TABLE grouplist(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title TEXT,
          defualtKbn TEXT
        )'''
    ],
  };
}
