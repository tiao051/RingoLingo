class Quiz {
  final int id;
  final int categoryId;
  final String title;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty; // 'easy', 'medium', 'hard'

  Quiz({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      title: json['title'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correct_answer_index'] ?? 0,
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'question': question,
      'options': options,
      'correct_answer_index': correctAnswerIndex,
      'explanation': explanation,
      'difficulty': difficulty,
    };
  }
}
