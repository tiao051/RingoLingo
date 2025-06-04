import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ringolingo_app/models/vocabulary.dart';
import 'package:ringolingo_app/models/lesson.dart';


Future<List<Lesson>> fetchLessonsByCategory(int categoryId) async {
  print('DEBUG: Fetching lessons for categoryId = $categoryId');
  final response = await http.get(
    Uri.parse('https://localhost:7093/api/lesson/lessons/$categoryId'),
  );
  print('DEBUG: Response status = ${response.statusCode}');
  print('DEBUG: Response body = ${response.body}');

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body);

    // API trả về object duy nhất
    if (data is Map<String, dynamic>) {
      return [Lesson.fromJson(data)];
    } else if (data is List) {
      return data.map<Lesson>((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('Failed to load lessons for category $categoryId');
  }
}

// Hardcode data for testing flashcard
Future<List<Vocabulary>> fetchVocabulariesByLessonId(int lessonId) async {
  // Simulate API delay
  await Future.delayed(Duration(milliseconds: 500));

  // Return hardcoded animal vocabulary data
  return [
    Vocabulary(
      id: 1,
      lessonId: lessonId,
      englishWord: 'Cat',
      vietnameseMeaning: 'Con mèo',
      pronunciation: '/kæt/',
      imagePath: 'assets/images/dong_vat/cat.png',
      audioPath: 'assets/audio/cat.mp3',
      orderNum: 1,
      exampleSentence: 'The cat is sleeping on the mat.',
    ),
    Vocabulary(
      id: 2,
      lessonId: lessonId,
      englishWord: 'Dog',
      vietnameseMeaning: 'Con chó',
      pronunciation: '/dɔːg/',
      imagePath: 'assets/images/dong_vat/dog.png',
      audioPath: 'assets/audio/dog.mp3',
      orderNum: 2,
      exampleSentence: 'The dog barks at the mailman.',
    ),
    Vocabulary(
      id: 3,
      lessonId: lessonId,
      englishWord: 'Elephant',
      vietnameseMeaning: 'Con voi',
      pronunciation: '/ˈɛlɪfənt/',
      imagePath: 'assets/images/dong_vat/elephant.png',
      audioPath: 'assets/audio/elephant.mp3',
      orderNum: 3,
      exampleSentence: 'An elephant is a very large animal.',
    ),
    Vocabulary(
      id: 4,
      lessonId: lessonId,
      englishWord: 'Lion',
      vietnameseMeaning: 'Con sư tử',
      pronunciation: '/ˈlaɪən/',
      imagePath: 'assets/images/dong_vat/lion.png',
      audioPath: 'assets/audio/lion.mp3',
      orderNum: 4,
      exampleSentence: 'The lion is the king of the jungle.',
    ),
    Vocabulary(
      id: 5,
      lessonId: lessonId,
      englishWord: 'Tiger',
      vietnameseMeaning: 'Con hổ',
      pronunciation: '/ˈtaɪgər/',
      imagePath: 'assets/images/dong_vat/tiger.png',
      audioPath: 'assets/audio/tiger.mp3',
      orderNum: 5,
      exampleSentence: 'A tiger has stripes.',
    ),
    Vocabulary(
      id: 6,
      lessonId: lessonId,
      englishWord: 'Monkey',
      vietnameseMeaning: 'Con khỉ',
      pronunciation: '/ˈmʌŋki/',
      imagePath: 'assets/images/dong_vat/monkey.png',
      audioPath: 'assets/audio/monkey.mp3',
      orderNum: 6,
      exampleSentence: 'Monkeys love to eat bananas.',
    ),
    Vocabulary(
      id: 7,
      lessonId: lessonId,
      englishWord: 'Rabbit',
      vietnameseMeaning: 'Con thỏ',
      pronunciation: '/ˈræbɪt/',
      imagePath: 'assets/images/dong_vat/rabbit.png',
      audioPath: 'assets/audio/rabbit.mp3',
      orderNum: 7,
      exampleSentence: 'The rabbit has long ears.',
    ),
    Vocabulary(
      id: 8,
      lessonId: lessonId,
      englishWord: 'Cow',
      vietnameseMeaning: 'Con bò',
      pronunciation: '/kaʊ/',
      imagePath: 'assets/images/dong_vat/cow.png',
      audioPath: 'assets/audio/cow.mp3',
      orderNum: 8,
      exampleSentence: 'A cow gives us milk.',
    ),
    Vocabulary(
      id: 9,
      lessonId: lessonId,
      englishWord: 'Sheep',
      vietnameseMeaning: 'Con cừu',
      pronunciation: '/ʃiːp/',
      imagePath: 'assets/images/dong_vat/sheep.png',
      audioPath: 'assets/audio/sheep.mp3',
      orderNum: 9,
      exampleSentence: 'Sheep are covered in wool.',
    ),
    Vocabulary(
      id: 10,
      lessonId: lessonId,
      englishWord: 'Wolf',
      vietnameseMeaning: 'Con sói',
      pronunciation: '/wʊlf/',
      imagePath: 'assets/images/dong_vat/wolf.png',
      audioPath: 'assets/audio/wolf.mp3',
      orderNum: 10,
      exampleSentence: 'A wolf howls at the moon.',
    ),
  ];
}