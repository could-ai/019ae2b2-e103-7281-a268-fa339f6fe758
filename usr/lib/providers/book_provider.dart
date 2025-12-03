import 'package:flutter/material.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      isbn: '978-0743273565',
      genre: 'Classic',
      publicationDate: DateTime(1925, 4, 10),
      status: 'Available',
    ),
    Book(
      id: '2',
      title: '1984',
      author: 'George Orwell',
      isbn: '978-0451524935',
      genre: 'Dystopian',
      publicationDate: DateTime(1949, 6, 8),
      status: 'Borrowed',
    ),
    Book(
      id: '3',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      isbn: '978-0061120084',
      genre: 'Classic',
      publicationDate: DateTime(1960, 7, 11),
      status: 'Available',
    ),
    Book(
      id: '4',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      isbn: '978-0547928227',
      genre: 'Fantasy',
      publicationDate: DateTime(1937, 9, 21),
      status: 'Available',
    ),
    Book(
      id: '5',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      isbn: '978-1503290563',
      genre: 'Romance',
      publicationDate: DateTime(1813, 1, 28),
      status: 'Lost',
    ),
  ];

  List<Book> get books => [..._books];

  List<Book> get recentBooks => _books.take(5).toList();

  int get totalBooks => _books.length;
  int get availableBooks => _books.where((b) => b.status == 'Available').length;
  int get borrowedBooks => _books.where((b) => b.status == 'Borrowed').length;

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(String id, Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == id);
    if (index >= 0) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}
