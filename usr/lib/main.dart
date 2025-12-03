import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/book_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/book_list_screen.dart';
import 'screens/book_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'Book Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const DashboardScreen(),
          '/books': (context) => const BookListScreen(),
          '/add-book': (context) => const BookFormScreen(),
          '/edit-book': (context) => const BookFormScreen(),
        },
      ),
    );
  }
}
