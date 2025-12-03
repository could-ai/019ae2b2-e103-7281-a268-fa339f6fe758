import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String _title = '';
  String _author = '';
  String _isbn = '';
  String _genre = '';
  String _status = 'Available';
  DateTime _publicationDate = DateTime.now();

  bool _isInit = true;
  String? _bookId;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bookId = ModalRoute.of(context)?.settings.arguments as String?;
      if (bookId != null) {
        _bookId = bookId;
        final book = Provider.of<BookProvider>(context, listen: false)
            .books
            .firstWhere((b) => b.id == bookId);
        
        _title = book.title;
        _author = book.author;
        _isbn = book.isbn;
        _genre = book.genre;
        _status = book.status;
        _publicationDate = book.publicationDate;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<BookProvider>(context, listen: false);
      
      if (_bookId != null) {
        // Update existing
        final updatedBook = Book(
          id: _bookId!,
          title: _title,
          author: _author,
          isbn: _isbn,
          genre: _genre,
          publicationDate: _publicationDate,
          status: _status,
        );
        provider.updateBook(_bookId!, updatedBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book updated successfully')),
        );
      } else {
        // Add new
        final newBook = Book(
          id: DateTime.now().toString(),
          title: _title,
          author: _author,
          isbn: _isbn,
          genre: _genre,
          publicationDate: _publicationDate,
          status: _status,
        );
        provider.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully')),
        );
      }
      
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publicationDate,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _publicationDate) {
      setState(() {
        _publicationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_bookId != null ? 'Edit Book' : 'Add New Book'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _author,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                  onSaved: (value) => _author = value!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _isbn,
                        decoration: const InputDecoration(
                          labelText: 'ISBN',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.qr_code),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ISBN';
                          }
                          return null;
                        },
                        onSaved: (value) => _isbn = value!,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _genre,
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a genre';
                          }
                          return null;
                        },
                        onSaved: (value) => _genre = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Publication Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat.yMMMd().format(_publicationDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        items: ['Available', 'Borrowed', 'Lost']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                        onSaved: (value) => _status = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _bookId != null ? 'Update Book' : 'Add Book',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
