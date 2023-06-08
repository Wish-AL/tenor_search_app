import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class FavoriteList {
  int id;
  String gifUrl;
  String previewUrl;

  FavoriteList({
    required this.id,
    required this.gifUrl,
    required this.previewUrl,
  });

  Map<String, Object?> toMap() {
    return {
    'id': id,
    'gifurl': gifUrl,
    'previewurl': previewUrl,
    };
  }
  // FavoriteList();
  // FavoriteList.fromMap(Map<String, dynamic> map) {
  //   id = map['id'];
  //   gifUrl = map['gifurl'];
  //   previewUrl = map['previewurl'];
  // }
  @override
  String toString() {
    return 'FavoriteList{id: $id, gifurl: $gifUrl, previewurl: $previewUrl}';
  }
}

class DataBaseManage {

  // Database gifDB;
  // DataBaseManage(){
  //   gifDB = _createDB();
  // }

  Future<Database> createDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'gifs_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS FavoriteGifs (id INTEGER PRIMARY KEY AUTOINCREMENT, gifurl VARCHAR(100), previewurl VARCHAR(100))',
          );
        }, version: 1);
  }

  Future<void> insertToDB(String gifUrl, String previewUrl) async {
    final Database db = await createDB();
    await db
        .insert('FavoriteGifs', {'gifurl': gifUrl, 'previewurl': previewUrl});
  }
  // Future<int> _insertToDB(String gifUrl, String previewUrl) async {
  //   int result = 0;
  //   final Database db = await createDB();
  //   final id = await db.insert(
  //       'Notes', note.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  Future<List<FavoriteList>> gifs() async {
    final db = await createDB();
    final List<Map<String, dynamic>> mapsGifs = await db.query('FavoriteGifs');
    return List.generate(mapsGifs.length, (index) {
      return FavoriteList(
        id: mapsGifs[index]['id'],
        gifUrl: mapsGifs[index]['gifurl'],
        previewUrl: mapsGifs[index]['previewurl'],
      );
    });
  }
  // Future<List<FavoriteList>> getItems() async {
  //   final db = await createDB();
  //   final List<Map<String, Object?>> queryResult =
  //   await db.query('Notes', orderBy: NoteColumn.createdAt);
  //   return queryResult.map((e) => Note.fromMap(e)).toList();
  // }

  Future<void> deleteFromDB(int id) async {
    final db = await createDB();
    await db.delete('FavoriteGifs', where: 'id = ?', whereArgs: [id]);
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
