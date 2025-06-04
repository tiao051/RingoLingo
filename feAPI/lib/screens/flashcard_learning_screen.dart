import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:ringolingo_app/models/lesson.dart';
import 'package:ringolingo_app/models/vocabulary.dart';
import 'package:ringolingo_app/services/vocabulary_service.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
// import 'dart:math'; // Không cần thiết cho phiên bản hiện tại

class FlashcardLearningScreen extends StatefulWidget {
  final Lesson lesson;
  final String categoryName;

  const FlashcardLearningScreen({
    Key? key,
    required this.lesson,
    required this.categoryName,
  }) : super(key: key);

  @override
  _FlashcardLearningScreenState createState() =>
      _FlashcardLearningScreenState();
}

class _FlashcardLearningScreenState extends State<FlashcardLearningScreen>
    with TickerProviderStateMixin {
  late Future<List<Vocabulary>> futureVocabularies;
  List<Vocabulary> vocabularies = [];
  int currentIndex = 0;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isLoading = true;
  bool isFlipped = false; // Để theo dõi trạng thái lật thẻ
  bool isNavigating = false; // Loading state for navigation
  bool showSuccessAnimation = false; // Success animation state
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _buttonAnimationController;
  late AnimationController _successAnimationController;

  @override
  void initState() {
    super.initState();
    futureVocabularies = fetchVocabulariesByLessonId(widget.lesson.id);
    _loadVocabularies();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  void _loadVocabularies() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await futureVocabularies; // data là List<Vocabulary>
      setState(() {
        vocabularies = data.map((v) {
          // v là một đối tượng Vocabulary từ danh sách đã fetch
          // Logic để xác định câu ví dụ:
          // Ưu tiên v.exampleSentence nếu nó đã được điền và không trống.
          // Nếu không, sử dụng câu ví dụ được mock.
          String finalExampleSentence =
              v.exampleSentence; // Giả sử v.exampleSentence tồn tại

          // Nếu v.exampleSentence trống hoặc là một placeholder, tạo một câu cụ thể hơn
          if (finalExampleSentence.isEmpty ||
              finalExampleSentence == 'No example available.') {
            if (v.englishWord.toLowerCase() == "apple") {
              finalExampleSentence = "An apple a day keeps the doctor away.";
            } else if (v.englishWord.toLowerCase() == "book") {
              finalExampleSentence = "I love to read a good book.";
            } else {
              // Mock mặc định nếu không có trường hợp cụ thể nào khớp
              finalExampleSentence = "This is an example for ${v.englishWord}.";
            }
          }

          // Tạo lại đối tượng Vocabulary, đảm bảo tất cả các trường bắt buộc được cung cấp.
          return Vocabulary(
            id: v.id,
            lessonId: v.lessonId,
            englishWord: v.englishWord,
            vietnameseMeaning: v.vietnameseMeaning,
            pronunciation: v.pronunciation,
            imagePath: v.imagePath,
            audioPath: v.audioPath,
            orderNum: v
                .orderNum, // Đảm bảo Vocabulary model có trường này và service cung cấp nó
            exampleSentence: finalExampleSentence,
          );
        }).toList();
        isLoading = false;
        if (vocabularies.isEmpty) {
          _showNoVocabDialog();
        }
      });
    } catch (e) {
      print("Error loading vocabularies: $e");
      setState(() {
        isLoading = false;
        _showNoVocabDialog(); // Hoặc một dialog lỗi cụ thể
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi tải từ vựng: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNoVocabDialog() {
    // Phương thức này hiện tại không làm gì nhiều vì logic đã được xử lý trong build()
    // Bạn có thể thêm logic dialog ở đây nếu muốn
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _buttonAnimationController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  void _playAudio() async {
    if (vocabularies.isNotEmpty && currentIndex < vocabularies.length) {
      final currentVocab = vocabularies[currentIndex];
      try {
        String audioPath = currentVocab.audioPath.isNotEmpty
            ? 'audio/${currentVocab.audioPath}' //Đường dẫn phải là 'audio/ten_file.mp3'
            : 'audio/default_pronunciation.mp3'; // Đảm bảo file này tồn tại

        await audioPlayer.play(AssetSource(audioPath));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Không thể phát âm thanh: ${currentVocab.englishWord}. Lỗi: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _nextCard() async {
    if (currentIndex < vocabularies.length - 1) {
      setState(() {
        isNavigating = true;
      });

      HapticFeedback.lightImpact(); // Add haptic feedback

      // Simulate brief loading for smooth UX
      await Future.delayed(const Duration(milliseconds: 150));

      setState(() {
        currentIndex++;
        isFlipped = false; // Đặt lại trạng thái lật thẻ
        isNavigating = false;
      });

      _triggerProgressPulse();
      _checkMilestone();
    }
  }

  void _previousCard() async {
    if (currentIndex > 0) {
      setState(() {
        isNavigating = true;
      });

      HapticFeedback.lightImpact(); // Add haptic feedback

      // Simulate brief loading for smooth UX
      await Future.delayed(const Duration(milliseconds: 150));

      setState(() {
        currentIndex--;
        isFlipped = false; // Đặt lại trạng thái lật thẻ
        isNavigating = false;
      });

      _triggerProgressPulse();
    }
  }

  void _checkMilestone() {
    final progress = (currentIndex + 1) / vocabularies.length;

    // Check for milestone achievements (25%, 50%, 75%, 100%)
    if (progress == 0.25 ||
        progress == 0.5 ||
        progress == 0.75 ||
        progress == 1.0) {
      _triggerSuccessAnimation();
    }
  }

  void _triggerSuccessAnimation() {
    setState(() {
      showSuccessAnimation = true;
    });

    _successAnimationController.forward().then((_) {
      _successAnimationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            showSuccessAnimation = false;
          });
        }
      });
    });

    HapticFeedback.mediumImpact(); // Milestone haptic
  }

  void _triggerProgressPulse() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  String _getCurrentVocabularyImagePath() {
    if (vocabularies.isNotEmpty &&
        currentIndex < vocabularies.length &&
        vocabularies[currentIndex].imagePath.isNotEmpty) {
      final vocab = vocabularies[currentIndex];

      // Debug: In ra imagePath để kiểm tra
      print('DEBUG - Image path from API: "${vocab.imagePath}"');
      print('DEBUG - English word: "${vocab.englishWord}"');

      // Nếu imagePath đã bao gồm thư mục con (như 'dong_vat/cat.png')
      String fullPath = 'assets/images/${vocab.imagePath}';

      // Nếu imagePath chỉ là tên file, thử đoán thư mục dựa trên từ loại
      if (!vocab.imagePath.contains('/')) {
        // Thử các thư mục có thể có
        String? categoryFolder =
            _getCategoryFolder(vocab.englishWord.toLowerCase());
        if (categoryFolder != null) {
          fullPath = 'assets/images/$categoryFolder/${vocab.imagePath}';
        }
      }

      print('DEBUG - Final image path: "$fullPath"');
      return fullPath;
    }
    print('DEBUG - Using default image: imagePath is empty or invalid');
    return 'assets/images/default_flashcard.png';
  }

  String? _getCategoryFolder(String englishWord) {
    // Mapping từ vựng động vật
    const animalWords = [
      'cat',
      'dog',
      'cow',
      'elephant',
      'lion',
      'monkey',
      'rabbit',
      'sheep',
      'tiger',
      'wolf'
    ];

    if (animalWords.contains(englishWord)) {
      return 'dong_vat';
    }

    // Có thể thêm các danh mục khác như thuc_an, gia_dinh
    // const foodWords = ['apple', 'banana', 'bread', ...];
    // const familyWords = ['father', 'mother', 'sister', ...];

    return null; // Không xác định được danh mục
  }

  List<TextSpan> _buildHighlightedExampleSpans(
      String sentence, String wordToHighlight) {
    if (sentence.isEmpty) {
      return [
        TextSpan(
            text: "No example available.",
            style: AppTextStyles.body.copyWith(
                fontSize: 15, // Giảm từ 18 để tránh overflow
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                height: 1.4))
      ];
    }
    if (wordToHighlight.isEmpty) {
      return [
        TextSpan(
            text: sentence,
            style: AppTextStyles.body.copyWith(
                fontSize: 15, // Giảm từ 18 để tránh overflow
                color: Colors.black87,
                height: 1.4))
      ];
    }

    List<TextSpan> spans = [];
    final RegExp regex =
        RegExp(RegExp.escape(wordToHighlight), caseSensitive: false);
    int lastMatchEnd = 0;

    final defaultStyle = AppTextStyles.body.copyWith(
        fontSize: 15, // Giảm từ 18 để tránh overflow
        color: Colors.black87,
        height: 1.4);
    final highlightStyle = AppTextStyles.bodyBold.copyWith(
        fontSize: 15, // Giảm từ 18 để tránh overflow
        color: AppColors.redNormal,
        height: 1.4);

    for (final Match match in regex.allMatches(sentence)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
            text: sentence.substring(lastMatchEnd, match.start),
            style: defaultStyle));
      }
      spans.add(TextSpan(
        text: sentence.substring(match.start, match.end),
        style: highlightStyle,
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < sentence.length) {
      spans.add(TextSpan(
          text: sentence.substring(lastMatchEnd), style: defaultStyle));
    }

    if (spans.isEmpty && sentence.isNotEmpty) {
      spans.add(TextSpan(text: sentence, style: defaultStyle));
    }

    return spans;
  }

  Widget _buildFrontContent(Vocabulary vocab) {
    // Mặt trước - Hiển thị hình ảnh
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
      width: 320,
      height: 260, // Giảm từ 280 để phù hợp với layout mới
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.brownNormal, width: 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            const Color(0xFFF8F6F0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brownNormal.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: vocab.imagePath.isNotEmpty
            ? Image.asset(
                _getCurrentVocabularyImagePath(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('ERROR loading image: $error');
                  print('Attempted path: ${_getCurrentVocabularyImagePath()}');

                  String fallbackPath =
                      'assets/images/dong_vat/${vocab.englishWord.toLowerCase()}.png';
                  print('Trying fallback path: $fallbackPath');

                  return Image.asset(
                    fallbackPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error2, stackTrace2) {
                      print('ERROR with fallback: $error2');
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey[100]!,
                              Colors.grey[200]!,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_outlined,
                                size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Không tìm thấy hình',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                            Text(
                              vocab.englishWord,
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[100]!,
                      Colors.grey[200]!,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined,
                        size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Chưa có hình ảnh',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    Text(
                      vocab.englishWord,
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBackContent(Vocabulary vocab) {
    // Mặt sau - Hiển thị nghĩa tiếng Việt và ví dụ
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
      width: 320,
      height: 260, // Giảm từ 280 để phù hợp với layout mới
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.redNormal, width: 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            const Color(0xFFFFF8F0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.redNormal.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding:
              const EdgeInsets.all(14.0), // Giảm từ 16 để tiết kiệm không gian
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nghĩa tiếng Việt - Flexible để tự động điều chỉnh
              Flexible(
                flex: 2,
                child: Center(
                  child: Text(
                    vocab.vietnameseMeaning,
                    style: AppTextStyles.head2Bold.copyWith(
                      fontSize: 24, // Giảm từ 26 để phù hợp với height mới
                      color: AppColors.redNormal,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3, // Giới hạn số dòng
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 8), // Giảm từ 12

              // Tiêu đề "Ví dụ"
              Text(
                "Ví dụ:",
                style: AppTextStyles.head3Bold.copyWith(
                  color: Colors.black54,
                  fontSize: 14, // Giảm từ 15
                ),
              ),

              const SizedBox(height: 4), // Giảm từ 6

              // Ví dụ - Expanded để sử dụng không gian còn lại
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: _buildHighlightedExampleSpans(
                            vocab.exampleSentence, vocab.englishWord),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(Vocabulary vocab) {
    return Column(
      children: [
        // Phần text cố định (không lật) - Flexible để tự động điều chỉnh
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  vocab.englishWord,
                  style: AppTextStyles.head1Bold.copyWith(
                    fontSize: 38, // Giảm từ 42
                    color: AppColors.redNormal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 12), // Giảm từ 16
              Text(
                '/${vocab.pronunciation}/',
                style: AppTextStyles.body.copyWith(
                  fontSize: 20, // Giảm từ 22
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20), // Giảm từ 35

        // Phần hình ảnh có animation lật 3D - Expanded để sử dụng không gian chính
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none, // Cho phép nút audio không bị cắt
            children: [
              Container(
                width: 320,
                height: 260, // Giảm từ 280 để tiết kiệm không gian
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: isFlipped ? 1.0 : 0.0),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    // Xác định mặt nào đang hiển thị dựa trên animation value
                    final isShowingFront = value < 0.5;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0008) // Perspective
                        ..rotateY(value * 3.14159),
                      child: isShowingFront
                          ? _buildFrontContent(
                              vocabularies[currentIndex]) // Mặt trước
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateY(3.14159), // Lật mặt sau
                              child: _buildBackContent(
                                  vocabularies[currentIndex]), // Mặt sau
                            ),
                    );
                  },
                ),
              ),

              // Nút phát âm (cố định) với animation hover - đặt bên ngoài Container
              Positioned(
                right: -15, // Di chuyển ra ngoài một chút để không bị cắt
                top: -15,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.redLight.withOpacity(0.95),
                        AppColors.redNormal.withOpacity(0.85),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.redNormal.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: _playAudio,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16), // Giảm từ 30

        // Text hướng dẫn (cố định) với animation - Flexible để không overflow
        Flexible(
          flex: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 0.8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(0, 0.3), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeOut)),
                    ),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey(isFlipped),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6), // Giảm padding
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFlipped
                        ? AppColors.redNormal.withOpacity(0.3)
                        : AppColors.brownNormal.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isFlipped ? Icons.image_rounded : Icons.translate_rounded,
                      size: 14, // Giảm từ 16
                      color: isFlipped
                          ? AppColors.redNormal
                          : AppColors.brownNormal,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isFlipped
                            ? "Chạm để xem lại hình"
                            : "Chạm để xem nghĩa",
                        style: AppTextStyles.body.copyWith(
                          color: isFlipped
                              ? AppColors.redNormal
                              : AppColors.brownNormal,
                          fontSize: 13, // Giảm từ 14
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isAtMilestone() {
    final progress = (currentIndex + 1) / vocabularies.length;
    return progress == 0.25 ||
        progress == 0.5 ||
        progress == 0.75 ||
        progress == 1.0;
  }

  Widget _buildButtonIcon(
      IconData icon, bool isLoading, bool showSuccess, bool isEnabled) {
    if (isLoading) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }

    if (showSuccess) {
      return AnimatedBuilder(
        animation: _successAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale:
                1.0 + (sin(_successAnimationController.value * pi * 4) * 0.2),
            child: Icon(
              Icons.celebration,
              color: AppColors.white,
              size: 18,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()
        ..rotateZ(
            isEnabled && _buttonAnimationController.value > 0 ? 0.1 : 0.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          icon,
          key: ValueKey(icon),
          color: AppColors.white,
          size: 18,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedNavigationButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool isEnabled,
    required bool isPrimary,
    bool isLoading = false,
    bool showSuccess = false,
  }) {
    return AnimatedBuilder(
      animation: _buttonAnimationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown:
              isEnabled ? (_) => _buttonAnimationController.forward() : null,
          onTapUp:
              isEnabled ? (_) => _buttonAnimationController.reverse() : null,
          onTapCancel:
              isEnabled ? () => _buttonAnimationController.reverse() : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: Matrix4.identity()
              ..scale(isEnabled
                  ? 1.0 - (_buttonAnimationController.value * 0.05)
                  : 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isEnabled
                    ? (isPrimary ? AppColors.redNormal : AppColors.brownNormal)
                    : Colors.grey[400],
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: (isPrimary
                                  ? AppColors.redNormal
                                  : AppColors.brownNormal)
                              .withOpacity(0.3 +
                                  (_buttonAnimationController.value * 0.2)),
                          blurRadius:
                              8 + (_buttonAnimationController.value * 4),
                          offset: Offset(
                              0, 3 + (_buttonAnimationController.value * 2)),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                        // Additional shadow for better depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  // Milestone sparkle effect
                  if (showSuccess && isPrimary)
                    AnimatedBuilder(
                      animation: _successAnimationController,
                      builder: (context, child) {
                        return Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              children: List.generate(6, (index) {
                                final angle = (index * pi / 3) +
                                    (_successAnimationController.value *
                                        pi *
                                        2);
                                final radius = 30 +
                                    (sin(_successAnimationController.value *
                                            pi *
                                            4) *
                                        10);
                                return Positioned(
                                  left: 50 + cos(angle) * radius,
                                  top: 25 + sin(angle) * radius,
                                  child: Opacity(
                                    opacity: (1.0 -
                                            _successAnimationController.value) *
                                        0.8,
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 8 +
                                          (sin(_successAnimationController
                                                      .value *
                                                  pi *
                                                  6) *
                                              4),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ), // Actual button with loading/success states
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    icon: _buildButtonIcon(
                        icon, isLoading, showSuccess, isEnabled),
                    label: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight:
                            isEnabled && _buttonAnimationController.value > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isLoading
                            ? const Text('Đang tải...')
                            : showSuccess
                                ? const Text('Tuyệt vời!')
                                : Text(label),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCompletionDialog() {
    HapticFeedback.heavyImpact(); // Success haptic
    showDialog(
      context: context,
      builder: (dialogContext) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.celebration, color: AppColors.redNormal, size: 28),
              const SizedBox(width: 8),
              Text(
                'Hoàn thành!',
                style: AppTextStyles.head2Bold.copyWith(
                  color: AppColors.redNormal,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bạn đã học xong tất cả từ vựng trong bài này.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.redLight.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome,
                        color: AppColors.redNormal, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${vocabularies.length} từ vựng đã học',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.redNormal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Nút Quay lại màn hình chính
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.redNormal,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redNormal.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Đóng dialog
                  Navigator.pop(context); // Quay lại màn hình trước đó
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: AppColors.redNormal, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Trang chủ',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.redNormal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nút Bắt đầu kiểm tra
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.redNormal, AppColors.redLight],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redNormal.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Đóng dialog
                  Navigator.pop(context); // Quay lại màn hình trước đó
                  // Điều hướng tới màn hình kiểm tra
                  Navigator.pushNamed(context, '/quiz');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.quiz, color: AppColors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Kiểm tra',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.categoryName} - ${widget.lesson.title}',
          style: AppTextStyles.head2Bold.copyWith(color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.redNormal))
          : vocabularies.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 80, color: AppColors.black.withOpacity(0.6)),
                        const SizedBox(height: 20),
                        Text(
                          'Không có từ vựng nào trong bài học này.',
                          style: AppTextStyles.head3Bold.copyWith(
                              color: AppColors.black.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redNormal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: AppColors.white, size: 18),
                          label: Text('Quay lại',
                              style: AppTextStyles.button
                                  .copyWith(color: AppColors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 10, 20, 20), // Adjusted top padding
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.02),
                                  child: Container(
                                    height: 12, // Slightly thicker
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius:
                                              4 + (_pulseController.value * 2),
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TweenAnimationBuilder<double>(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeOutCubic,
                                      tween: Tween(
                                        begin: 0.0,
                                        end: vocabularies.isNotEmpty
                                            ? (currentIndex + 1) /
                                                vocabularies.length
                                            : 0.0,
                                      ),
                                      builder: (context, value, child) {
                                        return Stack(
                                          children: [
                                            FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: value,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppColors.redNormal,
                                                      AppColors.redLight,
                                                      AppColors.redNormal,
                                                    ],
                                                    stops: const [
                                                      0.0,
                                                      0.5,
                                                      1.0
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.redNormal
                                                          .withOpacity(0.4 +
                                                              (_pulseController
                                                                      .value *
                                                                  0.2)),
                                                      blurRadius: 8 +
                                                          (_pulseController
                                                                  .value *
                                                              4),
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Enhanced Shimmer effect
                                            if (value > 0)
                                              AnimatedBuilder(
                                                animation: _shimmerController,
                                                builder: (context, child) {
                                                  final shimmerValue =
                                                      (_shimmerController
                                                                  .value *
                                                              3.0 -
                                                          1.5);
                                                  return FractionallySizedBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    widthFactor: value,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment(
                                                              shimmerValue - 1,
                                                              0),
                                                          end: Alignment(
                                                              shimmerValue + 1,
                                                              0),
                                                          colors: [
                                                            Colors.transparent,
                                                            AppColors.white
                                                                .withOpacity(
                                                                    0.7),
                                                            AppColors.white
                                                                .withOpacity(
                                                                    0.4),
                                                            AppColors.white
                                                                .withOpacity(
                                                                    0.7),
                                                            Colors.transparent,
                                                          ],
                                                          stops: const [
                                                            0.0,
                                                            0.3,
                                                            0.5,
                                                            0.7,
                                                            1.0
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.05),
                                child: TweenAnimationBuilder<int>(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.elasticOut,
                                  tween: IntTween(
                                    begin: 0,
                                    end: vocabularies.isNotEmpty
                                        ? currentIndex + 1
                                        : 0,
                                  ),
                                  builder: (context, currentCount, child) {
                                    return TweenAnimationBuilder<int>(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeOutQuart,
                                      tween: IntTween(
                                        begin: 0,
                                        end: vocabularies.length,
                                      ),
                                      builder: (context, totalCount, child) {
                                        return AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.white
                                                    .withOpacity(0.95),
                                                AppColors.brownLight
                                                    .withOpacity(0.8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: AppColors.brownNormal
                                                  .withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.brownNormal
                                                    .withOpacity(0.15 +
                                                        (_pulseController
                                                                .value *
                                                            0.1)),
                                                blurRadius: 8 +
                                                    (_pulseController.value *
                                                        4),
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.book_rounded,
                                                size: 16,
                                                color: AppColors.redNormal,
                                              ),
                                              const SizedBox(width: 6),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '$currentCount',
                                                      style: AppTextStyles
                                                          .head3Bold
                                                          .copyWith(
                                                        color:
                                                            AppColors.redNormal,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '/',
                                                      style: AppTextStyles.body
                                                          .copyWith(
                                                        color: AppColors.black
                                                            .withOpacity(0.5),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '$totalCount',
                                                      style: AppTextStyles
                                                          .head3Bold
                                                          .copyWith(
                                                        color: AppColors.black
                                                            .withOpacity(0.7),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // const SizedBox(height: 10), // Reduced space
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (vocabularies.isNotEmpty) {
                                HapticFeedback
                                    .lightImpact(); // Thêm haptic feedback
                                setState(() {
                                  isFlipped = !isFlipped;
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 520,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isFlipped
                                            ? AppColors.redNormal
                                            : AppColors.brownNormal)
                                        .withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: _buildCardContent(
                                    vocabularies[currentIndex]),
                              ),
                            ),
                          ),
                        ),
                      ), // Enhanced Navigation Buttons
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Previous Button with Enhanced Animation
                            _buildEnhancedNavigationButton(
                              onPressed: currentIndex > 0 && !isNavigating
                                  ? _previousCard
                                  : null,
                              icon: Icons.arrow_back_ios_new,
                              label: 'Trước',
                              isEnabled: currentIndex > 0 && !isNavigating,
                              isPrimary: false,
                              isLoading: isNavigating && currentIndex > 0,
                              showSuccess: false,
                            ),
                            // Next/Complete Button with Enhanced Animation
                            _buildEnhancedNavigationButton(
                              onPressed: !isNavigating
                                  ? () {
                                      if (currentIndex <
                                          vocabularies.length - 1) {
                                        _nextCard();
                                      } else {
                                        _showCompletionDialog();
                                      }
                                    }
                                  : null,
                              icon: currentIndex < vocabularies.length - 1
                                  ? (_isAtMilestone()
                                      ? Icons.star
                                      : Icons.arrow_forward_ios)
                                  : Icons.check_circle_outline,
                              label: currentIndex < vocabularies.length - 1
                                  ? (_isAtMilestone() ? 'Cột mốc!' : 'Tiếp')
                                  : 'Hoàn thành',
                              isEnabled: !isNavigating,
                              isPrimary: true,
                              isLoading: isNavigating,
                              showSuccess:
                                  showSuccessAnimation && _isAtMilestone(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
