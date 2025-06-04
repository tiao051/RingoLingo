import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';

// Mock quiz data
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String vietnamese;
  final String english;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.vietnamese,
    required this.english,
  });
}

class TracNghiemScreen extends StatefulWidget {
  @override
  _TracNghiemScreenState createState() => _TracNghiemScreenState();
}

class _TracNghiemScreenState extends State<TracNghiemScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  bool quizCompleted = false;
  bool showResult = false;
  
  // Image state management
  String currentImage = 'assets/images/taoSuyNghi.png';
  int consecutiveWrong = 0; // Track consecutive wrong answers
  int consecutiveRight = 0; // Track consecutive right answers
  bool isInDisappointmentMode = false; // Track if in disappointment mode

  final List<QuizQuestion> mockQuestions = [
    QuizQuestion(
      question: "Con mèo tiếng Anh là gì?",
      options: ["Dog", "Cat", "Bird", "Fish"],
      correctAnswer: 1,
      vietnamese: "Con mèo",
      english: "Cat",
    ),
    QuizQuestion(
      question: "Con chó tiếng Anh là gì?",
      options: ["Cat", "Bird", "Dog", "Mouse"],
      correctAnswer: 2,
      vietnamese: "Con chó",
      english: "Dog",
    ),
    QuizQuestion(
      question: "Con chim tiếng Anh là gì?",
      options: ["Fish", "Bird", "Rabbit", "Tiger"],
      correctAnswer: 1,
      vietnamese: "Con chim",
      english: "Bird",
    ),
    QuizQuestion(
      question: "Con cá tiếng Anh là gì?",
      options: ["Elephant", "Lion", "Fish", "Horse"],
      correctAnswer: 2,
      vietnamese: "Con cá",
      english: "Fish",
    ),
    QuizQuestion(
      question: "Con thỏ tiếng Anh là gì?",
      options: ["Rabbit", "Snake", "Frog", "Cow"],
      correctAnswer: 0,
      vietnamese: "Con thỏ",
      english: "Rabbit",
    ),
  ];

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswer = answerIndex;
    });
  }

  void updateImageForNewQuestion() {
    setState(() {
      if (isInDisappointmentMode) {
        currentImage = 'assets/images/taoThatVong.png';
      } else {
        currentImage = 'assets/images/taoSuyNghi.png';
      }
    });
  }

  void updateImageAfterAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        if (consecutiveRight >= 2) {
          currentImage = 'assets/images/taoNgoiSao.png';
        } else {
          currentImage = 'assets/images/taoVuiVe.png';
        }
      } else {
        if (isInDisappointmentMode) {
          currentImage = 'assets/images/taoTucGian.png';
        } else {
          currentImage = 'assets/images/taoHoangHot.png';
        }
      }
    });
  }

  void nextQuestion() {
    if (selectedAnswer == null) return;

    bool isCorrect = selectedAnswer == mockQuestions[currentQuestionIndex].correctAnswer;
    
    if (isCorrect) {
      score++;
      consecutiveRight++;
      consecutiveWrong = 0;
      isInDisappointmentMode = false; // Reset disappointment mode when answering correctly
    } else {
      consecutiveWrong++;
      consecutiveRight = 0;
      
      // Enter disappointment mode after 2 consecutive wrong answers
      if (consecutiveWrong >= 2) {
        isInDisappointmentMode = true;
      }
    }

    setState(() {
      if (currentQuestionIndex < mockQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
        updateImageForNewQuestion(); // Update image for the new question
      } else {
        quizCompleted = true;
      }
    });
  }

  void showAnswer() {
    bool isCorrect = selectedAnswer == mockQuestions[currentQuestionIndex].correctAnswer;
    updateImageAfterAnswer(isCorrect);
    
    setState(() {
      showResult = true;
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswer = null;
      score = 0;
      quizCompleted = false;
      showResult = false;
      // Reset image tracking variables
      consecutiveWrong = 0;
      consecutiveRight = 0;
      isInDisappointmentMode = false;
      currentImage = 'assets/images/taoSuyNghi.png';
    });
  }

  String getImageStateText() {
    if (isInDisappointmentMode && !showResult) {
      return 'Thất vọng';
    } else if (showResult) {
      bool isCorrect = selectedAnswer == mockQuestions[currentQuestionIndex].correctAnswer;
      if (isCorrect) {
        if (consecutiveRight >= 2) {
          return 'Ngôi sao!';
        } else {
          return 'Vui vẻ!';
        }
      } else {
        if (isInDisappointmentMode) {
          return 'Tức giận';
        } else {
          return 'Hoang hốt';
        }
      }
    } else {
      return 'Suy nghĩ...';
    }
  }

  Widget buildQuizContent() {
    if (quizCompleted) {
      return buildResultScreen();
    }

    final question = mockQuestions[currentQuestionIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Progress bar
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.brownNormal),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.brownLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (currentQuestionIndex + 1) / mockQuestions.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.greenDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Question counter
        Text(
          'Câu ${currentQuestionIndex + 1}/${mockQuestions.length}',
          style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
        ),
        
        const SizedBox(height: 30),
        
        // Main content: Image and Quiz side by side
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.brownNormal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left side - Character Image
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.brownLight,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColors.brownNormal, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.asset(
                              currentImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.brownLight,
                                  child: Icon(
                                    Icons.emoji_emotions,
                                    size: 60,
                                    color: AppColors.brownDark,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          getImageStateText(),
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.brownDark,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 30),
                
                // Right side - Quiz content
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        question.question,
                        style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Answer options
                      ...question.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;
                        bool isSelected = selectedAnswer == index;
                        bool isCorrect = index == question.correctAnswer;
                        
                        Color backgroundColor = AppColors.white;
                        Color borderColor = AppColors.brownNormal;
                        
                        if (showResult) {
                          if (isCorrect) {
                            backgroundColor = AppColors.greenDark;
                            borderColor = AppColors.greenDark;
                          } else if (isSelected && !isCorrect) {
                            backgroundColor = AppColors.redLight;
                            borderColor = AppColors.redNormal;
                          }
                        } else if (isSelected) {
                          backgroundColor = AppColors.brownLight;
                          borderColor = AppColors.brownDark;
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: showResult ? null : () => selectAnswer(index),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor, width: 2),
                              ),
                              child: Text(
                                option,
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: showResult && isCorrect ? AppColors.white : AppColors.brownDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      
                      const SizedBox(height: 30),
                      
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!showResult && selectedAnswer != null)
                            ElevatedButton(
                              onPressed: showAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brownDark,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Xem đáp án', style: AppTextStyles.bodyBold),
                            ),
                          
                          if (showResult) ...[
                            ElevatedButton(
                              onPressed: nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greenDark,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                currentQuestionIndex < mockQuestions.length - 1 ? 'Câu tiếp theo' : 'Hoàn thành',
                                style: AppTextStyles.bodyBold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResultScreen() {
    double percentage = (score / mockQuestions.length) * 100;
    String grade = '';
    Color gradeColor = AppColors.redNormal;
    String resultImage = 'assets/images/taoVuiVe.png';
    
    if (percentage >= 80) {
      grade = 'Xuất sắc!';
      gradeColor = AppColors.greenDark;
      resultImage = 'assets/images/taoNgoiSao.png';
    } else if (percentage >= 60) {
      grade = 'Khá tốt!';
      gradeColor = AppColors.brownDark;
      resultImage = 'assets/images/taoVuiVe.png';
    } else if (percentage >= 40) {
      grade = 'Cần cố gắng thêm!';
      gradeColor = AppColors.brownNormal;
      resultImage = 'assets/images/taoSuyNghi.png';
    } else {
      grade = 'Hãy luyện tập thêm!';
      gradeColor = AppColors.redNormal;
      resultImage = 'assets/images/taoThatVong.png';
    }
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.brownNormal, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result character image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.brownLight,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.brownNormal, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  resultImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      percentage >= 60 ? Icons.celebration : Icons.refresh,
                      size: 60,
                      color: gradeColor,
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Kết quả bài thi',
              style: AppTextStyles.head1Bold.copyWith(color: AppColors.brownDark),
            ),
            
            const SizedBox(height: 30),
            
            Text(
              '$score/${mockQuestions.length}',
              style: AppTextStyles.head1Bold.copyWith(
                fontSize: 48,
                color: gradeColor,
              ),
            ),
            
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: AppTextStyles.head2Bold.copyWith(color: gradeColor),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              grade,
              style: AppTextStyles.head2Bold.copyWith(color: gradeColor),
            ),
            
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Làm lại', style: AppTextStyles.bodyBold),
                ),
                
                const SizedBox(width: 20),
                
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Quay về', style: AppTextStyles.bodyBold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD5B893),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.brownDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Trắc nghiệm Từ vựng',
          style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: buildQuizContent(),
      ),
    );
  }
}
