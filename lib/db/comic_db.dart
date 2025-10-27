// lib/db/comic_db.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/comic_book.dart';

class ComicDB {
  static final ComicDB instance = ComicDB._init();
  static Database? _database;
  ComicDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('comic.db');
    return _database!;
  }

  Future<Database> _initDB(String file) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, file);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE comics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        genre TEXT,
        year INTEGER,
        price REAL,
        rating REAL,
        summary TEXT,
        imageUrl TEXT
      )
    ''');
  }

  Future<int> insertComic(ComicBook c) async {
    final db = await database;
    return db.insert('comics', c.toMap());
  }

  Future<List<ComicBook>> getComics() async {
    final db = await database;
    final result = await db.query('comics', orderBy: 'title');
    return result.map((e) => ComicBook.fromMap(e)).toList();
  }

  Future<int> updateComic(ComicBook c) async {
    final db = await database;
    return db.update('comics', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
  }

  Future<int> deleteComic(int id) async {
    final db = await database;
    return db.delete('comics', where: 'id = ?', whereArgs: [id]);
  }
}
