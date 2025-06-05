import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class caidat extends StatefulWidget {
  @override
  _caidat createState() => _caidat();
}

class _caidat extends State<caidat> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Thời gian gửi mail nhắc học
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  bool _isNotificationEnabled = true;
  List<String> _selectedDays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 700,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFF8E1),
                      Color(0xFFFFFDE7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4CAF50).withOpacity(0.2),
                                  Color(0xFF4CAF50).withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Color(0xFF4CAF50),
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cài đặt thông báo',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4033),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tùy chỉnh thời gian nhắc học của bạn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4B4033).withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close,
                              color: Color(0xFF4B4033).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Enable/Disable Switch
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(
                            color: Color(0xFF4CAF50).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF4CAF50),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Bật thông báo nhắc học',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4B4033),
                                ),
                              ),
                            ),
                            Switch(
                              value: _isNotificationEnabled,
                              onChanged: (value) {
                                setDialogState(() {
                                  _isNotificationEnabled = value;
                                });
                              },
                              activeColor: Color(0xFF4CAF50),
                              activeTrackColor: Color(0xFF4CAF50).withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      
                      if (_isNotificationEnabled) ...[
                        SizedBox(height: 20),
                        
                        // Time Picker
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(
                              color: Color(0xFFFFCC80).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Color(0xFFFFCC80),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Thời gian gửi mail',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B4033),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTime,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Color(0xFFFFCC80),
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Color(0xFF4B4033),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null && picked != _selectedTime) {
                                    setDialogState(() {
                                      _selectedTime = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFFCC80).withOpacity(0.1),
                                    border: Border.all(
                                      color: Color(0xFFFFCC80).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_selectedTime.format(context)}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4B4033),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Color(0xFFFFCC80),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Days Selection
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(
                              color: Color(0xFF2196F3).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF2196F3),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Ngày trong tuần',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B4033),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'
                                ].map((day) {
                                  bool isSelected = _selectedDays.contains(day);
                                  return GestureDetector(
                                    onTap: () {
                                      setDialogState(() {
                                        if (isSelected) {
                                          _selectedDays.remove(day);
                                        } else {
                                          _selectedDays.add(day);
                                        }
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: isSelected 
                                          ? Color(0xFF2196F3)
                                          : Color(0xFF2196F3).withOpacity(0.1),
                                        border: Border.all(
                                          color: Color(0xFF2196F3).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: isSelected 
                                            ? Colors.white 
                                            : Color(0xFF4B4033),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      SizedBox(height: 30),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.grey.withOpacity(0.1),
                              ),
                              child: Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Color(0xFF4B4033).withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              
onPressed: () async {
  try {
    final url = Uri.parse('https://localhost:7093/api/Reminder/send-now');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": "nguyenminhtho0503@gmail.com"}),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Cập nhật state chính nếu cần
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu cài đặt thành công!'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu cài đặt: ${response.statusCode}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi kết nối: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Color(0xFF4CAF50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Lưu cài đặt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhancedOptionsList(List<Map<String, dynamic>> options) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> option = entry.value;
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() {}),
                    onExit: (_) => setState(() {}),
                    child: GestureDetector(
                      onTap: () {
                        // Xử lý khi bấm vào option
                        if (option["title"] == "Thông báo") {
                          _showNotificationDialog();
                        } else {
                          print('Selected: ${option["title"]}');
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(
                            color: (option["color"] as Color).withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: (option["color"] as Color).withOpacity(0.1),
                              ),
                              child: Icon(
                                option["icon"] as IconData,
                                color: option["color"] as Color,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option["title"] as String,
                                style: TextStyle(
                                  color: Color(0xFF4B4033),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Color(0xFF4B4033).withOpacity(0.4),
                              size: 18,
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
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT SIDEBAR - 20%
            Expanded(
              flex: 2,
              child: LeftSidebar(activeTab: 'Cài đặt'),
            ),

            const SizedBox(width: 16),

            /// MAIN CONTENT - 60% with ScrollView
            Expanded(
              flex: 6,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section với animation
                              _buildHeaderSection(),
                              
                              SizedBox(height: 24),
                              
                              // Settings Cards
                              _buildCustomizationCard(),
                              SizedBox(height: 20),
                              
                              _buildPrivacyCard(),
                              SizedBox(height: 20),
                              
                              _buildSecurityCard(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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

  Widget _buildHeaderSection() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/qq5kdqk5_expires_30_days.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cài đặt tài khoản",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4033),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Quản lý thông tin cá nhân",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4B4033).withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildAnimatedButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print('Pressed');
          // Add haptic feedback
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFD5B893),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 119,
            height: 71,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/b967hy5x_expires_30_days.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationCard() {
    return _buildAnimatedSettingsCard(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFCC80).withOpacity(0.3),
                          Color(0xFFFFB74D).withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFFFFCC80).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          color: Color(0xFFFFCC80),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tùy chỉnh",
                          style: TextStyle(
                            color: Color(0xFFFFCC80),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Cá nhân hóa trải nghiệm của bạn",
                    style: TextStyle(
                      color: Color(0xFF4B4033).withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            flex: 2,
            child: _buildEnhancedOptionsList([
              {"title": "Thông báo", "icon": Icons.notifications_outlined, "color": Color(0xFF4CAF50)},
              {"title": "Trợ năng", "icon": Icons.accessibility_outlined, "color": Color(0xFF2196F3)},
              {"title": "File phương tiện", "icon": Icons.folder_outlined, "color": Color(0xFF9C27B0)},
              {"title": "Giao diện", "icon": Icons.desktop_windows_outlined, "color": Color(0xFFFF9800)},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return _buildAnimatedSettingsCard(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4B4033).withOpacity(0.15),
                          Color(0xFF4B4033).withOpacity(0.08),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFF4B4033).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.security_outlined,
                          color: Color(0xFF4B4033),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Quyền riêng tư",
                          style: TextStyle(
                            color: Color(0xFF4B4033),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Kiểm soát ai có thể xem thông tin của bạn",
                    style: TextStyle(
                      color: Color(0xFF4B4033).withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            flex: 2,
            child: _buildEnhancedOptionsList([
              {"title": "Bài viết", "icon": Icons.article_outlined, "color": Color(0xFF673AB7)},
              {"title": "Trang cá nhân", "icon": Icons.person_outline, "color": Color(0xFF00BCD4)},
              {"title": "Bạn bè", "icon": Icons.people_outline, "color": Color(0xFF4CAF50)},
              {"title": "Chế độ tối", "icon": Icons.dark_mode_outlined, "color": Color(0xFF424242)},
              {"title": "Chặn", "icon": Icons.block_outlined, "color": Color(0xFFF44336)},
              {"title": "Bảo vệ trang", "icon": Icons.shield_outlined, "color": Color(0xFFFF5722)},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return _buildAnimatedSettingsCard(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE57373).withOpacity(0.2),
                          Color(0xFFEF5350).withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFFE57373).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Color(0xFFE57373),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Bảo mật",
                          style: TextStyle(
                            color: Color(0xFFE57373),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Bảo vệ tài khoản và dữ liệu cá nhân",
                    style: TextStyle(
                      color: Color(0xFF4B4033).withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            flex: 2,
            child: _buildEnhancedOptionsList([
              {"title": "Đổi tài khoản", "icon": Icons.account_circle_outlined, "color": Color(0xFF3F51B5)},
              {"title": "Cập nhật thông tin", "icon": Icons.edit_outlined, "color": Color(0xFF009688)},
              {"title": "Đồng bộ", "icon": Icons.sync_outlined, "color": Color(0xFFCDDC39)},
              {"title": "Đổi mật khẩu", "icon": Icons.lock_outline, "color": Color(0xFFFF9800)},
              {"title": "Cập nhật Email", "icon": Icons.email_outlined, "color": Color(0xFFE91E63)},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSettingsCard({required Widget child}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF8E1),
                    Color(0xFFFFF8E1).withOpacity(0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContainer({
    required BoxDecoration decoration,
    required EdgeInsets padding,
    EdgeInsets? margin,
    required Widget child,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: decoration,
        padding: padding,
        margin: margin,
        child: child,
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0xFF4B4033).withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsList(List<String> options) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // Handle option tap
                        print('Selected: $option');
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: Color(0xFF4B4033),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}