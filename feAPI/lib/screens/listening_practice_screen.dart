import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/models/question.dart';
import 'package:audioplayers/audioplayers.dart';

// Placeholder for a lesson model, replace with your actual model
class ListeningLesson {
  final int id;
  final String title;
  final String audioUrl;
  final List<ListeningQuestion> questions;
  final String transcript;
  final int categoryId;

  ListeningLesson({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.questions,
    required this.transcript,
    required this.categoryId,
  });
}

// Placeholder for a question model
class ListeningQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  String? userAnswer;

  ListeningQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.userAnswer,
  });
}

List<ListeningQuestion> convertToListeningQuestions(List<Question> questions) {
  return questions.map((q) {
    final options = q.answers.map((a) => a.answerText).toList();
    final correctIndex = q.answers.indexWhere((a) => a.isCorrect);

    return ListeningQuestion(
      id: q.id.toString(),
      questionText: q.questionText,
      options: options,
      correctAnswerIndex: correctIndex,
    );
  }).toList();
}

class ListeningPracticeScreen extends StatefulWidget {
  final ListeningLesson lis_lesson;

  const ListeningPracticeScreen({Key? key, required this.lis_lesson}) : super(key: key);

  @override
  _ListeningPracticeScreenState createState() => _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends State<ListeningPracticeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _showTranscript = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.stop();
      String path = widget.lis_lesson.audioUrl;
      if (path.startsWith('assets/')) {
        path = path.substring('assets/'.length);
      }
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
  void _handleSubmit() {
    // Kiểm tra xem đã trả lời hết câu hỏi chưa
    bool hasUnansweredQuestions = widget.lis_lesson.questions.any((question) => 
      question.userAnswer == null || question.userAnswer!.isEmpty
    );

    if (hasUnansweredQuestions) {
      _showIncompleteDialog();
    } else {
      // Tính điểm và hiển thị kết quả
      _calculateAndShowResults();
    }
  }

  void _calculateAndShowResults() {
    int correctAnswers = 0;
    int totalQuestions = widget.lis_lesson.questions.length;

    // Tính số câu đúng
    for (var question in widget.lis_lesson.questions) {
      if (question.userAnswer != null) {
        String correctAnswer = question.options[question.correctAnswerIndex];
        if (question.userAnswer == correctAnswer) {
          correctAnswers++;
        }
      }
    }

    // Tính phần trăm
    double percentage = (correctAnswers / totalQuestions) * 100;
    
    _showResultDialog(correctAnswers, totalQuestions, percentage);
  }  String _getResultImage(double percentage) {
    if (percentage <= 20) {
      return 'images/taoThatVong.png';
    } else if (percentage <= 40) {
      return 'images/taoTucGian.png';
    } else if (percentage <= 60) {
      return 'images/tao_happy.png';
    } else if (percentage <= 80) {
      return 'images/taoVuiVe.png';
    } else {
      return 'images/taoNgoiSao.png';
    }
  }

  String _getRightIcon(String leftIcon) {
    switch (leftIcon) {
      case 'images/taoThatVong.png':
        return 'images/taoChamHoi.png';
      case 'images/taoTucGian.png':
        return 'images/taoHoangHot.png';
      case 'images/tao_happy.png':
        return 'images/taoChill.png';
      case 'images/taoVuiVe.png':
        return 'images/taoSuyNghi.png';
      case 'images/taoNgoiSao.png':
        return 'images/taoHocGioi.png';
      default:
        return 'images/taoChamHoi.png';
    }
  }
  void _showResultDialog(int correctAnswers, int totalQuestions, double percentage) {
    // Phát âm thanh dựa trên kết quả
    bool isPassing = percentage >= 70; // 70% để pass
    String resultImage = _getResultImage(percentage);
    String rightIcon = _getRightIcon(resultImage);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPassing
                    ? [
                        Colors.green.shade50,
                        Colors.green.shade100,
                      ]
                    : [
                        Colors.orange.shade50,
                        Colors.orange.shade100,
                      ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tiêu đề
                Text(
                  isPassing ? 'Chúc mừng!' : 'Hoàn thành bài học',
                  style: AppTextStyles.head2Bold.copyWith(
                    color: isPassing ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // Chia thành 3 phần: Icon trái (20%) - Kết quả (60%) - Icon phải (20%)
                Row(
                  children: [                    // Icon trái (20%)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            resultImage,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.brownLight.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: AppColors.brownDark.withOpacity(0.5),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                      // Phần thông tin kết quả (60%)
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Kết quả chi tiết
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPassing 
                                      ? Colors.green.shade300 
                                      : Colors.orange.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Số câu đúng:',
                                        style: AppTextStyles.bodyBold,
                                      ),
                                      Text(
                                        '$correctAnswers/$totalQuestions',
                                        style: AppTextStyles.bodyBold.copyWith(
                                          color: isPassing ? Colors.green.shade700 : Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tỷ lệ đúng:',
                                        style: AppTextStyles.bodyBold,
                                      ),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: AppTextStyles.bodyBold.copyWith(
                                          color: isPassing ? Colors.green.shade700 : Colors.orange.shade700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Thông điệp
                            Text(
                              isPassing
                                  ? 'Bạn đã hoàn thành xuất sắc bài học này!'
                                  : 'Bạn có thể thử lại để đạt kết quả tốt hơn.',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.brownDark.withOpacity(0.8),
                                height: 1.4,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                              // Các nút hành động
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Nút xem đáp án
                                Expanded(
                                  flex: 4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showDetailedResults();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brownLight,
                                      foregroundColor: AppColors.brownDark,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      'Xem đáp án',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Nút hoàn thành
                                Expanded(
                                  flex: 4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(); // Quay về màn hình trước
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isPassing ? Colors.green.shade600 : Colors.orange.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      'Hoàn thành',
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                      // Icon phải (20%)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            rightIcon,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.brownLight.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: AppColors.brownDark.withOpacity(0.5),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showIncompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white,
                  AppColors.brownLight.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brownLight.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.help_outline,
                    size: 48,
                    color: AppColors.brownDark,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'Chưa hoàn thành!',
                  style: AppTextStyles.head2Bold.copyWith(
                    color: AppColors.brownDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  'Hãy trả lời hết những câu hỏi trước khi hoàn thành bài học.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.brownDark.withOpacity(0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Smaller Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownDark,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      minimumSize: const Size(80, 36),
                    ),
                    child: Text(
                      'Đã hiểu',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                        fontSize: 14,
                      ),                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailedResults() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white,
                  AppColors.brownLight.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chi tiết đáp án',
                      style: AppTextStyles.head2Bold.copyWith(
                        color: AppColors.brownDark,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.brownDark),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Content - Scrollable list of questions
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.lis_lesson.questions.asMap().entries.map((entry) {
                        int index = entry.key;
                        ListeningQuestion question = entry.value;
                        String correctAnswer = question.options[question.correctAnswerIndex];
                        bool isCorrect = question.userAnswer == correctAnswer;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isCorrect 
                                ? Colors.green.shade50 
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCorrect 
                                  ? Colors.green.shade300 
                                  : Colors.red.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question number and status
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isCorrect ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Câu ${index + 1}',
                                      style: AppTextStyles.bodyBold.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isCorrect ? 'Đúng' : 'Sai',
                                    style: AppTextStyles.bodyBold.copyWith(
                                      color: isCorrect ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Question text
                              Text(
                                question.questionText,
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.brownDark,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // User's answer
                              if (question.userAnswer != null) ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bạn chọn: ',
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.brownDark,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        question.userAnswer!,
                                        style: AppTextStyles.body.copyWith(
                                          color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                              
                              // Correct answer
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đáp án đúng: ',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.brownDark,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      correctAnswer,
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.green.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Close button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Đóng',
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return await _showExitConfirmationDialog() ?? false;
  }

  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Xác nhận thoát',
            style: AppTextStyles.head3Bold.copyWith(
              color: AppColors.brownDark,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Bạn có chắc chắn muốn thoát bài làm? Mọi kết quả sẽ không được lưu.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.brownDark.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.brownLight,
                      foregroundColor: AppColors.brownDark,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Hủy',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Thoát',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header cố định: Back button and Title
                    Row(
                      children: [                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppColors.brownDark),
                          onPressed: () async {
                            final shouldExit = await _showExitConfirmationDialog();
                            if (shouldExit == true) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.lis_lesson.title,
                          style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Phần scroll cho tất cả content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Audio Player Section - có thể scroll
                            _buildAudioPlayerControls(),
                            const SizedBox(height: 24),
                            
                            // Transcript Toggle
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: Icon(_showTranscript ? Icons.visibility_off : Icons.visibility, color: AppColors.brownDark),
                                label: Text(_showTranscript ? 'Ẩn Lời thoại' : 'Hiện Lời thoại', style: TextStyle(color: AppColors.brownDark)),
                                onPressed: () {
                                  setState(() {
                                    _showTranscript = !_showTranscript;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Content Area
                            if (_showTranscript) _buildTranscriptView(),
                            if (!_showTranscript) _buildQuestionsView(),
                            
                            const SizedBox(height: 24),
                            
                            // Navigation/Submit Button
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brownDark,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  shadowColor: AppColors.brownDark.withOpacity(0.3),
                                ),
                                child: Text(
                                  'Hoàn thành bài học',
                                  style: AppTextStyles.bodyBold.copyWith(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // Thêm space cuối
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),          ],
        ),
      ),
    ),
    );
  }

  Widget _buildAudioPlayerControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brownLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left side - Audio controls (50%)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: AppColors.brownDark,
                      ),
                      iconSize: 60.0,
                      onPressed: _playerState == PlayerState.playing ? _pauseAudio : _playAudio,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.brownDark,
                    inactiveTrackColor: AppColors.brownNormal.withOpacity(0.5),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 6.0,
                    thumbColor: AppColors.brownDark,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayColor: AppColors.brownDark.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                      if (_playerState == PlayerState.paused) {
                        _playAudio();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position), style: TextStyle(color: AppColors.brownDark)),
                      Text(_formatDuration(_duration - _position), style: TextStyle(color: AppColors.brownDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Right side - Image (50%)
          Expanded(
            flex: 1,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD5B893).withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'images/animal_nature.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.brownLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.brownDark.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brownNormal.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lời thoại (Transcript)',
            style: AppTextStyles.head3Bold.copyWith(color: AppColors.brownDark),
          ),
          const SizedBox(height: 10),
          Text(
            widget.lis_lesson.transcript.isEmpty ? "Không có lời thoại cho bài này." : widget.lis_lesson.transcript,
            style: AppTextStyles.body.copyWith(color: AppColors.brownDark.withOpacity(0.8), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsView() {
    if (widget.lis_lesson.questions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Không có câu hỏi cho bài nghe này.',
            style: AppTextStyles.body.copyWith(color: AppColors.brownDark),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Sử dụng Column thay vì ListView.builder để tránh conflict scroll
    return Column(
      children: widget.lis_lesson.questions.asMap().entries.map((entry) {
        int index = entry.key;
        ListeningQuestion question = entry.value;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Câu hỏi ${index + 1}/${widget.lis_lesson.questions.length}:',
                style: AppTextStyles.head3Bold.copyWith(color: AppColors.brownDark),
              ),
              const SizedBox(height: 10),
              Text(
                question.questionText,
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownDark, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ...question.options.asMap().entries.map((entry) {
                String optionText = entry.value;
                bool isSelected = question.userAnswer == optionText;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        question.userAnswer = optionText;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brownLight.withOpacity(0.5) : AppColors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.brownDark : AppColors.brownNormal.withOpacity(0.7),
                          width: isSelected ? 2 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSelected ? AppColors.brownDark : AppColors.brownNormal,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              optionText,
                              style: AppTextStyles.body.copyWith(color: AppColors.brownDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }
}