import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class LeftSidebar extends StatelessWidget {
  final String activeTab;
  
  const LeftSidebar({Key? key, this.activeTab = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Lấy chiều cao màn hình, trừ đi padding trên + dưới (42 * 2 = 84)
    final sidebarHeight = MediaQuery.of(context).size.height - 84;

    return Container(
      width: 198,
      decoration: BoxDecoration(
        color: AppColors.redNormal,
        borderRadius: BorderRadius.circular(47),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 42),
          child: SizedBox(
            height: sidebarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo + menu (chiếm hết không gian trên)
                Expanded(
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
                      const SizedBox(height: 64),                      // Menu Items
                      _buildMenuItem(
                        context,
                        Image.asset(
                          'assets/images/icon_on_tap.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        'Học bài',
                        isActive: activeTab == 'Học bài',
                      ),
                      _buildMenuItem(
                        context,
                        Image.asset(
                          'assets/images/icon_kiem_tra.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        'Kiểm tra',
                        isActive: activeTab == 'Kiểm tra',
                      ),
                      _buildMenuItem(
                        context,
                        Image.asset(
                          'assets/images/icon_khoa_hoc_2.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        'Khóa học',
                        isActive: activeTab == 'Khóa học',
                      ),
                      _buildMenuItem(
                        context,
                        Image.asset(
                          'assets/images/icon_ho_so.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        'Hồ sơ',
                        isActive: activeTab == 'Hồ sơ',
                      ),
                      _buildMenuItem(
                        context,
                        Image.asset(
                          'assets/images/icon_cai_dat.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        'Cài đặt',
                        isActive: activeTab == 'Cài đặt',
                      ),
                    ],
                  ),
                ),

                // Nút Logout sát đáy, có padding trên + dưới
                Padding(
                  padding: const EdgeInsets.only(bottom: 32, top: 16),
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
      ),
    );  }
  Widget _buildMenuItem(BuildContext context, Widget iconWidget, String title, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: StatefulBuilder(
        builder: (context, setState) {
          return _MenuItemWidget(
            context: context,
            iconWidget: iconWidget,
            title: title,
            isActive: isActive,
            onTap: () => _handleMenuTap(context, title),
          );
        },
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String title) {
    // Chỉ điều hướng nếu không phải thẻ hiện tại
    if (title != activeTab) {
      switch (title) {
        case 'Kiểm tra':
          Navigator.pushReplacementNamed(context, '/quiz');
          break;
        case 'Khóa học':
          Navigator.pushReplacementNamed(context, '/home_word');
          break;
        case 'Học bài':
          // TODO: Thêm route cho màn hình học bài
          break;
        case 'Hồ sơ':
          // TODO: Thêm route cho màn hình hồ sơ  
          break;
        case 'Cài đặt':
          // TODO: Thêm route cho màn hình cài đặt
          break;
      }
    }
  }
}

class _MenuItemWidget extends StatefulWidget {
  final BuildContext context;
  final Widget iconWidget;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItemWidget({
    Key? key,
    required this.context,
    required this.iconWidget,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: 169,
          height: 48,
          transform: isHovered && !widget.isActive 
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? AppColors.redLight 
                : isHovered 
                    ? AppColors.redLight.withOpacity(0.4)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            boxShadow: isHovered && !widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.white.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ]
                : widget.isActive
                    ? [
                        BoxShadow(
                          color: AppColors.redNormal.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Áp dụng màu cho icon dựa trên trạng thái active và hover
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,                transform: isHovered 
                    ? (Matrix4.identity()..scale(1.1))
                    : Matrix4.identity(),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.isActive 
                        ? AppColors.redNormal 
                        : isHovered
                            ? AppColors.redNormal.withOpacity(0.8)
                            : AppColors.white,
                    BlendMode.srcIn,
                  ),
                  child: widget.iconWidget,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  style: widget.isActive
                      ? AppTextStyles.head3Bold
                      : isHovered
                          ? AppTextStyles.head3Bold.copyWith(
                              color: AppColors.redNormal,
                              letterSpacing: 0.2,
                            )
                          : AppTextStyles.head3.copyWith(color: AppColors.white),
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
