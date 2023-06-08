import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class FavoriteList {
  String id;
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

  @override
  String toString() {
    return 'FavoriteList{id: $id, gifurl: $gifUrl, previewurl: $previewUrl}';
  }
}

class DataBaseManage {
  Future<Database> createDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'tenor_gifs_database.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS FavoriteGifs (id VARCHAR(20) PRIMARY KEY, gifurl VARCHAR(100), previewurl VARCHAR(100))',
      );
    }, version: 1);
  }

  Future<void> insertToDB(String id, String gifUrl, String previewUrl) async {
    final Database db = await createDB();
    await db.insert(
        'FavoriteGifs', {'id': id, 'gifurl': gifUrl, 'previewurl': previewUrl},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

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

  Future<void> deleteFromDB(String id) async {
    final db = await createDB();
    await db.delete('FavoriteGifs', where: 'id = ?', whereArgs: [id]);
  }
}
