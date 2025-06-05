import 'package:flutter/material.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';
import 'package:ringolingo_app/widgets/HistoryMainContent.dart';

class thongke extends StatefulWidget {
  @override
  _thongke createState() => _thongke();
}

class _thongke extends State<thongke> {
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
              child: LeftSidebar(activeTab: 'Hồ sơ'),
            ),

            const SizedBox(width: 16),

            /// MAIN CONTENT - 60%
            Expanded(
              flex: 6,
              child: HistoryMainContent(),
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
