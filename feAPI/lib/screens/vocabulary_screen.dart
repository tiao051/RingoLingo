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
import 'package:ringolingo_app/screens/speaking_practice_screen.dart';
import 'package:ringolingo_app/services/question_service.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen>
    with TickerProviderStateMixin {
  late Future<List<Category>> futureCategories;
  Future<List<Lesson>>? futureLessons;
  String selectedSkill = 'Từ vựng';
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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

    // Reset and restart animations for new content
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
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
  Map<int, bool> speakingHoverStates = {};

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

  List<Lesson> getFakeSpeakingLessons() {
    return [
      Lesson(
        id: 5,
        title: 'Pronunciation Practice: Animals',
        categoryId: 1,
        description:
            'Practice pronouncing animal names correctly. Learn to speak clearly about pets, wild animals, and farm animals with proper intonation.',
      ),
      Lesson(
        id: 6,
        title: 'Food Vocabulary Speaking',
        categoryId: 2,
        description:
            'Master food-related vocabulary through speaking exercises. Practice ordering food, describing tastes, and discussing cooking methods.',
      ),
      Lesson(
        id: 7,
        title: 'Travel Conversations',
        categoryId: 3,
        description:
            'Develop conversational skills for travel situations. Practice asking for directions, booking hotels, and describing your journey.',
      ),
      Lesson(
        id: 8,
        title: 'Daily Routine Speaking',
        categoryId: 1,
        description:
            'Express your daily activities in English. Learn to describe your morning routine, work schedule, and evening plans fluently.',
      ),
    ];
  }

  final Map<int, IconData> lessonIcons = {
    2: Icons.pets,
    3: Icons.fastfood,
    4: Icons.flight,
  };

  final Map<int, IconData> speakingIcons = {
    5: Icons.pets_outlined,
    6: Icons.restaurant_menu,
    7: Icons.airplanemode_active,
    8: Icons.schedule,
  };

  final Map<int, List<Color>> speakingGradients = {
    5: [Colors.green.shade400, Colors.green.shade600],
    6: [Colors.orange.shade400, Colors.orange.shade600],
    7: [Colors.purple.shade400, Colors.purple.shade600],
    8: [Colors.teal.shade400, Colors.teal.shade600],
  };

  Widget _buildSpeakingLessonCard(Lesson lesson, int index) {
    final isHovering = speakingHoverStates[lesson.id] ?? false;
    final gradient = speakingGradients[lesson.id] ??
        [Colors.blue.shade400, Colors.blue.shade600];

    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 20),
      child: MouseRegion(
        onEnter: (_) => setState(() => speakingHoverStates[lesson.id] = true),
        onExit: (_) => setState(() => speakingHoverStates[lesson.id] = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovering
                  ? [Colors.white, Colors.white]
                  : [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.85)
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering
                  ? gradient[0]
                  : AppColors.brownNormal.withOpacity(0.3),
              width: isHovering ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovering
                    ? gradient[0].withOpacity(0.25)
                    : AppColors.brownNormal.withOpacity(0.08),
                blurRadius: isHovering ? 20 : 10,
                spreadRadius: isHovering ? 2 : 0,
                offset: Offset(0, isHovering ? 12 : 6),
              ),
              BoxShadow(
                color: isHovering
                    ? gradient[1].withOpacity(0.1)
                    : Colors.transparent,
                blurRadius: isHovering ? 40 : 0,
                spreadRadius: isHovering ? -5 : 0,
                offset: Offset(0, isHovering ? 25 : 0),
              ),
            ],
          ),
          transform: Matrix4.identity()
            ..translate(0.0, isHovering ? -4.0 : 0.0)
            ..scale(isHovering ? 1.02 : 1.0),
          child: InkWell(
            onTap: () async {
              try {
                List<SpeakingExercise> exercises = getSampleSpeakingExercises();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeakingPracticeScreen(
                      lessonTitle: lesson.title,
                      lessonId: lesson.id,
                      exercises: exercises,
                    ),
                  ),
                );
              } catch (e) {
                print('Lỗi khi khởi tạo bài luyện nói: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể khởi tạo bài luyện nói')),
                );
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lesson Icon with gradient background
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isHovering
                          ? gradient
                          : [
                              gradient[0].withOpacity(0.2),
                              gradient[1].withOpacity(0.3),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isHovering
                        ? [
                            BoxShadow(
                              color: gradient[0].withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    speakingIcons[lesson.id] ?? Icons.mic_rounded,
                    size: isHovering ? 45 : 40,
                    color: isHovering ? Colors.white : gradient[0],
                  ),
                ),

                const SizedBox(width: 24),

                // Lesson Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        style: AppTextStyles.head3Bold.copyWith(
                          color: isHovering ? gradient[0] : AppColors.brownDark,
                          fontSize: isHovering ? 20 : 18,
                        ),
                        child: Text(
                          lesson.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        style: TextStyle(
                          fontSize: isHovering ? 15 : 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brownNormal.withOpacity(0.85),
                          height: 1.6,
                        ),
                        child: Text(
                          lesson.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Action Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 120,
                  height: 45,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: isHovering ? 1.0 : 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isHovering
                            ? [
                                BoxShadow(
                                  color: gradient[0].withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            try {
                              // Lấy exercises mẫu cho từng lesson (có thể thay bằng logic động sau này)
                              List<SpeakingExercise> exercises = getSampleSpeakingExercises();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpeakingPracticeScreen(
                                    lessonTitle: lesson.title,
                                    lessonId: lesson.id,
                                    exercises: exercises,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print('Lỗi khi khởi tạo bài luyện nói: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Không thể khởi tạo bài luyện nói')),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: isHovering ? 20 : 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Luyện nói',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isHovering ? 14 : 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                        ],
                      ),
                    ),

                    /// CONTENT AREA
                    FadeTransition(
                      opacity: _fadeController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedSkill == 'Bài học') ...[
                            Text('Bài học', style: AppTextStyles.head1Bold),
                            const SizedBox(height: 20),
                            FutureBuilder<List<Lesson>>(
                              future: futureLessons,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                          print(
                                              'Đã bấm vào lesson id: ${lesson.id}');
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
                          ] else if (selectedSkill == 'Từ vựng') ...[
                            Text('Từ vựng', style: AppTextStyles.head1Bold),
                            const SizedBox(height: 20),
                            FutureBuilder<List<Category>>(
                              future: futureCategories,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Lỗi: ${snapshot.error}');
                                } else {
                                  final categories = snapshot.data!;
                                  return Column(
                                    children: categories.map((category) {
                                      return LessonCard(
                                        title: category.name,
                                        description: category.description,
                                        imagePath:
                                            getImageForCategory(category.id),
                                        onTap: () {
                                          print(
                                              'DEBUG: category_id = \'[32m[1m[4m${category.id}\u001b[0m\'');
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
                                final listeningLessons =
                                    getFakeListeningLessons();
                                return Column(
                                  children: listeningLessons
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final lesson = entry.value;
                                    final isHovering =
                                        lessonHoverStates[lesson.id] ?? false;

                                    return AnimatedContainer(
                                        duration: Duration(
                                            milliseconds: 300 + (index * 50)),
                                        curve: Curves.easeOutCubic,
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: MouseRegion(
                                          onEnter: (_) => setState(() =>
                                              lessonHoverStates[lesson.id] =
                                                  true),
                                          onExit: (_) => setState(() =>
                                              lessonHoverStates[lesson.id] =
                                                  false),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOutCubic,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: isHovering
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                                  blurRadius:
                                                      isHovering ? 15 : 8,
                                                  offset: Offset(
                                                      0, isHovering ? 8 : 4),
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                                      color: AppColors
                                                          .brownLight
                                                          .withOpacity(
                                                              isHovering
                                                                  ? 0.3
                                                                  : 0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Icon(
                                                      lessonIcons[lesson.id] ??
                                                          Icons
                                                              .headphones_rounded,
                                                      size:
                                                          isHovering ? 40 : 35,
                                                      color:
                                                          AppColors.brownDark,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 20),

                                                  // Lesson Content
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        AnimatedDefaultTextStyle(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          style: AppTextStyles
                                                              .head3Bold
                                                              .copyWith(
                                                            color: isHovering
                                                                ? AppColors
                                                                    .brownDark
                                                                : AppColors
                                                                    .brownNormal,
                                                          ),
                                                          child: Text(
                                                            lesson.title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          lesson.description,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: AppColors
                                                                .brownNormal
                                                                .withOpacity(
                                                                    0.8),
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
                                                    width: 100,
                                                    height: 40,
                                                    child: isHovering
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 12),
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.blue[
                                                                      400]!,
                                                                  Colors.blue[
                                                                      600]!,
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .blue
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
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  try {
                                                                    final questionsFromApi =
                                                                        await fetchQuestions(
                                                                            lesson.id); // List<Question>
                                                                    final listeningQuestions =
                                                                        convertToListeningQuestions(
                                                                            questionsFromApi);

                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ListeningPracticeScreen(
                                                                          lis_lesson:
                                                                              ListeningLesson(
                                                                            id: lesson.id,
                                                                            title:
                                                                                lesson.title,
                                                                            audioUrl:
                                                                                'audio/speaking_animal.mp3',
                                                                            questions:
                                                                                listeningQuestions, // Truyền đúng kiểu List<ListeningQuestion>
                                                                            transcript:
                                                                                'Animals are amazing creatures that live all around the world. In the jungle, you can find tigers, snakes, monkeys, and colorful parrots.On the farm, there are cows, pigs, chickens, and sheep. In the ocean, dolphins, whales, sharks, and turtles swim freely.Some animals, like cats and dogs, are our pets and live with us at home. Others, like elephants and giraffes, live in the wild or in zoos. Each animal has its own unique features—some have fur, feathers, or scales. They eat different foods and make different sounds.Learning about animals helps us understand nature and how to take care of the world around us.',
                                                                            categoryId:
                                                                                lesson.categoryId,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } catch (e) {
                                                                    print(
                                                                        'Lỗi khi lấy câu hỏi: $e');
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text('Không thể tải câu hỏi')),
                                                                    );
                                                                  }
                                                                },
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    const Center(
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
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      Text(
                                                                        'Bắt đầu',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                          ] else if (selectedSkill == 'Luyện nói') ...[
                            const SizedBox(height: 32),
                            AnimatedBuilder(
                              animation: _fadeController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      0, 20 * (1 - _fadeController.value)),
                                  child: Opacity(
                                    opacity: _fadeController.value,
                                    child: Text(
                                      'Chọn bài luyện nói',
                                      style: AppTextStyles.head1Bold.copyWith(
                                        color: AppColors.brownDark,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Builder(
                              builder: (context) {
                                final speakingLessons =
                                    getFakeSpeakingLessons();
                                return Column(
                                  children: speakingLessons
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final lesson = entry.value;
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.3, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _slideController,
                                        curve: Interval(
                                          index * 0.1,
                                          1.0,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      )),
                                      child: FadeTransition(
                                        opacity: Tween<double>(
                                          begin: 0.0,
                                          end: 1.0,
                                        ).animate(CurvedAnimation(
                                          parent: _slideController,
                                          curve: Interval(
                                            index * 0.1,
                                            1.0,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        )),
                                        child: _buildSpeakingLessonCard(
                                            lesson, index),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ] else ...[
                            Text('Đang chọn: $selectedSkill',
                                style: AppTextStyles.head1Bold),
                            const SizedBox(height: 20),
                            Text(
                                'Chức năng "$selectedSkill" chưa được cài đặt.',
                                style: AppTextStyles.head3Black),
                          ],
                        ],
                      ),
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
}
