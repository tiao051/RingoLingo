import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const LessonCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 884,
      height: 226,
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.brownNormal,
        borderRadius: BorderRadius.circular(20),
        // Optional: shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            // Ảnh giữ nguyên kích thước gốc
            SizedBox(
              width: 564, // Bạn thay đổi width này thành kích thước gốc ảnh của bạn
              height: 226,
              child: Image.asset(
                imagePath,
                fit: BoxFit.none,  // Giữ nguyên kích thước ảnh gốc
                alignment: Alignment.center,
              ),
            ),

            // Phần text bên phải chiếm phần còn lại
            Expanded(
              child: Container(
                color: const Color(0xFFF2E9DE),  // Màu nền mới
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 25, 20),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.head2Bold.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          description,
                          style: AppTextStyles.body,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redNormal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Bắt đầu học',
                              style: AppTextStyles.head2BoldWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
