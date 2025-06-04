import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String typeName;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.typeName,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic> answers = json['answersText'];
    List<String> options =
        answers.map((e) => e['answerText'] as String).toList();
    int correctIndex = answers.indexWhere((e) => e['isCorrect'] == true);

    return QuizQuestion(
      id: json['id'],
      question: json['questionText'],
      options: options,
      correctAnswer: correctIndex,
      typeName: json['typeName'],
    );
  }
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
  int consecutiveWrong = 0;
  int consecutiveRight = 0;
  bool isInDisappointmentMode = false;

  // API data
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  bool isError = false;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://localhost:7093/api/question/question-by-lesson/2'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        questions = data.map((e) => QuizQuestion.fromJson(e)).toList();
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

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

    bool isCorrect =
        selectedAnswer == questions[currentQuestionIndex].correctAnswer;

    if (isCorrect) {
      score++;
      consecutiveRight++;
      consecutiveWrong = 0;
      isInDisappointmentMode = false;
    } else {
      consecutiveWrong++;
      consecutiveRight = 0;

      if (consecutiveWrong >= 2) {
        isInDisappointmentMode = true;
      }
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
        updateImageForNewQuestion();
      } else {
        quizCompleted = true;
      }
    });
  }

  void showAnswer() {
    bool isCorrect =
        selectedAnswer == questions[currentQuestionIndex].correctAnswer;
    updateImageAfterAnswer(isCorrect);

    // Play audio feedback based on answer correctness
    if (isCorrect) {
      playAudio('correct.mp3');
    } else {
      playAudio('wrong.mp3');
    }

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
      consecutiveWrong = 0;
      consecutiveRight = 0;
      isInDisappointmentMode = false;
      currentImage = 'assets/images/taoSuyNghi.png';
    });
  }

  Future<void> playAudio(String fileName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/$fileName'));
      setState(() {
        isPlaying = true;
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlaying = false;
        });
      });
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Widget buildQuizContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Lỗi khi tải câu hỏi'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchQuestions,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (questions.isEmpty) {
      return const Center(child: Text('Không có câu hỏi'));
    }

    if (quizCompleted) {
      return buildResultScreen();
    }

    final question = questions[currentQuestionIndex];

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
                widthFactor: (currentQuestionIndex + 1) / questions.length,
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
          'Câu ${currentQuestionIndex + 1}/${questions.length}',
          style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
        ),
        const SizedBox(height: 30),

        // Main content: Image and Quiz side by side
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Character Image (outside white container)
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 600,
                    height: 600,
                    child: Image.asset(
                      currentImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.brownLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.emoji_emotions,
                            size: 120,
                            color: AppColors.brownDark,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Right side - Quiz content in white container
              Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          question.question,
                          style: AppTextStyles.head2Bold
                              .copyWith(color: AppColors.brownDark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (currentQuestionIndex == 3 ||
                            currentQuestionIndex == 4)
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: isPlaying
                                    ? null
                                    : () {
                                        if (currentQuestionIndex == 3) {
                                          playAudio('lion_roar.mp3');
                                        } else if (currentQuestionIndex == 4) {
                                          playAudio('lion.mp3');
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brownNormal,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPlaying ? Icons.pause : Icons.volume_up,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isPlaying
                                          ? 'Đang phát...'
                                          : 'Nghe âm thanh',
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
                              onTap:
                                  showResult ? null : () => selectAnswer(index),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: borderColor, width: 2),
                                ),
                                child: Text(
                                  option,
                                  style: AppTextStyles.bodyBold.copyWith(
                                    color: showResult && isCorrect
                                        ? AppColors.white
                                        : AppColors.brownDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!showResult && selectedAnswer != null)
                              ElevatedButton(
                                onPressed: showAnswer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brownDark,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('Xem đáp án',
                                    style: AppTextStyles.bodyBold),
                              ),
                            if (showResult)
                              ElevatedButton(
                                onPressed: nextQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.greenDark,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  currentQuestionIndex < questions.length - 1
                                      ? 'Câu tiếp theo'
                                      : 'Hoàn thành',
                                  style: AppTextStyles.bodyBold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildResultScreen() {
    double percentage = (score / questions.length) * 100;
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Result character image (600px, not wrapped in container)
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              width: 600,
              height: 600,
              child: Image.asset(
                resultImage,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    percentage >= 60 ? Icons.celebration : Icons.refresh,
                    size: 300,
                    color: gradeColor,
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Right side - Result content in white container
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kết quả bài thi',
                  style: AppTextStyles.head1Bold
                      .copyWith(color: AppColors.brownDark),
                ),
                const SizedBox(height: 30),
                Text(
                  '$score/${questions.length}',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
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
        ),
      ],
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
