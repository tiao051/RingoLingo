import 'package:ringolingo_app/models/question.dart';
import 'package:ringolingo_app/models/answer.dart';
import 'package:ringolingo_app/models/speaking_question.dart';

List<SpeakingQuestion> convertToSpeakingQuestions(List<Question> questions) {
  return questions.map((q) {
    // Tìm câu trả lời đúng đầu tiên (nếu có)
    final correctAnswer = q.answers.firstWhere(
      (a) => a.isCorrect == true,
      orElse: () => Answer(
        id: -1,
        questionId: q.id,
        answerText: '',
        isCorrect: false,
      ),
    );

    return SpeakingQuestion(
      id: q.id,
      prompt: q.questionText,
      sampleAnswer: correctAnswer.answerText.isNotEmpty ? correctAnswer.answerText : null,
      keywords: correctAnswer.answerText.isNotEmpty
          ? [correctAnswer.answerText]
          : [],
      audioPrompt: null, // Có thể thêm xử lý nếu có audio
    );
  }).toList();
}
