class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? vietnamese;
  final String? english;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.vietnamese,
    this.english,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic> answers = json['answersText'];
    List<String> options = answers.map((e) => e['answerText'] as String).toList();
    int correctIndex = answers.indexWhere((e) => e['isCorrect'] == true);

    return QuizQuestion(
      question: json['questionText'],
      options: options,
      correctAnswer: correctIndex,
      vietnamese: null, // Có thể custom nếu có thêm field
      english: null,
    );
  }
}
