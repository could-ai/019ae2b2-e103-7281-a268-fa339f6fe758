import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/book_provider.dart';
import '../widgets/main_layout.dart';
import '../models/book.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.books;

    return MainLayout(
      title: 'Book Management',
      selectedIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Books',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add-book');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Book'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Author')),
                        DataColumn(label: Text('Genre')),
                        DataColumn(label: Text('ISBN')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: books.map((book) {
                        return DataRow(cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[200],
                                  child: Text(book.title[0], style: const TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    book.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(book.author)),
                          DataCell(Text(book.genre)),
                          DataCell(Text(book.isbn)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(book.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _getStatusColor(book.status)),
                              ),
                              child: Text(
                                book.status,
                                style: TextStyle(
                                  color: _getStatusColor(book.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/edit-book', arguments: book.id);
                                  },
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, bookProvider, book),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Borrowed':
        return Colors.orange;
      case 'Lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context, BookProvider provider, Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteBook(book.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
