import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/category.dart';
import 'package:ringolingo_app/models/lesson.dart';
import 'package:ringolingo_app/services/category_service.dart';
import 'package:ringolingo_app/services/lesson_service.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/lesson_card.dart';
import 'package:ringolingo_app/widgets/skill_icon.dart';

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
    futureLessons = null;
  }

  void onSkillTap(String skill) {
    setState(() {
      selectedSkill = skill;
      if (skill == 'Từ vựng') {
        futureCategories = fetchCategories();
      } else if (skill == 'Kiểm tra') {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeftSidebar(),
            const SizedBox(width: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search + Avatar
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
                            child: Padding(
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
                                        hintStyle: TextStyle(color: AppColors.brownDark),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          width: 110,
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

                    const SizedBox(height: 41),

                    // Skill Icons
                    SizedBox(
                      height: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkillIcon(
                            imagePath: 'assets/images/icon_tu_vung.png',
                            title: 'Từ vựng',
                            onTap: () => onSkillTap('Từ vựng'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_kiem_tra_1.png',
                            title: 'Kiểm tra',
                            iconSize: 120,
                            onTap: () => onSkillTap('Kiểm tra'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_trac_nghiem.png',
                            title: 'Trắc nghiệm',
                            onTap: () => onSkillTap('Trắc nghiệm'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_luyen_nghe.png',
                            title: 'Luyện nghe',
                            onTap: () => onSkillTap('Luyện nghe'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_noi_tu.png',
                            title: 'Điền từ',
                            onTap: () => onSkillTap('Điền từ'),
                          ),
                          SkillIcon(
                            imagePath: 'assets/images/icon_dung_sai.png',
                            title: 'Đúng/Sai',
                            iconSize: 90,
                            onTap: () => onSkillTap('Đúng/Sai'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 41),

                    // Content by Skill
                    if (selectedSkill == 'Từ vựng') ...[
                      Text('Từ vựng', style: AppTextStyles.head1Bold),
                      const SizedBox(height: 30),
                      FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
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
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ] else if (selectedSkill == 'Kiểm tra') ...[
                      Text('Kiểm tra', style: AppTextStyles.head1Bold),
                      const SizedBox(height: 30),
                      futureLessons == null
                          ? Center(child: Text('Đang tải dữ liệu...'))
                          : FutureBuilder<List<Lesson>>(
                              future: futureLessons,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Lỗi: ${snapshot.error}');
                                } else {
                                  final lessons = snapshot.data!;
                                  return Column(
                                    children: lessons.map((lesson) {
                                      return LessonCard(
                                        title: lesson.title,
                                        description: lesson.description ?? '',
                                        imagePath: 'assets/images/icon_trac_nghiem.png',
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                    ] else ...[
                      Text('Đang chọn: $selectedSkill', style: AppTextStyles.head1Bold),
                      const SizedBox(height: 20),
                      Text('Chức năng "$selectedSkill" chưa được cài đặt.', style: AppTextStyles.head3Black),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
