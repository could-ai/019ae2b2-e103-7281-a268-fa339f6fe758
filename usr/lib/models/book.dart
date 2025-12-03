class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String genre;
  final DateTime publicationDate;
  final String status; // 'Available', 'Borrowed', 'Lost'
  final String? coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.genre,
    required this.publicationDate,
    this.status = 'Available',
    this.coverUrl,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? genre,
    DateTime? publicationDate,
    String? status,
    String? coverUrl,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      publicationDate: publicationDate ?? this.publicationDate,
      status: status ?? this.status,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}
