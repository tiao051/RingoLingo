import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            /// LEFT SIDEBAR - 20%
            Expanded(
              flex: 2,
              child: LeftSidebar(activeTab: 'Kiểm tra'),
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
                          'Kiểm tra',
                          style: AppTextStyles.head1Bold,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Quiz content placeholder
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.quiz,
                            size: 100,
                            color: AppColors.redNormal,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Chức năng kiểm tra',
                            style: AppTextStyles.head2Bold.copyWith(
                              color: AppColors.redNormal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Đây là nơi bạn có thể kiểm tra kiến thức đã học.',
                            style: AppTextStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Sắp có',
                                  style: AppTextStyles.head3Bold.copyWith(
                                    color: AppColors.redNormal,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '• Kiểm tra trắc nghiệm\n• Kiểm tra nghe\n• Kiểm tra viết',
                                  style: AppTextStyles.body,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
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
