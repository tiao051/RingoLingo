import 'package:flutter/material.dart';
import 'package:ringolingo_app/widgets/left_sidebar.dart';
import 'package:ringolingo_app/widgets/right_sidebar.dart';

class HoSo extends StatefulWidget {
  const HoSo({super.key});
  @override
  HoSoState createState() => HoSoState();
}

class HoSoState extends State<HoSo> {
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
              child: LeftSidebar(activeTab: 'Hồ sơ'),
            ),

            const SizedBox(width: 16),            /// MAIN CONTENT - 60%
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only( right: 12),
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.only( bottom: 14, left: 2, right: 2),
                            width: double.infinity,
                            child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 231,
                                            width: double.infinity,
                                            child: Image.network(
                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/uz9twaeg_expires_30_days.png",
                                              fit: BoxFit.fill,
                                            )
                                        ),
                                      ]
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 100,
                                    width: 172,
                                    height: 172,
                                    child: Container(
                                        transform: Matrix4.translationValues(0, 76, 0),
                                        width: 172,
                                        height: 172,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/f0eqjggn_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only( bottom: 90, left: 296),
                          child: Text(
                            "Wren Evans\n@wrenevans___",
                            style: TextStyle(
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        IntrinsicHeight(
                          child: Container(
                            padding: const EdgeInsets.only( bottom: 25),
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only( bottom: 4, left: 100),
                                    child: Text(
                                      "Thành tích",
                                      style: TextStyle(
                                        color: Color(0xFF921111),
                                        fontSize: 31,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Container(
                                        margin: const EdgeInsets.only( bottom: 42, left: 2),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              IntrinsicWidth(
                                                child: IntrinsicHeight(
                                                  child: Container(
                                                    margin: const EdgeInsets.only( right: 248),
                                                    child: Column(
                                                        children: [
                                                          IntrinsicWidth(
                                                            child: IntrinsicHeight(
                                                              child: Stack(
                                                                  clipBehavior: Clip.none,
                                                                  children: [
                                                                    Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              width: 190,
                                                                              height: 190,
                                                                              child: Image.asset(
                                                                                'assets/images/design3.png',
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    Positioned(
                                                                      top: 16,
                                                                      left: 1,
                                                                      width: 419,
                                                                      height: 158,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Color(0xFFFFD740),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(40),
                                                                            bottomRight: Radius.circular(0),
                                                                          ),
                                                                        ),
                                                                        child: Stack(
                                                                          children: [
                                                                            // Hình ảnh design3.png
                                                                            Positioned(
                                                                              top: 0,
                                                                              left: 0,
                                                                              width: 190,
                                                                              height: 190,
                                                                              child: Image.asset(
                                                                                'assets/images/design3.png',
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),

                                                                            // Tiêu đề: "Táo chăm chỉ"
                                                                            Positioned(
                                                                              top: 61,
                                                                              left: 172,
                                                                              width: 220,
                                                                              height: 36,
                                                                              child: Container(
                                                                                width: 220,
                                                                                child: Text(
                                                                                  'Táo chăm chỉ',
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF4B4033),
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontFamily: 'Inter',
                                                                                    height: 1.2, // tương đương line-height: 120%
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // Nội dung: "Học 10 ngày liên tiếp ! Bạn đang giữ chuỗi đó !"
                                                                            Positioned(
                                                                              top: 93,
                                                                              left: 172,
                                                                              width: 229,
                                                                              height: 37,
                                                                              child: Container(
                                                                                width: 229,
                                                                                child: Text(
                                                                                  'Học 10 ngày liên tiếp ! Bạn đang giữ chuỗi đó !',
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF4B4033),
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontFamily: 'Inter',
                                                                                    height: 1.2,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),


                                                                  ]
                                                              ),
                                                            ),
                                                          ),
                                                          IntrinsicWidth(
                                                            child: IntrinsicHeight(
                                                              child: Stack(
                                                                  clipBehavior: Clip.none,
                                                                  children: [
                                                                    Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              width: 190,
                                                                              height: 190,
                                                                              child: Image.network(
                                                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/4wi9j6sn_expires_30_days.png",
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    Positioned(
                                                                      top: 16,
                                                                      left: 1,
                                                                      width: 419,
                                                                      height: 158,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Color(0xFFFFD740),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(40),
                                                                            bottomRight: Radius.circular(40),
                                                                          ),
                                                                        ),
                                                                        child: Stack(
                                                                          children: [
                                                                            // Hình ảnh (design3.png)
                                                                            Positioned(
                                                                              top: 0,
                                                                              left: 0,
                                                                              width: 190,
                                                                              height: 190,
                                                                              child: Image.asset(
                                                                                'assets/images/design3.png',
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),

                                                                            // Text: "Táo chăm chỉ"
                                                                            Positioned(
                                                                              top: 61,
                                                                              left: 172,
                                                                              width: 220,
                                                                              height: 36,
                                                                              child: Text(
                                                                                "Siêu trí nhớ",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Inter',
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.2,
                                                                                  color: Color(0xFF4B4033),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // Text: "Học 10 ngày liên tiếp ! Bạn đang giữ chuỗi đó !"
                                                                            Positioned(
                                                                              top: 93,
                                                                              left: 172,
                                                                              width: 229,
                                                                              height: 37,
                                                                              child: Text(
                                                                                "Sổ tay của bạn vừa đạt 50 từ, cố gắng lên nữa nhé !",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Inter',
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  height: 1.2,
                                                                                  color: Color(0xFF4B4033),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ]
                                                              ),
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IntrinsicWidth(
                                                child: IntrinsicHeight(
                                                  child: Column(
                                                      children: [
                                                        IntrinsicWidth(
                                                          child: IntrinsicHeight(
                                                            child: Stack(
                                                                clipBehavior: Clip.none,
                                                                children: [
                                                                  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                            width: 190,
                                                                            height: 190,
                                                                            child: Image.network(
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/hpcpc0i2_expires_30_days.png",
                                                                              fit: BoxFit.fill,
                                                                            )
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  Positioned(
                                                                    top: 16,
                                                                    left: 1,
                                                                    width: 419,
                                                                    height: 158,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xFFFFD740),
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(40),
                                                                          bottomRight: Radius.circular(0),
                                                                        ),
                                                                      ),
                                                                      child: Stack(
                                                                        children: [
                                                                          // Hình ảnh design3.png
                                                                          Positioned(
                                                                            top: 0,
                                                                            left: 0,
                                                                            width: 190,
                                                                            height: 190,
                                                                            child: Image.asset(
                                                                              'assets/images/design3.png',
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),

                                                                          // Tiêu đề: "Táo siêu phàm"
                                                                          Positioned(
                                                                            top: 61,
                                                                            left: 172,
                                                                            width: 139,
                                                                            height: 36,
                                                                            child: Container(
                                                                              width: 139,
                                                                              child: Text(
                                                                                'Táo siêu phàm',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF4B4033),
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Inter',
                                                                                  height: 1.2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          // Nội dung: "Làm 10 bài thi với số điểm trên 8, quá dữ !"
                                                                          Positioned(
                                                                            top: 93,
                                                                            left: 172,
                                                                            width: 193,
                                                                            height: 37,
                                                                            child: Container(
                                                                              width: 193,
                                                                              child: Text(
                                                                                'Làm 10 bài thi với số điểm trên 8, quá dữ !',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF4B4033),
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: 'Inter',
                                                                                  height: 1.2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ),
                                                        IntrinsicWidth(
                                                          child: IntrinsicHeight(
                                                            child: Stack(
                                                                clipBehavior: Clip.none,
                                                                children: [
                                                                  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                            width: 190,
                                                                            height: 190,
                                                                            child: Image.network(
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/z19e7gbi_expires_30_days.png",
                                                                              fit: BoxFit.fill,
                                                                            )
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  Positioned(
                                                                    top: 16,
                                                                    left: 1,
                                                                    width: 419,
                                                                    height: 158,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xFFFFD740),
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(40),
                                                                          bottomRight: Radius.circular(0),
                                                                        ),
                                                                      ),
                                                                      child: Stack(
                                                                        children: [
                                                                          // Hình ảnh design3.png
                                                                          Positioned(
                                                                            top: 0,
                                                                            left: 0,
                                                                            width: 190,
                                                                            height: 190,
                                                                            child: Image.asset(
                                                                              'assets/images/design3.png',
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),

                                                                          // Tiêu đề: "Táo siêng năng"
                                                                          Positioned(
                                                                            top: 61,
                                                                            left: 172,
                                                                            width: 220,
                                                                            height: 36,
                                                                            child: Container(
                                                                              width: 220,
                                                                              child: Text(
                                                                                'Táo siêng năng',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF4B4033),
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Inter',
                                                                                  height: 1.2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          // Nội dung: "Học 10 ngày liên tiếp ! Bạn đang giữ chuỗi đó !"
                                                                          Positioned(
                                                                            top: 93,
                                                                            left: 172,
                                                                            width: 229,
                                                                            height: 37,
                                                                            child: Container(
                                                                              width: 229,
                                                                              child: Text(
                                                                                'Bạn đã online được 300 phút trên Ringolingo',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF4B4033),
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: 'Inter',
                                                                                  height: 1.2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only( bottom: 16, left: 100),
                                    child: Text(
                                      "Ngôn ngữ đang học",
                                      style: TextStyle(
                                        color: Color(0xFF921111),
                                        fontSize: 31,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Container(
                                        margin: const EdgeInsets.only( left: 182),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only( right: 23),
                                                  width: 141,
                                                  height: 83,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/nta93dia_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  )
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 3),
                                                  width: 141,
                                                  height: 83,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/jywrkzig_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  )
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),                      ]
                  ),
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