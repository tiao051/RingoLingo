import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/category.dart';
import 'package:ringolingo_app/models/lesson.dart';
import 'package:ringolingo_app/services/category_service.dart';
import 'package:ringolingo_app/services/lesson_service.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';
import 'package:ringolingo_app/widgets/lesson_card.dart';
import 'package:ringolingo_app/widgets/skill_icon.dart';
import 'package:ringolingo_app/widgets/lesson_banner.dart';
import 'package:ringolingo_app/widgets/flippable_banner.dart';
import 'lesson_selection_screen.dart';
import 'package:ringolingo_app/screens/tracnghiem_screen.dart';
import 'package:ringolingo_app/screens/listening_practice_screen.dart';
import 'package:ringolingo_app/services/question_service.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late Future<List<Category>> futureCategories;
  Future<List<Lesson>>? futureLessons;
  String selectedSkill = 'Từ vựng';

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  void onSkillTap(String skill) {
    setState(() {
      selectedSkill = skill;
      if (skill == 'Từ vựng') {
        futureCategories = fetchCategories();
      } else if (skill == 'Bài học') {
        futureLessons ??= fetchLessons();
      }
    });
  }

  String getImageForCategory(int id) {
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

  Map<int, bool> lessonHoverStates = {};
  Map<int, bool> lessonPressStates = {};

  List<Lesson> getFakeListeningLessons() {
    return [
      Lesson(
        id: 2,
        title: 'Animals in the nature',
        categoryId: 1,
        description:
            'Explore animals and nature; animal facts and stats, mammals, marsupials, birds, insects, reptiles, dinosaurs, megafauna, fossils, environment, plants, ...',
      ),
      Lesson(
        id: 3,
        title: 'Food and things',
        categoryId: 2,
        description:
            'Food and Things are about what we eat and the items we use, like fruits, vegetables, and kitchen tools.',
      ),
      Lesson(
        id: 4,
        title: 'Travelling around the world',
        categoryId: 3,
        description:
            'Travel is about going to new places, exploring cultures, and enjoying exciting adventures.',
      ),
    ];
  }

  final Map<int, IconData> lessonIcons = {
    2: Icons.pets,
    3: Icons.fastfood,
    4: Icons.flight,
    // Nếu bạn có thêm bài 4, 5 thì thêm icon phù hợp ở đây
  };

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
              child: LeftSidebar(activeTab: 'Khóa học'),
            ),

            const SizedBox(width: 16),

            /// MAIN CONTENT - 60%
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SEARCH + AVATAR
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 83,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.brownNormal),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: AppColors.brownDark),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Tìm kiếm...',
                                      border: InputBorder.none,
                                      hintStyle:
                                          TextStyle(color: AppColors.brownDark),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 212, 221, 80),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              color: const Color.fromARGB(255, 218, 145, 145),
                              child: Image.asset(
                                'assets/images/coAnh.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 32),

                    /// SKILL ICONS
                    SizedBox(
                      height: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SkillIcon(
                            imagePath: 'assets/images/icon_tu_vung.png',
                            title: 'Từ vựng',
                            onTap: () => onSkillTap('Từ vựng'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_kiem_tra_1.png',
                            title: 'Bài học',
                            iconSize: 120,
                            onTap: () => onSkillTap('Bài học'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_dung_sai.png',
                            title: 'Trắc nghiệm',
                            iconSize: 140,
                            onTap: () => onSkillTap('Trắc nghiệm'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_luyen_nghe.png',
                            title: 'Luyện nghe',
                            onTap: () => onSkillTap('Luyện nghe'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_trac_nghiem.png',
                            title: 'Luyện nói',
                            onTap: () => onSkillTap('Luyện nói'),
                          ),
                          // SkillIcon(
                          //   imagePath: 'assets/images/icon_noi_tu.png',
                          //   title: 'Điền từ',
                          //   iconSize: 90,
                          //   onTap: () => onSkillTap('Điền từ'),
                          // ),
                        ],
                      ),
                    ),
                    if (selectedSkill == 'Bài học') ...[
                      Text('Bài học', style: AppTextStyles.head1Bold),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Lesson>>(
                        future: futureLessons,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else {
                            final lessons = snapshot.data!;
                            return Column(
                              children: lessons.map((lesson) {
                                return LessonBanner(
                                  title: lesson.title,
                                  description: lesson.description,
                                  imagePath:
                                      'assets/images/icon_trac_nghiem.png',
                                  onTap: () {
                                    print('Đã bấm vào lesson id: ${lesson.id}');
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ] else if (selectedSkill == 'Trắc nghiệm') ...[
                      const SizedBox(height: 32),
                      Text('Chọn bài trắc nghiệm',
                          style: AppTextStyles.head1Bold),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FlippableBanner(
                              imagePath: 'assets/images/banner_bai_1.png',
                              backText: 'Thế giới động vật',
                              width: 270,
                              height: 601,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TracNghiemScreen()));
                              },
                            ),
                            const SizedBox(width: 20),
                            FlippableBanner(
                              imagePath: 'assets/images/banner_bai_2.png',
                              backText: 'Thực phẩm và món ăn',
                              width: 270,
                              height: 601,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TracNghiemScreen()));
                              },
                            ),
                            const SizedBox(width: 20),
                            FlippableBanner(
                              imagePath: 'assets/images/banner_bai_3.png',
                              backText: 'Đi khắp muôn nơi',
                              width: 270,
                              height: 601,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TracNghiemScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],

                    /// CONTENT AREA
                    if (selectedSkill == 'Từ vựng') ...[
                      Text('Từ vựng', style: AppTextStyles.head1Bold),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else {
                            final categories = snapshot.data!;
                            return Column(
                              children: categories.map((category) {
                                return LessonCard(
                                  title: category.name,
                                  description: category.description,
                                  imagePath: getImageForCategory(category.id),
                                  onTap: () {
                                    print(
                                        'DEBUG: category_id = \'[32m[1m[4m${category.id}\u001b[0m\'');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LessonSelectionScreen(
                                          category: category,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ] else if (selectedSkill == 'Luyện nghe') ...[
                      const SizedBox(height: 32),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: 1.0,
                        child: Text('Chọn bài luyện nghe',
                            style: AppTextStyles.head1Bold),
                      ),
                      const SizedBox(height: 20),
                      Builder(
                        builder: (context) {
                          final listeningLessons = getFakeListeningLessons();
                          return Column(
                            children:
                                listeningLessons.asMap().entries.map((entry) {
                              final index = entry.key;
                              final lesson = entry.value;
                              final isHovering =
                                  lessonHoverStates[lesson.id] ?? false;

                              return AnimatedContainer(
                                  duration: Duration(
                                      milliseconds: 300 + (index * 50)),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: MouseRegion(
                                    onEnter: (_) => setState(() =>
                                        lessonHoverStates[lesson.id] = true),
                                    onExit: (_) => setState(() =>
                                        lessonHoverStates[lesson.id] = false),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOutCubic,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: isHovering
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isHovering
                                              ? AppColors.brownDark
                                              : AppColors.brownNormal
                                                  .withOpacity(0.5),
                                          width: isHovering ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isHovering
                                                ? AppColors.brownDark
                                                    .withOpacity(0.2)
                                                : AppColors.brownNormal
                                                    .withOpacity(0.1),
                                            blurRadius: isHovering ? 15 : 8,
                                            offset:
                                                Offset(0, isHovering ? 8 : 4),
                                          ),
                                        ],
                                      ),
                                      transform: Matrix4.identity()
                                        ..translate(
                                            0.0, isHovering ? -2.0 : 0.0)
                                        ..scale(isHovering ? 1.01 : 1.0),
                                      child: InkWell(
                                        onTap: () {
                                          print(
                                              'Đã bấm vào lesson id: ${lesson.id}');
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Lesson Icon
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: AppColors.brownLight
                                                    .withOpacity(
                                                        isHovering ? 0.3 : 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                lessonIcons[lesson.id] ??
                                                    Icons.headphones_rounded,
                                                size: isHovering ? 40 : 35,
                                                color: AppColors.brownDark,
                                              ),
                                            ),

                                            const SizedBox(width: 20),

                                            // Lesson Content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AnimatedDefaultTextStyle(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    style: AppTextStyles
                                                        .head3Bold
                                                        .copyWith(
                                                      color: isHovering
                                                          ? AppColors.brownDark
                                                          : AppColors
                                                              .brownNormal,
                                                    ),
                                                    child: Text(
                                                      lesson.title,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    lesson.description,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors
                                                          .brownNormal
                                                          .withOpacity(0.8),
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Action Button
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              width:
                                                  100, // giữ cố định 100 px để tránh overflow
                                              height: 40,
                                              child: isHovering
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Colors.blue[400]!,
                                                            Colors.blue[600]!,
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 8,
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            try {
                                                              final questionsFromApi =
                                                                  await fetchQuestions(
                                                                      lesson
                                                                          .id); // List<Question>
                                                              final listeningQuestions =
                                                                  convertToListeningQuestions(
                                                                      questionsFromApi);

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ListeningPracticeScreen(
                                                                    lis_lesson:
                                                                        ListeningLesson(
                                                                      id: lesson
                                                                          .id,
                                                                      title: lesson
                                                                          .title,
                                                                      audioUrl:
                                                                          'audio/speaking_animal.mp3',
                                                                      questions:
                                                                          listeningQuestions, // Truyền đúng kiểu List<ListeningQuestion>
                                                                      transcript:
                                                                          'Animals are amazing creatures that live all around the world. In the jungle, you can find tigers, snakes, monkeys, and colorful parrots.On the farm, there are cows, pigs, chickens, and sheep. In the ocean, dolphins, whales, sharks, and turtles swim freely.Some animals, like cats and dogs, are our pets and live with us at home. Others, like elephants and giraffes, live in the wild or in zoos. Each animal has its own unique features—some have fur, feathers, or scales. They eat different foods and make different sounds.Learning about animals helps us understand nature and how to take care of the world around us.',
                                                                      categoryId:
                                                                          lesson
                                                                              .categoryId,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } catch (e) {
                                                              print(
                                                                  'Lỗi khi lấy câu hỏi: $e');
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        'Không thể tải câu hỏi')),
                                                              );
                                                            }
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: const Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .headphones,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                                SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  'Bắt đầu',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox
                                                      .shrink(), // ẩn khi không hover nhưng vẫn giữ chỗ
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          );
                        },
                      ),
                    ] else ...[
                      Text('Đang chọn: $selectedSkill',
                          style: AppTextStyles.head1Bold),
                      const SizedBox(height: 20),
                      Text('Chức năng "$selectedSkill" chưa được cài đặt.',
                          style: AppTextStyles.head3Black),
                    ],
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
}
