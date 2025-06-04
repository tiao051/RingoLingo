import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/home_page.dart'; 
import 'screens/login.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/tracnghiem_screen.dart';

void main() {
  runApp(const RingoLingoApp());
}

class RingoLingoApp extends StatelessWidget {
  const RingoLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RingoLingo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Inter', 
      ),
      home: VocabularyScreen(),
      debugShowCheckedModeBanner: false,      routes: {
        '/home': (context) => const HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => const LoginScreen(),
        '/home_word': (context) => VocabularyScreen(),
        '/tracnghiem': (context) => TracNghiemScreen(),
      },
    );
  }
}