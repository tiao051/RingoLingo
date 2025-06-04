class Vocabulary {
  final int id;
  final int lessonId;
  final String englishWord;
  final String vietnameseMeaning;
  final String pronunciation;
  final String imagePath;
  final String audioPath;
  final int orderNum;
  final String exampleSentence;
   // Optional field for example sentence
  Vocabulary({
    required this.id,
    required this.lessonId,
    required this.englishWord,
    required this.vietnameseMeaning,
    required this.pronunciation,
    required this.imagePath,
    required this.audioPath,
    required this.orderNum,
    required this.exampleSentence,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'] ?? 0,
      lessonId: json['lesson_id'] ?? 0,
      englishWord: json['english_word'] ?? '',
      vietnameseMeaning: json['vietnamese_meaning'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      imagePath: json['image_path'] ?? '',
      audioPath: json['audio_path'] ?? '',
      orderNum: json['order_num'] ?? 0,
      exampleSentence: json['example_sentence'] as String? ?? 'No example available.',
    );
  }
}