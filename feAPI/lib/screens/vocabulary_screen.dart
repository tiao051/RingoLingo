import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/category.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/lesson_card.dart';
import 'package:ringolingo_app/widgets/skill_icon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchLessons();
  }

  Future<List<Category>> fetchLessons() async {
    final response = await http.get(Uri.parse('https://localhost:7093/api/category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Category');
    }
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
                    // Search and flag
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
                        children: const [
                          SkillIcon(imagePath: 'assets/images/icon_tu_vung.png', title: 'Từ vựng'),
                          SkillIcon(imagePath: 'assets/images/icon_kiem_tra_1.png', title: 'Kiểm tra', iconSize: 120),
                          SkillIcon(imagePath: 'assets/images/icon_trac_nghiem.png', title: 'Trắc nghiệm'),
                          SkillIcon(imagePath: 'assets/images/icon_luyen_nghe.png', title: 'Luyện nghe'),
                          SkillIcon(imagePath: 'assets/images/icon_noi_tu.png', title: 'Điền từ'),
                          SkillIcon(imagePath: 'assets/images/icon_dung_sai.png', title: 'Đúng/Sai', iconSize: 90),
                        ],
                      ),
                    ),

                    const SizedBox(height: 41),

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
