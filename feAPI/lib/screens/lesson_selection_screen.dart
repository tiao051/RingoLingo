import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/category.dart';
import 'package:ringolingo_app/models/lesson.dart';
import 'package:ringolingo_app/services/vocabulary_service.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';
import 'package:ringolingo_app/widgets/lesson_banner.dart';
import 'flashcard_learning_screen.dart';

class LessonSelectionScreen extends StatefulWidget {
  final Category category;

  const LessonSelectionScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _LessonSelectionScreenState createState() => _LessonSelectionScreenState();
}

class _LessonSelectionScreenState extends State<LessonSelectionScreen> {
  late Future<List<Lesson>> futureLessons;

  @override
  void initState() {
    super.initState();
    print('DEBUG: LessonSelectionScreen nhận category_id = \'${widget.category.id}\'');
    futureLessons = fetchLessonsByCategory(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT SIDEBAR - 20%
            Expanded(
              flex: 2,
              child: LeftSidebar(),
            ),

            const SizedBox(width: 16),

            /// MAIN CONTENT - 60%
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppColors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Chọn bài học cho ${widget.category.name}',
                          style: AppTextStyles.head1Bold,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Category description
                    Text(
                      widget.category.description,
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: 32),

                    // Lessons list
                    FutureBuilder<List<Lesson>>(
                      future: futureLessons,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              Text('Lỗi: ${snapshot.error}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    futureLessons = fetchLessonsByCategory(widget.category.id);
                                  });
                                },
                                child: Text('Thử lại'),
                              ),
                            ],
                          );
                        } else {
                          final lessons = snapshot.data!;
                          if (lessons.isEmpty) {
                            return Center(
                              child: Text(
                                'Chưa có bài học nào trong chủ đề này',
                                style: AppTextStyles.head3Black,
                              ),
                            );
                          }

                          // Trả về danh sách bài học và ảnh banner
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...lessons.map((lesson) {
                                return LessonBanner(
                                  title: lesson.title,
                                  description: lesson.description,
                                  imagePath: _getImageForCategory(widget.category.id),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FlashcardLearningScreen(
                                          lesson: lesson,
                                          categoryName: widget.category.name,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),

                              const SizedBox(height: 58),

                              // Banner "Let's Go" ở dưới cùng
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/banner_letgo.png',
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT SIDEBAR - 20%
            Expanded(
              flex: 2,
              child: RightSidebar(),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageForCategory(int id) {
    switch (id) {
      case 1:
        return 'assets/images/icon_chu_de_2.png';
      case 2:
        return 'assets/images/icon_chu_de_3.png';
      case 3:
        return 'assets/images/icon_chu_de_1.png';
      default:
        return 'assets/images/default_icon.png';
    }
  }
}
