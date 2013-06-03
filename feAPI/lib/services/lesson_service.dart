import 'package:ringolingo_app/models/lesson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Lesson>> fetchLessons() async {
  final response = await http.get(Uri.parse('https://localhost:7093/api/lesson/lessons'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Lesson.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load lessons');
  }
}
