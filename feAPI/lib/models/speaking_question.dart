class SpeakingQuestion {
  final int id;
  final String prompt;
  final String? sampleAnswer;
  final String? audioPrompt;
  final List<String>? keywords;

  SpeakingQuestion({
    required this.id,
    required this.prompt,
    this.sampleAnswer,
    this.audioPrompt,
    this.keywords,
  });
}