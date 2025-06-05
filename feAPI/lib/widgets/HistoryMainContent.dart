import 'package:flutter/material.dart';

class HistoryMainContent extends StatefulWidget {
  const HistoryMainContent({super.key});

  @override
  State<HistoryMainContent> createState() => _HistoryMainContentState();
}

class _HistoryMainContentState extends State<HistoryMainContent> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFD5B893),
                const Color(0xFFD5B893).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Enhanced Header
              _buildEnhancedHeader(isTablet),
              
              // Enhanced Tab bar
              _buildEnhancedTabBar(isTablet),
              
              // Tab content with animation
              Expanded(
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildActivityTab(isTablet),
                        _buildStatisticsTab(isTablet),
                        _buildAchievementsTab(isTablet),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD5B893),
            const Color(0xFFD5B893).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF921111).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.history,
              color: const Color(0xFF921111),
              size: isTablet ? 32 : 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lịch sử học tập',
                  style: TextStyle(
                    fontSize: isTablet ? 32 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF921111),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Theo dõi tiến độ học tập của bạn',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: const Color(0xFF921111).withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTabBar(bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 20, 
        vertical: isTablet ? 24 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.grey[100]!.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF921111), Color(0xFFB91A1A)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF921111).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[700],
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTablet ? 16 : 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 15 : 13,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.timeline, size: 20),
            text: 'Hoạt động',
          ),
          Tab(
            icon: Icon(Icons.analytics, size: 20),
            text: 'Thống kê',
          ),
          Tab(
            icon: Icon(Icons.emoji_events, size: 20),
            text: 'Thành tích',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(bool isTablet) {
    final activities = [
      {
        'date': '18/05/2025',
        'time': '09:30',
        'title': 'Đã hoàn thành Quiz',
        'subtitle': 'Chủ đề: Giao tiếp cơ bản',
        'score': '4/5',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'date': '18/05/2025',
        'time': '08:45',
        'title': 'Đã học Flashcard',
        'subtitle': 'Chủ đề: Giao tiếp cơ bản',
        'count': '10 từ vựng',
        'icon': Icons.style,
        'color': Colors.green,
      },
      {
        'date': '17/05/2025',
        'time': '19:15',
        'title': 'Đã hoàn thành Quiz',
        'subtitle': 'Chủ đề: Du lịch',
        'score': '3/5',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'date': '17/05/2025',
        'time': '15:30',
        'title': 'Đã thêm chủ đề mới',
        'subtitle': 'Chủ đề: Công nghệ',
        'icon': Icons.add_circle,
        'color': Colors.purple,
      },
      {
        'date': '16/05/2025',
        'time': '20:00',
        'title': 'Đã học Flashcard',
        'subtitle': 'Chủ đề: Du lịch',
        'count': '15 từ vựng',
        'icon': Icons.style,
        'color': Colors.green,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final bool showDateHeader = index == 0 ||
            activity['date'] != activities[index - 1]['date'];

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, _) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) ...[
                      if (index > 0) SizedBox(height: isTablet ? 24 : 16),
                      _buildDateHeader(activity['date'] as String, isTablet),
                      SizedBox(height: isTablet ? 20 : 16),
                    ],
                    _buildActivityCard(activity, isTablet),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateHeader(String date, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 16, 
            vertical: isTablet ? 12 : 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.grey[100]!.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 16 : 14,
              color: const Color(0xFF921111),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF921111).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (activity['color'] as Color).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 18),
            child: Row(
              children: [
                // Enhanced activity icon
                Container(
                  width: isTablet ? 65 : 55,
                  height: isTablet ? 65 : 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (activity['color'] as Color).withOpacity(0.1),
                        (activity['color'] as Color).withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (activity['color'] as Color).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: isTablet ? 30 : 26,
                  ),
                ),
                SizedBox(width: isTablet ? 20 : 16),

                // Activity details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              activity['title'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 18 : 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activity['time'] as String,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        activity['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 10),

                      // Additional info with enhanced styling
                      if (activity.containsKey('score'))
                        _buildInfoChip(
                          icon: Icons.star,
                          text: 'Điểm: ${activity['score']}',
                          color: Colors.amber[700]!,
                          isTablet: isTablet,
                        ),
                      if (activity.containsKey('count'))
                        _buildInfoChip(
                          icon: Icons.book,
                          text: activity['count'] as String,
                          color: Colors.green[700]!,
                          isTablet: isTablet,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isTablet ? 18 : 16,
            color: color,
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 15 : 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab(bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          // Weekly Progress with enhanced design
          _buildEnhancedStatCard(
            title: 'Tiến độ học tập trong tuần',
            icon: Icons.trending_up,
            isTablet: isTablet,
            child: _buildWeeklyProgress(isTablet),
          ),
          SizedBox(height: isTablet ? 24 : 16),

          // Vocabulary Progress
          _buildEnhancedStatCard(
            title: 'Từ vựng đã học',
            icon: Icons.book,
            isTablet: isTablet,
            child: _buildVocabularyProgress(isTablet),
          ),
          SizedBox(height: isTablet ? 24 : 16),

          // Quiz Performance
          _buildEnhancedStatCard(
            title: 'Hiệu suất Quiz',
            icon: Icons.quiz,
            isTablet: isTablet,
            child: _buildQuizPerformance(isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isTablet,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, _) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF921111).withOpacity(0.1),
                          const Color(0xFF921111).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF921111),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: isTablet ? 24 : 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF921111),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklyProgress(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          Container(
            height: isTablet ? 250 : 200,
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final heights = [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.2];
                final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                final isToday = index == 5;

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 800 + (index * 100)),
                  tween: Tween(begin: 0.0, end: heights[index]),
                  builder: (context, value, _) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: isTablet ? 40 : 30,
                            margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 6 : 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isToday
                                    ? [
                                        const Color(0xFF921111),
                                        const Color(0xFF921111).withOpacity(0.7)
                                      ]
                                    : [
                                        const Color(0xFF921111).withOpacity(0.4),
                                        const Color(0xFF921111).withOpacity(0.6)
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF921111).withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            height: (isTablet ? 180 : 150) * value,
                          ),
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? const Color(0xFF921111) : Colors.grey[700],
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey[300]!,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEnhancedStatItem(
                icon: Icons.calendar_today,
                value: '7',
                label: 'Ngày liên tiếp',
                color: const Color(0xFF921111),
                isTablet: isTablet,
              ),
              _buildEnhancedStatItem(
                icon: Icons.timer,
                value: '5.2h',
                label: 'Thời gian học',
                color: Colors.blue,
                isTablet: isTablet,
              ),
              _buildEnhancedStatItem(
                icon: Icons.trending_up,
                value: '+15%',
                label: 'Tăng trưởng',
                color: Colors.green,
                isTablet: isTablet,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isTablet ? 24 : 20,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 13 : 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyProgress(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildEnhancedProgressCircle(
                  value: 0.6,
                  centerText: '124',
                  subText: '/ 220',
                  label: 'Từ vựng',
                  color: const Color(0xFF921111),
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 32 : 20),
              Expanded(
                child: _buildEnhancedProgressCircle(
                  value: 0.3,
                  centerText: '3',
                  subText: '/ 10',
                  label: 'Chủ đề',
                  color: Colors.orange,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 32 : 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Đã học', Colors.green, isTablet),
              _buildLegendItem('Đang học', Colors.orange, isTablet),
              _buildLegendItem('Chưa học', Colors.grey, isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedProgressCircle({
    required double value,
    required String centerText,
    required String subText,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: value),
      builder: (context, animatedValue, _) {
        return Column(
          children: [
            SizedBox(
              height: isTablet ? 150 : 120,
              width: isTablet ? 150 : 120,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: isTablet ? 130 : 100,
                      width: isTablet ? 130 : 100,
                      child: CircularProgressIndicator(
                        value: animatedValue,
                        strokeWidth: isTablet ? 12 : 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: centerText,
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                            children: [
                              TextSpan(
                                text: subText,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(animatedValue * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isTablet ? 16 : 12,
            height: isTablet ? 16 : 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPerformance(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEnhancedStatItem(
                icon: Icons.check_circle,
                value: '86%',
                label: 'Tỉ lệ đúng',
                color: Colors.green,
                isTablet: isTablet,
              ),
              _buildEnhancedStatItem(
                icon: Icons.quiz,
                value: '23',
                label: 'Quiz đã làm',
                color: const Color(0xFF921111),
                isTablet: isTablet,
              ),
              _buildEnhancedStatItem(
                icon: Icons.speed,
                value: '45s',
                label: 'Thời gian TB',
                color: Colors.orange,
                isTablet: isTablet,
              ),
            ],
          ),
          SizedBox(height: isTablet ? 32 : 24),
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[50]!,
                  Colors.grey[100]!,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Chủ đề Quiz tốt nhất',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18 : 16,
                    color: const Color(0xFF921111),
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                ...List.generate(3, (index) {
                  final topics = [
                    {'topic': 'Giao tiếp cơ bản', 'score': '92%', 'color': Colors.green},
                    {'topic': 'Du lịch', 'score': '78%', 'color': const Color(0xFF921111)},
                    {'topic': 'Công nghệ', 'score': '65%', 'color': Colors.orange},
                  ];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 200)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, _) {
                      return Transform.translate(
                        offset: Offset(100 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildQuizPerformanceItem(
                            topic: topics[index]['topic'] as String,
                            score: topics[index]['score'] as String,
                            color: topics[index]['color'] as Color,
                            isTablet: isTablet,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPerformanceItem({
    required String topic,
    required String score,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              topic,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 10,
              vertical: isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(bool isTablet) {
    final achievements = [
      {
        'title': 'Ngày đầu tiên',
        'description': 'Hoàn thành bài học đầu tiên',
        'icon': Icons.star,
        'color': const Color(0xFF921111),
        'completed': true,
        'date': '11/05/2025',
      },
      {
        'title': 'Học liên tục 7 ngày',
        'description': 'Học tập 7 ngày liên tục không gián đoạn',
        'icon': Icons.calendar_today,
        'color': Colors.green,
        'completed': true,
        'date': '17/05/2025',
      },
      {
        'title': 'Người học chăm chỉ',
        'description': 'Hoàn thành 10 bài Quiz',
        'icon': Icons.quiz,
        'color': Colors.orange,
        'completed': true,
        'date': '17/05/2025',
      },
      {
        'title': 'Bậc thầy từ vựng',
        'description': 'Học 100 từ vựng mới',
        'icon': Icons.book,
        'color': Colors.purple,
        'completed': true,
        'date': '18/05/2025',
      },
      {
        'title': 'Học liên tục 30 ngày',
        'description': 'Học tập 30 ngày liên tục không gián đoạn',
        'icon': Icons.calendar_today,
        'color': Colors.amber,
        'completed': false,
        'progress': 0.23,
      },
      {
        'title': 'Thông thạo 5 chủ đề',
        'description': 'Hoàn thành 100% từ vựng trong 5 chủ đề',
        'icon': Icons.category,
        'color': Colors.teal,
        'completed': false,
        'progress': 0.6,
      },
      {
        'title': 'Điểm số hoàn hảo',
        'description': 'Đạt điểm tuyệt đối trong 3 bài Quiz liên tiếp',
        'icon': Icons.emoji_events,
        'color': Colors.red,
        'completed': false,
        'progress': 0.33,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final bool isCompleted = achievement['completed'] as bool;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 150)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, _) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isCompleted
                          ? [
                              Colors.white,
                              (achievement['color'] as Color).withOpacity(0.03),
                            ]
                          : [
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompleted
                          ? (achievement['color'] as Color).withOpacity(0.3)
                          : Colors.grey[300]!,
                      width: isCompleted ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isCompleted
                            ? (achievement['color'] as Color).withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: isCompleted ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    child: Row(
                      children: [
                        // Enhanced achievement icon
                        Container(
                          width: isTablet ? 80 : 65,
                          height: isTablet ? 80 : 65,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (achievement['color'] as Color).withOpacity(0.2),
                                (achievement['color'] as Color).withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: achievement['color'] as Color,
                              width: isCompleted ? 3 : 2,
                            ),
                            boxShadow: isCompleted
                                ? [
                                    BoxShadow(
                                      color: (achievement['color'] as Color)
                                          .withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  achievement['icon'] as IconData,
                                  color: achievement['color'] as Color,
                                  size: isTablet ? 36 : 30,
                                ),
                              ),
                              if (isCompleted)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: isTablet ? 16 : 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: isTablet ? 20 : 16),

                        // Achievement details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement['title'] as String,
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted
                                      ? const Color(0xFF921111)
                                      : Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: isTablet ? 8 : 6),
                              Text(
                                achievement['description'] as String,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: isTablet ? 16 : 12),

                              // Progress or completion date
                              if (isCompleted)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 12 : 10,
                                    vertical: isTablet ? 8 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.green[700],
                                        size: isTablet ? 16 : 14,
                                      ),
                                      SizedBox(width: isTablet ? 6 : 4),
                                      Text(
                                        'Đạt được: ${achievement['date']}',
                                        style: TextStyle(
                                          fontSize: isTablet ? 14 : 12,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tiến độ:',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${((achievement['progress'] as double) * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: achievement['color'] as Color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isTablet ? 8 : 6),
                                    TweenAnimationBuilder<double>(
                                      duration: Duration(
                                          milliseconds: 1000 + (index * 200)),
                                      tween: Tween(
                                          begin: 0.0,
                                          end: achievement['progress'] as double),
                                      builder: (context, animatedProgress, _) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: (achievement['color']
                                                        as Color)
                                                    .withOpacity(0.2),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: LinearProgressIndicator(
                                            value: animatedProgress,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              achievement['color'] as Color,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            minHeight: isTablet ? 8 : 6,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}