import 'package:ringolingo_app/models/question.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
Future<List<Question>> fetchQuestions(int lessonId) async {
  final url = Uri.parse('https://localhost:7093/api/question/question-for-listen/$lessonId');

  final response = await http.get(url);

  print('Raw API response body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Question.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}