import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ringolingo_app/models/category.dart';

Future<List<Category>> fetchLessons() async {
  final response = await http.get(Uri.parse('https://localhost:7093/api/category'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Category');
  }
}
