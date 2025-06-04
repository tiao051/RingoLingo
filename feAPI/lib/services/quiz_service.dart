import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ringolingo_app/models/quiz.dart';

Future<List<Quiz>> fetchQuizzesByCategory(int categoryId) async {
  // Simulate API delay
  await Future.delayed(Duration(milliseconds: 800));

  // Mock quiz data based on categories
  switch (categoryId) {
    case 1: // Animals category
      return _getAnimalQuizzes();
    case 2: // Food category
      return _getFoodQuizzes();
    case 3: // Colors category
      return _getColorQuizzes();
    default:
      return _getGeneralQuizzes();
  }
}

List<Quiz> _getAnimalQuizzes() {
  return [
    Quiz(
      id: 1,
      categoryId: 1,
      title: "Động vật - Câu 1",
      question: "Từ tiếng Anh nào có nghĩa là 'con mèo'?",
      options: ["Dog", "Cat", "Bird", "Fish"],
      correctAnswerIndex: 1,
      explanation: "Cat có nghĩa là con mèo trong tiếng Việt.",
      difficulty: "easy",
    ),
    Quiz(
      id: 2,
      categoryId: 1,
      title: "Động vật - Câu 2",
      question: "Con vật nào có thể bay?",
      options: ["Elephant", "Tiger", "Bird", "Rabbit"],
      correctAnswerIndex: 2,
      explanation: "Bird (chim) là loài động vật có thể bay.",
      difficulty: "easy",
    ),
    Quiz(
      id: 3,
      categoryId: 1,
      title: "Động vật - Câu 3",
      question: "'Monkey' trong tiếng Việt có nghĩa là gì?",
      options: ["Con chó", "Con mèo", "Con khỉ", "Con gà"],
      correctAnswerIndex: 2,
      explanation: "Monkey có nghĩa là con khỉ.",
      difficulty: "medium",
    ),
    Quiz(
      id: 4,
      categoryId: 1,
      title: "Động vật - Câu 4",
      question: "Con vật nào là vua của rừng xanh?",
      options: ["Tiger", "Lion", "Elephant", "Bear"],
      correctAnswerIndex: 1,
      explanation: "Lion (sư tử) được gọi là vua của rừng xanh.",
      difficulty: "medium",
    ),
    Quiz(
      id: 5,
      categoryId: 1,
      title: "Động vật - Câu 5",
      question: "Con vật nào có vòi dài?",
      options: ["Horse", "Cow", "Elephant", "Pig"],
      correctAnswerIndex: 2,
      explanation: "Elephant (voi) là con vật có vòi dài.",
      difficulty: "easy",
    ),
  ];
}

List<Quiz> _getFoodQuizzes() {
  return [
    Quiz(
      id: 6,
      categoryId: 2,
      title: "Thức ăn - Câu 1",
      question: "'Apple' trong tiếng Việt có nghĩa là gì?",
      options: ["Quả cam", "Quả táo", "Quả chuối", "Quả nho"],
      correctAnswerIndex: 1,
      explanation: "Apple có nghĩa là quả táo.",
      difficulty: "easy",
    ),
    Quiz(
      id: 7,
      categoryId: 2,
      title: "Thức ăn - Câu 2",
      question: "Từ nào chỉ đồ uống làm từ sữa bò?",
      options: ["Water", "Juice", "Milk", "Tea"],
      correctAnswerIndex: 2,
      explanation: "Milk (sữa) là đồ uống làm từ sữa bò.",
      difficulty: "easy",
    ),
    Quiz(
      id: 8,
      categoryId: 2,
      title: "Thức ăn - Câu 3",
      question: "Món ăn nào được làm từ bột mì?",
      options: ["Rice", "Bread", "Fish", "Meat"],
      correctAnswerIndex: 1,
      explanation: "Bread (bánh mì) được làm từ bột mì.",
      difficulty: "medium",
    ),
    Quiz(
      id: 9,
      categoryId: 2,
      title: "Thức ăn - Câu 4",
      question: "'Banana' có nghĩa là gì?",
      options: ["Quả táo", "Quả cam", "Quả chuối", "Quả dứa"],
      correctAnswerIndex: 2,
      explanation: "Banana có nghĩa là quả chuối.",
      difficulty: "easy",
    ),
    Quiz(
      id: 10,
      categoryId: 2,
      title: "Thức ăn - Câu 5",
      question: "Loại thịt nào có màu trắng khi nấu chín?",
      options: ["Beef", "Chicken", "Pork", "Lamb"],
      correctAnswerIndex: 1,
      explanation: "Chicken (thịt gà) có màu trắng khi nấu chín.",
      difficulty: "medium",
    ),
  ];
}

List<Quiz> _getColorQuizzes() {
  return [
    Quiz(
      id: 11,
      categoryId: 3,
      title: "Màu sắc - Câu 1",
      question: "Màu của máu là gì?",
      options: ["Blue", "Green", "Red", "Yellow"],
      correctAnswerIndex: 2,
      explanation: "Red (màu đỏ) là màu của máu.",
      difficulty: "easy",
    ),
    Quiz(
      id: 12,
      categoryId: 3,
      title: "Màu sắc - Câu 2",
      question: "'White' có nghĩa là màu gì?",
      options: ["Đen", "Trắng", "Xanh", "Vàng"],
      correctAnswerIndex: 1,
      explanation: "White có nghĩa là màu trắng.",
      difficulty: "easy",
    ),
    Quiz(
      id: 13,
      categoryId: 3,
      title: "Màu sắc - Câu 3",
      question: "Màu của bầu trời trong ngày đẹp trời?",
      options: ["Red", "Green", "Blue", "Purple"],
      correctAnswerIndex: 2,
      explanation: "Blue (màu xanh da trời) là màu của bầu trời trong ngày đẹp trời.",
      difficulty: "easy",
    ),
    Quiz(
      id: 14,
      categoryId: 3,
      title: "Màu sắc - Câu 4",
      question: "Trộn màu đỏ và vàng sẽ được màu gì?",
      options: ["Orange", "Purple", "Green", "Pink"],
      correctAnswerIndex: 0,
      explanation: "Trộn Red và Yellow sẽ được Orange (màu cam).",
      difficulty: "medium",
    ),
    Quiz(
      id: 15,
      categoryId: 3,
      title: "Màu sắc - Câu 5",
      question: "'Black' trong tiếng Việt có nghĩa là gì?",
      options: ["Trắng", "Xám", "Đen", "Nâu"],
      correctAnswerIndex: 2,
      explanation: "Black có nghĩa là màu đen.",
      difficulty: "easy",
    ),
  ];
}

List<Quiz> _getGeneralQuizzes() {
  return [
    Quiz(
      id: 16,
      categoryId: 0,
      title: "Tổng hợp - Câu 1",
      question: "Từ nào có nghĩa là 'xin chào'?",
      options: ["Goodbye", "Hello", "Thank you", "Please"],
      correctAnswerIndex: 1,
      explanation: "Hello có nghĩa là xin chào.",
      difficulty: "easy",
    ),
    Quiz(
      id: 17,
      categoryId: 0,
      title: "Tổng hợp - Câu 2",
      question: "'Good morning' có nghĩa là gì?",
      options: ["Chúc ngủ ngon", "Chào buổi sáng", "Chào buổi tối", "Tạm biệt"],
      correctAnswerIndex: 1,
      explanation: "Good morning có nghĩa là chào buổi sáng.",
      difficulty: "easy",
    ),
    Quiz(
      id: 18,
      categoryId: 0,
      title: "Tổng hợp - Câu 3",
      question: "Từ nào có nghĩa là 'cảm ơn'?",
      options: ["Please", "Sorry", "Thank you", "Excuse me"],
      correctAnswerIndex: 2,
      explanation: "Thank you có nghĩa là cảm ơn.",
      difficulty: "easy",
    ),
  ];
}
