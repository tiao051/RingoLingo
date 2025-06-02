import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class LeftSidebar extends StatelessWidget {
 @override
Widget build(BuildContext context) {
  return Container(
    width: 198,
    decoration: BoxDecoration(
      color: AppColors.redNormal,
      borderRadius: BorderRadius.circular(47),
    ),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: Column(
          children: [
            // Logo
            Container(
              width: 89,
              height: 61,
              decoration: BoxDecoration(
                color: Colors.transparent, 
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ringo_1.png',  
                  fit: BoxFit.contain,         
                ),
              ),
            ),
            const SizedBox(height: 64),

            // Menu Items
            _buildMenuItem(
              Image.asset(
                'assets/images/icon_on_tap.png',
                width: 28, 
                height: 28,
                fit: BoxFit.contain,
              ),
              'Học bài',
            ),
            _buildMenuItem(
              Image.asset(
                'assets/images/icon_kiem_tra.png',
                width: 28,   
                height: 28,
                fit: BoxFit.contain,
              ),
              'Kiểm tra',
            ),
            _buildMenuItem(
              Image.asset(
                'assets/images/icon_khoa_hoc_2.png',
                width: 28, 
                height: 28,
                fit: BoxFit.contain,
              ),
              'Khóa học',
              isActive: true), // Active menu item
            _buildMenuItem(
              Image.asset(
                'assets/images/icon_ho_so.png',
                width: 28, 
                height: 28,
                fit: BoxFit.contain,
              ),
              'Hồ sơ',
            ),
            _buildMenuItem(
              Image.asset(
                'assets/images/icon_cai_dat.png',
                width: 28,  
                height: 28,
                fit: BoxFit.contain,
              ),
              'Cài đặt',
            ),

            const SizedBox(height: 32), 

            // Logout Button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                onTap: () {
                  // TODO: Handle logout
                },
                child: Container(
                  width: 169,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.redLight,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout,
                      color: AppColors.redNormal,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


    Widget _buildMenuItem(Widget iconWidget, String title, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: GestureDetector(
        onTap: () {
          // TODO: Handle menu tap
        },
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? AppColors.redLight : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              iconWidget,
              const SizedBox(width: 12),
              Text(
                title,
                style: isActive
                    ? AppTextStyles.head3Bold
                    : AppTextStyles.head3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
