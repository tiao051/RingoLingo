import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/home_page.dart'; 
import 'screens/login.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/tracnghiem_screen.dart';
import 'screens/quiz_screen_tho.dart';
import 'screens/hoSo.dart';
import 'screens/caidat.dart';
import 'dart:html' as html;

void main() {
  printCurrentUrl();
  runApp(const RingoLingoApp());
}
void printCurrentUrl() {
  print('Current URL: ${html.window.location.href}');
  print('Protocol: ${html.window.location.protocol}'); // http: hoặc https:
  print('Host: ${html.window.location.host}');
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
        '/quiz': (context) => QuizScreen(),
        '/hoSo': (context) => HoSo(),
        '/caidat': (context) => caidat(),
      },
    );
  }
}