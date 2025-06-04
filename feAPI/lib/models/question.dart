import 'answer.dart';

class Question {
  final int id;
  final String questionText;
  final String typeName;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    required this.typeName,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      typeName: json['typeName'],
      answers: (json['answersText'] as List)
          .map((item) => Answer.fromJson(item))
          .toList(),
    );
  }
}
