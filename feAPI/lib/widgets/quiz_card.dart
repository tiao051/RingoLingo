import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final int questionCount;
  final String difficulty;
  final VoidCallback? onTap;

  const QuizCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.questionCount,
    required this.difficulty,
    this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50); // Green
      case 'medium':
        return const Color(0xFFFF9800); // Orange
      case 'hard':
        return const Color(0xFFF44336); // Red
      default:
        return AppColors.brownNormal;
    }
  }

  String _getDifficultyText() {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Dễ';
      case 'medium':
        return 'Trung bình';
      case 'hard':
        return 'Khó';
      default:
        return 'Không xác định';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.6;

    return Container(
      width: cardWidth,
      height: 240,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.brownNormal,
        borderRadius: BorderRadius.circular(20),
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
            SizedBox(
              width: cardWidth * 0.6, // 60% cho ảnh
              height: 240,
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Difficulty badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _getDifficultyText(),
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Question count badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$questionCount câu',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF2E9DE),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 25, 20),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz,
                          size: 40,
                          color: AppColors.redNormal,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: AppTextStyles.head2Bold.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: AppTextStyles.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redNormal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Bắt đầu',
                                  style: AppTextStyles.head3Bold.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
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
