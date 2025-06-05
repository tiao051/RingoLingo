import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class LeftSidebar extends StatefulWidget {
  final String activeTab;
  
  const LeftSidebar({Key? key, this.activeTab = ''}) : super(key: key);

  @override
  State<LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends State<LeftSidebar> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarHeight = MediaQuery.of(context).size.height - 84;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.redNormal,
              AppColors.redNormal.withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(47),
          boxShadow: [
            BoxShadow(
              color: AppColors.redNormal.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(3, 3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 42),
            child: SizedBox(
              height: sidebarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildLogoSection(),
                  ),
                  
                  const SizedBox(height: 64),
                  
                  // Menu Items
                  Expanded(
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          'assets/images/icon_on_tap.png',
                          'Học bài',
                          Icons.school,
                          isActive: widget.activeTab == 'Học bài',
                        ),
                        _buildMenuItem(
                          context,
                          'assets/images/icon_kiem_tra.png',
                          'Kiểm tra',
                          Icons.quiz,
                          isActive: widget.activeTab == 'Kiểm tra',
                        ),
                        _buildMenuItem(
                          context,
                          'assets/images/icon_khoa_hoc_2.png',
                          'Khóa học',
                          Icons.book,
                          isActive: widget.activeTab == 'Khóa học',
                        ),
                        _buildMenuItem(
                          context,
                          'assets/images/icon_ho_so.png',
                          'Hồ sơ',
                          Icons.person,
                          isActive: widget.activeTab == 'Hồ sơ',
                        ),
                        _buildMenuItem(
                          context,
                          'assets/images/icon_cai_dat.png',
                          'Cài đặt',
                          Icons.settings,
                          isActive: widget.activeTab == 'Cài đặt',
                        ),
                      ],
                    ),
                  ),

                  // Logout button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildLogoutButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 180,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/ringo_1.png',
          fit: BoxFit.contain,
          width: 80,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Ringo\nlingo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String assetPath,
    String title,
    IconData fallbackIcon, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: EnhancedMenuItem(
        assetPath: assetPath,
        title: title,
        fallbackIcon: fallbackIcon,
        isActive: isActive,
        onTap: () => _handleMenuTap(context, title),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16, left: 14, right: 14),
      child: EnhancedLogoutButton(
        onTap: () {
          // TODO: Handle logout
          print('Logout tapped');
        },
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String title) {
    if (title != widget.activeTab) {
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
          Navigator.pushReplacementNamed(context, '/hoSo');
          break;
        case 'Cài đặt':
          Navigator.pushReplacementNamed(context, '/caidat');
          break;
      }
    }
  }
}

class EnhancedMenuItem extends StatefulWidget {
  final String assetPath;
  final String title;
  final IconData fallbackIcon;
  final bool isActive;
  final VoidCallback onTap;

  const EnhancedMenuItem({
    Key? key,
    required this.assetPath,
    required this.title,
    required this.fallbackIcon,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EnhancedMenuItem> createState() => _EnhancedMenuItemState();
}

class _EnhancedMenuItemState extends State<EnhancedMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: double.infinity,
          height: 56,
          transform: isHovered && !widget.isActive 
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? AppColors.redLight
                : isHovered 
                    ? AppColors.redLight.withOpacity(0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            border: widget.isActive 
                ? Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  )
                : null,
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.redNormal.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : isHovered
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: isHovered 
                      ? (Matrix4.identity()..scale(1.1))
                      : Matrix4.identity(),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: _buildIcon(),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Title
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.isActive
                          ? AppColors.redNormal
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: widget.isActive 
                          ? FontWeight.w700 
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Active indicator
                if (widget.isActive)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.redNormal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      widget.assetPath,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      color: widget.isActive 
          ? AppColors.redNormal 
          : Colors.white,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          widget.fallbackIcon,
          size: 24,
          color: widget.isActive 
              ? AppColors.redNormal 
              : Colors.white,
        );
      },
    );
  }
}

class EnhancedLogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const EnhancedLogoutButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EnhancedLogoutButton> createState() => _EnhancedLogoutButtonState();
}

class _EnhancedLogoutButtonState extends State<EnhancedLogoutButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 64,
          transform: isHovered 
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isHovered
                ? AppColors.redLight.withOpacity(0.8)
                : AppColors.redLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: AppColors.redLight.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: isHovered 
                  ? (Matrix4.identity()..scale(1.1))
                  : Matrix4.identity(),
              child: Icon(
                Icons.logout_rounded,
                color: isHovered 
                    ? AppColors.redNormal 
                    : AppColors.redNormal.withOpacity(0.8),
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}