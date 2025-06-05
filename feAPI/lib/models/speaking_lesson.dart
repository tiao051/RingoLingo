import 'package:ringolingo_app/models/speaking_question.dart';

class SpeakingLesson {
  final int id;
  final String title;
  final List<SpeakingQuestion> questions;
  final int categoryId;
  final String difficulty;
  final String duration;

  SpeakingLesson({
    required this.id,
    required this.title,
    required this.questions,
    required this.categoryId,
    required this.difficulty,
    required this.duration,
  });
}