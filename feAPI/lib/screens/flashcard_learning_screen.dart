import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
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

class _FlashcardLearningScreenState extends State<FlashcardLearningScreen> {
  late Future<List<Vocabulary>> futureVocabularies;
  List<Vocabulary> vocabularies = [];
  int currentIndex = 0;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isLoading = true;
  bool isFlipped = false; // Để theo dõi trạng thái lật thẻ

  @override
  void initState() {
    super.initState();
    futureVocabularies = fetchVocabulariesByLessonId(widget.lesson.id);
    _loadVocabularies();
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

  void _nextCard() {
    if (currentIndex < vocabularies.length - 1) {
      setState(() {
        currentIndex++;
        isFlipped = false; // Đặt lại trạng thái lật thẻ
      });
    }
  }

  void _previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isFlipped = false; // Đặt lại trạng thái lật thẻ
      });
    }
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
                fontSize: 18, // Increased from 16
                color: Colors.black54,
                fontStyle: FontStyle.italic))
      ];
    }
    if (wordToHighlight.isEmpty) {
      return [
        TextSpan(
            text: sentence,
            style: AppTextStyles.body.copyWith(
                fontSize: 18, // Increased from 16
                color: Colors.black87))
      ];
    }

    List<TextSpan> spans = [];
    final RegExp regex =
        RegExp(RegExp.escape(wordToHighlight), caseSensitive: false);
    int lastMatchEnd = 0;

    final defaultStyle = AppTextStyles.body.copyWith(
        fontSize: 18, // Increased from 16
        color: Colors.black87,
        height: 1.5);
    final highlightStyle = AppTextStyles.bodyBold.copyWith(
        fontSize: 18, // Increased from 16
        color: AppColors.redNormal,
        height: 1.5);

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          vocab.englishWord,
          style: AppTextStyles.head1Bold.copyWith(
            fontSize: 42, // Increased from 32
            color: AppColors.redNormal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16), // Increased from 12
        Text(
          '/${vocab.pronunciation}/',
          style: AppTextStyles.body.copyWith(
            fontSize: 22, // Increased from 18
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 35), // Increased from 30
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 320, // Increased from 280
              height: 280, // Increased from 240
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.brownNormal, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
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
                          print(
                              'Attempted path: ${_getCurrentVocabularyImagePath()}');

                          // Thử fallback với tên file trực tiếp từ englishWord
                          String fallbackPath =
                              'assets/images/dong_vat/${vocab.englishWord.toLowerCase()}.png';
                          print('Trying fallback path: $fallbackPath');

                          return Image.asset(
                            fallbackPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error2, stackTrace2) {
                              print('ERROR with fallback: $error2');
                              return Container(
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image_outlined,
                                        size: 60, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Không tìm thấy hình',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500]),
                                    ),
                                    Text(
                                      vocab.englishWord,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported_outlined,
                                size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Chưa có hình ảnh',
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
                      ),
              ),
            ),
            Positioned(
              right: -20, // Adjusted from -15
              top: 15, // Adjusted from 10
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.redLight.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.volume_up,
                      color: AppColors.redNormal,
                      size: 36), // Increased from 30
                  onPressed: _playAudio,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30), // Increased from 25
        Text(
          "(Chạm để xem nghĩa)",
          style: AppTextStyles.body.copyWith(
              color: Colors.grey[600],
              fontSize: 16, // Increased from 14
              fontStyle: FontStyle.italic),
        )
      ],
    );
  }

  Widget _buildBackContent(Vocabulary vocab) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          vocab.vietnameseMeaning,
          style: AppTextStyles.head2Bold.copyWith(
            fontSize: 36, // Increased from 28
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 35), // Increased from 25
        Text(
          "Ví dụ:",
          style: AppTextStyles.head3Bold
              .copyWith(color: Colors.black54, fontSize: 22 // Increased from 18
                  ),
        ),
        const SizedBox(height: 12), // Increased from 8
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Increased from 15.0
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: _buildHighlightedExampleSpans(
                  vocab.exampleSentence, vocab.englishWord),
            ),
          ),
        ),
        const SizedBox(height: 35), // Increased from 30
        Text(
          "(Chạm để xem lại)",
          style: AppTextStyles.body.copyWith(
              color: Colors.grey[600],
              fontSize: 16, // Increased from 14
              fontStyle: FontStyle.italic),
        )
      ],
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
                            child: Container(
                              height: 10, // Slightly thicker
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: vocabularies.isNotEmpty
                                    ? (currentIndex + 1) / vocabularies.length
                                    : 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.redNormal,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            vocabularies.isNotEmpty
                                ? '${currentIndex + 1}/${vocabularies.length}'
                                : '0/0',
                            style: AppTextStyles.head3Bold.copyWith(
                                color: AppColors.black.withOpacity(0.7)),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 10), // Reduced space
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (vocabularies.isNotEmpty) {
                                setState(() {
                                  isFlipped = !isFlipped;
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height:
                                  520, // Fixed height instead of constraints
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    // Simplified flip animation
                                    return AnimatedBuilder(
                                      animation: animation,
                                      child: child,
                                      builder: (context, widgetChild) {
                                        final isShowingFrontSide =
                                            animation.value < 0.5;
                                        if (isShowingFrontSide) {
                                          return Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateY(
                                                  animation.value * 3.1415926),
                                            child: widgetChild,
                                          );
                                        } else {
                                          return Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateY((1 - animation.value) *
                                                  3.1415926),
                                            child: widgetChild,
                                          );
                                        }
                                      },
                                    );
                                  },
                                  child: Container(
                                    key: ValueKey(isFlipped),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: isFlipped
                                        ? _buildBackContent(
                                            vocabularies[currentIndex])
                                        : _buildFrontContent(
                                            vocabularies[currentIndex]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 15), // Reduced space
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                10.0), // Ensure buttons are not at the very bottom
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed:
                                  currentIndex > 0 ? _previousCard : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brownNormal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                disabledBackgroundColor: Colors.grey[400],
                                elevation: 3,
                              ),
                              icon: Icon(Icons.arrow_back_ios_new,
                                  color: AppColors.white, size: 18),
                              label: Text('Trước',
                                  style: AppTextStyles.button.copyWith(
                                      color: AppColors.white, fontSize: 17)),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (currentIndex < vocabularies.length - 1) {
                                  _nextCard();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: Text('Hoàn thành!',
                                          style: AppTextStyles.head2Bold
                                              .copyWith(
                                                  color: AppColors.redNormal)),
                                      content: Text(
                                          'Bạn đã học xong tất cả từ vựng trong bài này.',
                                          style: AppTextStyles.body),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                dialogContext); // Đóng dialog
                                            Navigator.pop(
                                                context); // Quay lại màn hình trước đó
                                          },
                                          child: Text('Tuyệt vời!',
                                              style: AppTextStyles.button
                                                  .copyWith(
                                                      color:
                                                          AppColors.redNormal,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redNormal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 3,
                              ),
                              label: Text(
                                currentIndex < vocabularies.length - 1
                                    ? 'Tiếp'
                                    : 'Hoàn thành',
                                style: AppTextStyles.button.copyWith(
                                    color: AppColors.white, fontSize: 17),
                              ),
                              icon: Icon(
                                  currentIndex < vocabularies.length - 1
                                      ? Icons.arrow_forward_ios
                                      : Icons.check_circle_outline,
                                  color: AppColors.white,
                                  size: 18),
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
