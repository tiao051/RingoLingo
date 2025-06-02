import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/lesson_card.dart';
import '../widgets/skill_icon.dart';

class VocabularyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Sidebar
            LeftSidebar(),
            
            SizedBox(width: 24),
            
            // Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with search bar and flag
                  Row(
                    children: [
                      // Search bar
                      Expanded(
                        child: Container(
                          height: 83,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.brownNormal),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: AppColors.brownDark),
                                SizedBox(width: 16),
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
                      
                      SizedBox(width: 24),
                      
                      // Flag/Language selector
                      Container(
                        width: 130,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.brownNormal,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(color: Colors.red),
                                ),
                                Container(
                                  width: 20,
                                  child: Column(
                                    children: List.generate(13, (index) => 
                                      Expanded(
                                        child: Container(
                                          color: index % 2 == 0 ? Colors.red : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  color: Colors.blue,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(9, (index) => 
                                        Icon(Icons.star, color: Colors.white, size: 3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 41),
                  
                  // Skills Icons Row
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SkillIcon(imagePath: 'assets/images/icon_tu_vung.png', title: 'Từ vựng'),
                      SkillIcon(
                        imagePath: 'assets/images/icon_kiem_tra_1.png', 
                        title: 'Kiểm tra',
                        width: 130,
                        height: 260,
                        iconSize: 60,
                      ),
                      SkillIcon(imagePath: 'assets/images/icon_trac_nghiem.png', title: 'Trắc nghiệm'),
                      SkillIcon(imagePath: 'assets/images/icon_luyen_nghe.png', title: 'Luyện nghe'),
                      SkillIcon(imagePath: 'assets/images/icon_noi_tu.png', title: 'Nối từ'),
                      SkillIcon(imagePath: 'assets/images/icon_dien_tu.png', title: 'Điền từ'),
                      SkillIcon(
                        imagePath: 'assets/images/icon_dung_sai.png', 
                        title: 'Đúng/Sai',
                        width: 100,
                        height: 270,
                        iconSize: 80,
                      ),
                    ],
                  ),


                  SizedBox(height: 41),
                  
                  // Vocabulary Title
                  Text(
                    'Từ vựng',
                    style: AppTextStyles.head1Bold,
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Lesson Cards
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LessonCard(
                            title: 'Thì hiện tại đơn',
                            description: 'Khởi động ngữ pháp bằng một trong thì cơ bản trong tiếng anh, thì hiện tại là một trong những thì quan trọng nhất trong tiếng anh.',
                            imagePath: 'assets/images/lesson1.png',
                          ),
                          LessonCard(
                            title: 'Thì hiện tại đơn',
                            description: 'Khởi động ngữ pháp bằng một trong thì cơ bản trong tiếng anh, thì hiện tại là một trong những thì quan trọng nhất trong tiếng anh.',
                            imagePath: 'assets/images/lesson2.png',
                          ),
                          LessonCard(
                            title: 'Thì hiện tại đơn',
                            description: 'Khởi động ngữ pháp bằng một trong thì cơ bản trong tiếng anh, thì hiện tại là một trong những thì quan trọng nhất trong tiếng anh.',
                            imagePath: 'assets/images/lesson3.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}