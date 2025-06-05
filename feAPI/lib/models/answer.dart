class Answer {
  final int id;
  final int questionId;
  final String answerText;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['questionId'],
      answerText: json['answerText'],
      isCorrect: json['isCorrect'],
    );
  }
}
