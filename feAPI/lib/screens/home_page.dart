import 'package:flutter/material.dart';

// TODO: Extract helper widgets into their own files in the widgets folder.
final Widget coViet =
    Image.asset('assets/images/coViet.png', width: 80, height: 80);
final Widget coAnh =
    Image.asset('assets/images/coAnh.png', width: 80, height: 80);
final Widget coNhat =
    Image.asset('assets/images/coNhat.png', width: 80, height: 80);
final Widget coTrung =
    Image.asset('assets/images/coTrung.png', width: 80, height: 80);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Hero Section
            _buildHeroSection(context),
            // Language Selection
            _buildLanguageSelection(),
            // Features Section
            _buildFeaturesSection(),
            // Skills Section
            _buildSkillsSection(),
            // Experience Section
            // _buildExperienceSection(),
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      color: const Color(0xFFD32F2F),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Image.asset(
                'assets/images/ringo_1.png',
                width: 90.13,
                height: 61.45,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const Spacer(),
          // Navigation
          Row(
            children: [
              _buildNavItem('TRANG CHỦ'),
              _buildNavItem('GIỚI THIỆU'),
              _buildNavItem('TÍNH NĂNG'),
              _buildNavItem('TIN TỨC'),
              _buildNavItem('LIÊN HỆ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        ),
      ),
      child: Stack(
        children: [
          // Background decorations
          // Main content
          Center(
            child: Row(
              children: [
                // Left content
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Học ngoại ngữ',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                            height: 1.2,
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'dễ như chơi với RingoLingo',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFA726),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Khám phá thế giới ngôn ngữ với RingoLingo\nPhương pháp học tập hiệu quả và thú vị',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'BẮT ĐẦU NGAY',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFD32F2F),
                                side:
                                    const BorderSide(color: Color(0xFFD32F2F)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'TÌM HIỂU THÊM',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Right placeholder to complete the row
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 80),
                    child: Image.asset(
                      'assets/images/main_img.png',
                      fit: BoxFit.contain,
                      height: 1400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return Container(
      height: 200,
      color: const Color(0xFFF6DCDC),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/union.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  coViet,
                  coTrung,
                  coNhat,
                  coAnh,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return SizedBox(
      width: double.infinity,
      height: 450,
      child: Container(
        color: const Color(0xFFF6DCDC), // Màu nền #F6DCDC
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/intro.png',
          width: 1822,
          height: 2081,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 80),
      color: const Color(0xFFF6DCDC),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6DCDC), Color(0xFFF6DCDC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border(
            top: BorderSide(color: Color(0xFFD32F2F), width: 30.0),
            bottom: BorderSide(color: Color(0xFFD32F2F), width: 30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(00),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: mô tả
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LUYỆN TẬP\nCÁC KỸ NĂNG',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nâng cao kỹ năng ngôn ngữ toàn diện\nvới các bài tập đa dạng và thú vị.\nPhát triển từng kỹ năng một cách\ncân bằng và hiệu quả.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            'assets/images/taoChat.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Right: skill cards
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildSkillCard(
                              'NGHE',
                              'Luyện nghe với\nnội dung thực tế',
                              Icons.headphones),
                          const SizedBox(height: 20),
                          _buildSkillCard(
                              'NÓI', 'Phát âm chuẩn\nvới AI coach', Icons.mic),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildSkillCard('ĐỌC',
                              'Đọc hiểu qua\ncâu chuyện thú vị', Icons.book),
                          const SizedBox(height: 20),
                          _buildSkillCard('VIẾT',
                              'Luyện viết từ cơ bản\nđến nâng cao', Icons.edit),
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
    );
  }

  Widget _buildSkillCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFFD32F2F)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFFF6DCDC),
      width: double.infinity,
      child: Image.asset(
        'assets/images/footer.png',
        fit: BoxFit
            .cover, // Tùy chọn: BoxFit.cover, BoxFit.fitWidth, BoxFit.contain tùy bạn muốn ảnh hiển thị thế nào
      ),
    );
  }
}
