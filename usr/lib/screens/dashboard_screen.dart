import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/main_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return MainLayout(
      title: 'Dashboard',
      selectedIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isSmall = width < 600;
                
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard(
                      context,
                      'Total Books',
                      bookProvider.totalBooks.toString(),
                      Icons.book,
                      Colors.blue,
                      isSmall ? width : (width - 32) / 3,
                    ),
                    _buildStatCard(
                      context,
                      'Available',
                      bookProvider.availableBooks.toString(),
                      Icons.check_circle,
                      Colors.green,
                      isSmall ? width : (width - 32) / 3,
                    ),
                    _buildStatCard(
                      context,
                      'Borrowed',
                      bookProvider.borrowedBooks.toString(),
                      Icons.people,
                      Colors.orange,
                      isSmall ? width : (width - 32) / 3,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'Recent Additions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookProvider.recentBooks.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final book = bookProvider.recentBooks[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(book.title[0]),
                    ),
                    title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(book.author),
                    trailing: Chip(
                      label: Text(
                        book.status,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(book.status),
                      padding: EdgeInsets.zero,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color, double width) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 40, color: color),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
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
}
