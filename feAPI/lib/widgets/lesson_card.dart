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
      width: 564,
      height: 226,
      margin: EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // Background image container
          Container(
            width: 564,
            height: 226,
            decoration: BoxDecoration(
              color: AppColors.brownNormal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.redNormal.withOpacity(0.8),
                      AppColors.brownNormal.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Decorative pattern on the left
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.redNormal.withOpacity(0.9),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school,
                            size: 80,
                            color: AppColors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    // Content area
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content overlay
          Positioned(
            right: 25,
            top: 0,
            child: Container(
              width: 270,
              height: 226,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.head2Bold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: AppTextStyles.body,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Start button
                  Container(
                    width: 268,
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
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}