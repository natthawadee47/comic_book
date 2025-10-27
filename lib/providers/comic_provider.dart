// lib/providers/comic_provider.dart
import 'package:flutter/foundation.dart';
import '../db/comic_db.dart';
import '../models/comic_book.dart';

class ComicProvider extends ChangeNotifier {
  final List<ComicBook> _items = [];
  List<ComicBook> get items => _items;

  Future<void> loadComics() async {
    final comics = await ComicDB.instance.getComics();
    _items
      ..clear()
      ..addAll(comics);
    notifyListeners();
  }

  Future<void> addComic(ComicBook comic) async {
    await ComicDB.instance.insertComic(comic);
    await loadComics();
  }

  Future<void> updateComic(ComicBook comic) async {
    await ComicDB.instance.updateComic(comic);
    await loadComics();
  }

  Future<void> deleteComic(int id) async {
    await ComicDB.instance.deleteComic(id);
    await loadComics();
  }
}
