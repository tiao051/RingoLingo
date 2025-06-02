import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/home_page.dart'; // Import the new home_page.dart
import 'screens/login.dart';
import 'screens/hocTuVung.dart'; // Import the login screen

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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => const LoginScreen(),
        '/hocTuVung': (context) => const HocTuVungSidebar(),
      },
    );
  }
}