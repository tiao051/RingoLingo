import 'package:flutter/material.dart';

class HocTuVungSidebar extends StatelessWidget {
  const HocTuVungSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rectangle 63 (Sidebar background)
        Positioned(
          left: 20,
          top: 24,
          child: Container(
            width: 198,
            height: 976,
            decoration: BoxDecoration(
              color: const Color(0xFFC21717),
              borderRadius: BorderRadius.circular(47),
            ),
          ),
        ),
        // Logo white
        Positioned(
          left: 74,
          top: 66,
          child: SizedBox(
            width: 89,
            height: 61,
            child: Image.asset(
              'assets/images/Untitled-1.png', // Đổi tên file nếu cần
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Rectangle 87 (active menu background)
        Positioned(
          left: 34,
          top: 331,
          child: Container(
            width: 169,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFECB7B7),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        // Frame 21 (Ôn tập)
        Positioned(
          left: 46,
          top: 215,
          child: Row(
            children: [
              // Vertical split icon placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.repeat, color: Color(0xFFC21717)),
              ),
              const SizedBox(width: 5),
              const Text(
                'Ôn tập',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Frame 23 (Sổ tay)
        Positioned(
          left: 50,
          top: 275,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book, color: Color(0xFFC21717)),
              ),
              const SizedBox(width: 5),
              const Text(
                'Sổ tay',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Frame 24 (Khóa học)
        Positioned(
          left: 50,
          top: 337,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_copy, color: Color(0xFFC21717)),
              ),
              const SizedBox(width: 9),
              const Text(
                'Khóa học',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFFC21717),
                ),
              ),
            ],
          ),
        ),
        // Frame 22 (Hồ sơ)
        Positioned(
          left: 50,
          top: 399,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_circle, color: Color(0xFFC21717)),
              ),
              const SizedBox(width: 9),
              const Text(
                'Hồ sơ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Frame 25 (Cài đặt)
        Positioned(
          left: 49,
          top: 459,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.settings, color: Color(0xFFC21717)),
              ),
              const SizedBox(width: 6),
              const Text(
                'Cài đặt',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Frame 26 (Logout)
        Positioned(
          left: 34,
          top: 923,
          child: Container(
            width: 169,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFECB7B7),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC21717),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
