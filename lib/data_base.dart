import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';


class FavoriteList {
  final int id;
  final String gifUrl;
  final String previewUrl;

  const FavoriteList({
    required this.id,
    required this.gifUrl,
    required this.previewUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gifurl': gifUrl,
      'previewurl': previewUrl,
    };
  }
  @override
  String toString() {
    return 'FavoriteList{id: $id, gifurl: $gifUrl, previewurl: $previewUrl}';
  }
}

class DataBaseManage {
  final int _version = 1;
  final String _dbname = 'gifs_database.db';
  static Database? _db;
  DataBaseManage(){
    _createDB();
  }

  Future<void> _createDB() async {
    _db = await openDatabase(join(await getDatabasesPath(), 'gifs_database.db'),
        onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS FavoriteGifs (id INTEGER PRIMARY KEY AUTOINCREMENT, gifurl VARCHAR(100), previewurl VARCHAR(100))',
      );
    }, version: _version);
  }

  Future<void> insertToDB(String gifUrl, String previewUrl) async {
    await _db
        ?.insert('FavoriteGifs', {'gifurl': gifUrl, 'previewurl': previewUrl});
  }

  static Future<List<FavoriteList>> gifs() async {
    final List<Map<String, dynamic>>? mapsGifs = await _db?.query('FavoriteGifs');
    return List.generate(mapsGifs!.length, (index) {
      return FavoriteList(
        id: mapsGifs[index]['id'],
        gifUrl: mapsGifs[index]['gifurl'],
        previewUrl: mapsGifs[index]['previewurl'],
      );
    });
  }

  Future<void> deleteFromDB(int id) async {
    await _db?.delete('FavoriteGifs', where: 'id = ?', whereArgs: [id]);
  }

//static String url;
// static void createDB(String gifUrl, String previewUrl) {
//   final db = sqlite3.open("database.db");
//
//   db.execute("""
//   CREATE TABLE IF NOT EXISTS FavoriteGifs (
//     id INT PRIMARY KEY AUTOINCREMENT,
//     gifurl VARCHAR(100),
//     preivewurl VARCHAR(100),
//   );
// """);
//
//   db.execute("""
// INSERT INTO FavoriteGifs (gifurl, preivewurl)
//   VALUES(
//     '${gifUrl}',
//     '${previewUrl}',
//   );
// """);
//   db.dispose();
// }
// static void getListFromDB() {
//   final db = sqlite3.open('database.db');
//   final ResultSet resultSet =
//   db.select("SELECT preivewurl FROM FavoriteGifs");
//   final Map<int, String> result = <int, String>{};
//   for (final Row row in resultSet) {
//     print(row);
//   }
//   //return result;
//   db.dispose();
// }
// static void deleteFromDB(int id) {
//   final db = sqlite3.open('database.db');
//   db.execute ('DELETE FROM FavoriteGifs WHERE id = ${id}');
//   db.dispose();
// }
}
