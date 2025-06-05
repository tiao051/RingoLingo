import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/artist.dart';

class RightSidebar extends StatefulWidget {
  const RightSidebar({super.key});

  @override
  State<RightSidebar> createState() => _RightSidebarState();
}

class _RightSidebarState extends State<RightSidebar> with TickerProviderStateMixin {
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
    
    // Animations - slide from right to left
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0), // Bắt đầu từ bên phải
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
    final List<Artist> artists = const [
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "Lim Feng",
          username: "@limfeng__"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "Mi Nga",
          username: "@lf.mingahaman"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "MCK",
          username: "@rpt.mckeyyyyy"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "tlinh",
          username: "@lf.tlinh"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "wxrdie",
          username: "@wxrdie102"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "Lâm Minh",
          username: "@lamiinh"),
      Artist(
          imagePath: "assets/images/taoNgoiSao.png",
          displayName: "DEC AO",
          username: "@dec.ao"),
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 320,
          color: const Color(0xFFF2E9DE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top artist with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildTopArtist(),
              ),
              
              const SizedBox(height: 24),
              
              // Friends title with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Bạn bè',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Friends list with staggered animation
              Expanded(
                child: ListView.separated(
                  itemCount: artists.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return AnimatedArtistItem(
                      artist: artists[index],
                      delay: Duration(milliseconds: 100 * index),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Bottom section with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBottomSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopArtist() {
    return EnhancedTopArtist(
      imagePath: 'assets/images/taoNgoiSao.png',
      displayName: 'Wren Evans',
      username: '@wrenevans___',
    );
  }

  Widget _buildBottomSection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/icon_rightbanner_2.png',
            width: 120,
          ),
          const Text(
            'Cố lên, bạn đã đăng nhập được 3 ngày liên tiếp!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 109, 83, 49),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class EnhancedTopArtist extends StatefulWidget {
  final String imagePath;
  final String displayName;
  final String username;

  const EnhancedTopArtist({
    Key? key,
    required this.imagePath,
    required this.displayName,
    required this.username,
  }) : super(key: key);

  @override
  State<EnhancedTopArtist> createState() => _EnhancedTopArtistState();
}

class _EnhancedTopArtistState extends State<EnhancedTopArtist> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: Handle top artist tap
          print('Top artist tapped: ${widget.displayName}');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          transform: isHovered 
              ? (Matrix4.identity()..scale(1.03))
              : Matrix4.identity(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isHovered ? 0.15 : 0.05),
                      blurRadius: isHovered ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.displayName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isHovered ? Colors.black87 : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isHovered ? Colors.black45 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedArtistItem extends StatefulWidget {
  final Artist artist;
  final Duration delay;

  const AnimatedArtistItem({
    Key? key,
    required this.artist,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<AnimatedArtistItem> createState() => _AnimatedArtistItemState();
}

class _AnimatedArtistItemState extends State<AnimatedArtistItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start animation with delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: Handle artist tap
                  print('Artist tapped: ${widget.artist.displayName}');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHovered 
                        ? Colors.white.withOpacity(0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  transform: isHovered 
                      ? (Matrix4.identity()..scale(1.02))
                      : Matrix4.identity(),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isHovered ? 0.1 : 0.04),
                              blurRadius: isHovered ? 8 : 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            widget.artist.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.artist.displayName,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isHovered ? Colors.black87 : Colors.black,
                            ),
                          ),
                          Text(
                            widget.artist.username,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: isHovered ? Colors.black45 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}