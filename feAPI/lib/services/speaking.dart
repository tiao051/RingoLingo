import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/lesson.dart';

List<Lesson> getFakeSpeakingLessons() {
  return [
    Lesson(
      id: 5,
      title: 'Pronunciation Practice - Animals',
      categoryId: 1,
      description: 'Practice pronouncing animal names correctly with voice recognition feedback and pronunciation tips.',
    ),
    Lesson(
      id: 6,
      title: 'Food & Drink Conversation',
      categoryId: 2,
      description: 'Learn to order food, describe tastes, and talk about your favorite meals in natural conversations.',
    ),
    Lesson(
      id: 7,
      title: 'Travel Vocabulary Speaking',
      categoryId: 3,
      description: 'Practice speaking about travel experiences, asking for directions, and booking accommodations.',
    ),
  ];
}

final Map<int, IconData> speakingLessonIcons = {
  5: Icons.pets_outlined,
  6: Icons.restaurant_menu_rounded,
  7: Icons.flight_takeoff_rounded,
};

IconData? getSpeakingLessonIcon(int lessonId) {
  return speakingLessonIcons[lessonId] ?? Icons.mic_rounded;
}

String getSpeakingDifficulty(int lessonId) {
  switch (lessonId) {
    case 5:
      return 'Cơ bản';
    case 6:
      return 'Trung bình';
    case 7:
      return 'Nâng cao';
    default:
      return 'Cơ bản';
  }
}

String getSpeakingDuration(int lessonId) {
  switch (lessonId) {
    case 5:
      return '10-15 phút';
    case 6:
      return '15-20 phút';
    case 7:
      return '20-25 phút';
    default:
      return '10-15 phút';
  }
}
