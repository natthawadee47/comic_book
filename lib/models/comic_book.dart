// lib/models/comic_book.dart
class ComicBook {
  final int? id;
  final String title;
  final String author;
  final String genre;
  final int year;
  final double price;
  final double rating;
  final String? summary;
  final String? imageUrl;

  ComicBook({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.year,
    required this.price,
    required this.rating,
    this.summary,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,
        'year': year,
        'price': price,
        'rating': rating,
        'summary': summary,
        'imageUrl': imageUrl,
      };

  factory ComicBook.fromMap(Map<String, dynamic> map) => ComicBook(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        genre: map['genre'],
        year: map['year'],
        price: map['price'],
        rating: map['rating'],
        summary: map['summary'],
        imageUrl: map['imageUrl'],
      );
}
