import 'package:flutter/material.dart';

class HoSo extends StatefulWidget {
  const HoSo({super.key});
  @override
  HoSoState createState() => HoSoState();
}

class HoSoState extends State<HoSo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFFF2E9DE),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 24, left: 20, right: 20),
                          width: double.infinity,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicWidth(
                                  child: IntrinsicHeight(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(47),
                                        color: Color(0xFFC21717),
                                      ),
                                      padding: const EdgeInsets.only(
                                          top: 42, bottom: 13),
                                      margin: const EdgeInsets.only(right: 22),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 88,
                                                    left: 54,
                                                    right: 54),
                                                width: 89,
                                                height: 61,
                                                child: Image.network(
                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/dgn2a0t1_expires_30_days.png",
                                                  fit: BoxFit.fill,
                                                )),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20,
                                                      left: 26,
                                                      right: 26),
                                                  child: Row(children: [
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        width: 40,
                                                        height: 40,
                                                        child: Image.network(
                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/dpolrfu2_expires_30_days.png",
                                                          fit: BoxFit.fill,
                                                        )),
                                                    Text(
                                                      "Ôn tập",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20, left: 30),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 12,
                                                                    right: 1),
                                                            width: 40,
                                                            height: 30,
                                                            child:
                                                                Image.network(
                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/47y1f1ot_expires_30_days.png",
                                                              fit: BoxFit.fill,
                                                            )),
                                                        Container(
                                                          width: 57,
                                                          child: Text(
                                                            "Sổ tay",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 12, left: 30),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10,
                                                                    right: 9),
                                                            width: 32,
                                                            height: 32,
                                                            child:
                                                                Image.network(
                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/q23auett_expires_30_days.png",
                                                              fit: BoxFit.fill,
                                                            )),
                                                        Container(
                                                          width: 85,
                                                          child: Text(
                                                            "Khóa học",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    color: Color(0xFFECB7B7),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 16,
                                                          right: 47),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 4,
                                                      left: 14,
                                                      right: 14),
                                                  child: Row(children: [
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 9),
                                                        width: 32,
                                                        height: 32,
                                                        child: Image.network(
                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/mbegxlay_expires_30_days.png",
                                                          fit: BoxFit.fill,
                                                        )),
                                                    Container(
                                                      width: 54,
                                                      child: Text(
                                                        "Hồ sơ",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC21717),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 424,
                                                      left: 29,
                                                      right: 29),
                                                  child: Row(children: [
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 6),
                                                        width: 36,
                                                        height: 36,
                                                        child: Image.network(
                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/l1l9mbt4_expires_30_days.png",
                                                          fit: BoxFit.fill,
                                                        )),
                                                    Container(
                                                      width: 65,
                                                      child: Text(
                                                        "Cài đặt",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print('Pressed');
                                              },
                                              child: IntrinsicWidth(
                                                child: IntrinsicHeight(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      color: Color(0xFFECB7B7),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 11,
                                                            bottom: 11,
                                                            left: 64,
                                                            right: 64),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              width: 42,
                                                              height: 42,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/LogOut.png',
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IntrinsicHeight(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: double.infinity,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IntrinsicHeight(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 14,
                                                    left: 2,
                                                    right: 2),
                                                width: double.infinity,
                                                child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                                height: 231,
                                                                width: double
                                                                    .infinity,
                                                                child: Image
                                                                    .network(
                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/uz9twaeg_expires_30_days.png",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                          ]),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 100,
                                                        width: 172,
                                                        height: 172,
                                                        child: Container(
                                                            transform: Matrix4
                                                                .translationValues(
                                                                    0, 76, 0),
                                                            width: 172,
                                                            height: 172,
                                                            child:
                                                                Image.network(
                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/f0eqjggn_expires_30_days.png",
                                                              fit: BoxFit.fill,
                                                            )),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 90, left: 296),
                                              child: Text(
                                                "Wren Evans\n@wrenevans___",
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                ),
                                              ),
                                            ),
                                            IntrinsicHeight(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 25),
                                                width: double.infinity,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            bottom: 4,
                                                            left: 100),
                                                        child: Text(
                                                          "Thành tích",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF921111),
                                                            fontSize: 31,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      IntrinsicWidth(
                                                        child: IntrinsicHeight(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 42,
                                                                    left: 2),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  IntrinsicWidth(
                                                                    child:
                                                                        IntrinsicHeight(
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                248),
                                                                        child: Column(
                                                                            children: [
                                                                              IntrinsicWidth(
                                                                                child: IntrinsicHeight(
                                                                                  child: Stack(clipBehavior: Clip.none, children: [
                                                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                      Container(
                                                                                          width: 190,
                                                                                          height: 190,
                                                                                          child: Image.asset(
                                                                                            'assets/images/design3.png',
                                                                                            fit: BoxFit.fill,
                                                                                          )),
                                                                                    ]),
                                                                                    Positioned(
                                                                                      top: 16,
                                                                                      left: 1,
                                                                                      width: 419,
                                                                                      height: 158,
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color(0xFFD5B893),
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
                                                                                  ]),
                                                                                ),
                                                                              ),
                                                                              IntrinsicWidth(
                                                                                child: IntrinsicHeight(
                                                                                  child: Stack(clipBehavior: Clip.none, children: [
                                                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                      Container(
                                                                                          width: 190,
                                                                                          height: 190,
                                                                                          child: Image.network(
                                                                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/4wi9j6sn_expires_30_days.png",
                                                                                            fit: BoxFit.fill,
                                                                                          )),
                                                                                    ]),
                                                                                    Positioned(
                                                                                      top: 16,
                                                                                      left: 1,
                                                                                      width: 419,
                                                                                      height: 158,
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color(0xFFD5B893),
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
                                                                                  ]),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IntrinsicWidth(
                                                                    child:
                                                                        IntrinsicHeight(
                                                                      child: Column(
                                                                          children: [
                                                                            IntrinsicWidth(
                                                                              child: IntrinsicHeight(
                                                                                child: Stack(clipBehavior: Clip.none, children: [
                                                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Container(
                                                                                        width: 190,
                                                                                        height: 190,
                                                                                        child: Image.network(
                                                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/hpcpc0i2_expires_30_days.png",
                                                                                          fit: BoxFit.fill,
                                                                                        )),
                                                                                  ]),
                                                                                  Positioned(
                                                                                    top: 16,
                                                                                    left: 1,
                                                                                    width: 419,
                                                                                    height: 158,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFFD5B893),
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
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                            IntrinsicWidth(
                                                                              child: IntrinsicHeight(
                                                                                child: Stack(clipBehavior: Clip.none, children: [
                                                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Container(
                                                                                        width: 190,
                                                                                        height: 190,
                                                                                        child: Image.network(
                                                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/z19e7gbi_expires_30_days.png",
                                                                                          fit: BoxFit.fill,
                                                                                        )),
                                                                                  ]),
                                                                                  Positioned(
                                                                                    top: 16,
                                                                                    left: 1,
                                                                                    width: 419,
                                                                                    height: 158,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFFD5B893),
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
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            bottom: 16,
                                                            left: 100),
                                                        child: Text(
                                                          "Ngôn ngữ đang học",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF921111),
                                                            fontSize: 31,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      IntrinsicWidth(
                                                        child: IntrinsicHeight(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 182),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              23),
                                                                      width:
                                                                          141,
                                                                      height:
                                                                          83,
                                                                      child: Image
                                                                          .network(
                                                                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/nta93dia_expires_30_days.png",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              3),
                                                                      width:
                                                                          141,
                                                                      height:
                                                                          83,
                                                                      child: Image
                                                                          .network(
                                                                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/jywrkzig_expires_30_days.png",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                IntrinsicWidth(
                                  child: IntrinsicHeight(
                                    child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IntrinsicWidth(
                                                  child: IntrinsicHeight(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Color(0xFFD5B893),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 29,
                                                              bottom: 147),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          23,
                                                                      left: 24,
                                                                      right:
                                                                          24),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            margin:
                                                                                const EdgeInsets.only(right: 20),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: Image.network(
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/zwypvtfm_expires_30_days.png",
                                                                              fit: BoxFit.fill,
                                                                            )),
                                                                        Text(
                                                                          "Wren Evans\n@wrenevans___",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF000000),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            16,
                                                                        left:
                                                                            23,
                                                                        right:
                                                                            23),
                                                                width: 252,
                                                                height: 1,
                                                                child: Image
                                                                    .network(
                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/1jifa852_expires_30_days.png",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 21),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/j2zcw2d1_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              right: 24),
                                                                          width:
                                                                              105,
                                                                          child:
                                                                              Text(
                                                                            "Lim Feng\n@limfeng__",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFF000000),
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              SizedBox(),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 20),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/ag6ajj9v_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Container(
                                                                          width:
                                                                              153,
                                                                          child:
                                                                              Text(
                                                                            "Mi Nga\n@lf.mingahaman",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFF000000),
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/tx16u5mr_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Container(
                                                                          width:
                                                                              20,
                                                                          child:
                                                                              SizedBox(),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              155,
                                                                          child:
                                                                              Text(
                                                                            "MCK\n@rpt.mckeyyyyy",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFF000000),
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 21),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/6z303uo2_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Text(
                                                                          "tlinh\n@lf.tlinh",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF000000),
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 21),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/7lp1manc_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              right: 16),
                                                                          width:
                                                                              113,
                                                                          child:
                                                                              Text(
                                                                            "wxrdie\n@wxrdie102",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFF000000),
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              SizedBox(),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 21),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/0viqtq1l_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Text(
                                                                          "Lâm Minh\n@lamiinh",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF000000),
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      left: 11,
                                                                      right:
                                                                          11),
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          27,
                                                                      left: 13,
                                                                      right:
                                                                          13),
                                                                  child: Row(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 21),
                                                                            width: 50,
                                                                            height: 50,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(40),
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/ikh11gzg_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                ))),
                                                                        Text(
                                                                          "DEC AO\n@dec.ao",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF000000),
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            43,
                                                                        left:
                                                                            23,
                                                                        right:
                                                                            23),
                                                                width: 252,
                                                                height: 1,
                                                                child: Image
                                                                    .network(
                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/rardmv35_expires_30_days.png",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                            IntrinsicWidth(
                                                              child:
                                                                  IntrinsicHeight(
                                                                child: Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                width: 185,
                                                                                height: 185,
                                                                                child: Image.network(
                                                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/thdcqte9_expires_30_days.png",
                                                                                  fit: BoxFit.fill,
                                                                                )),
                                                                          ]),
                                                                      Positioned(
                                                                        bottom:
                                                                            0,
                                                                        left:
                                                                            49,
                                                                        width:
                                                                            196,
                                                                        height:
                                                                            120,
                                                                        child:
                                                                            Container(
                                                                          transform: Matrix4.translationValues(
                                                                              0,
                                                                              71,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                196,
                                                                            child:
                                                                                Text(
                                                                              "Cố lên, Bạn đã đăng nhập được 5 ngày liên tiếp",
                                                                              style: TextStyle(
                                                                                color: Color(0xFF587147),
                                                                                fontSize: 25,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                          Positioned(
                                            bottom: 150,
                                            right: 0,
                                            width: 209,
                                            height: 209,
                                            child: Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        7, 0, 0),
                                                width: 229,
                                                height: 229,
                                                child: Image.network(
                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/r7XBi7xebP/jre082lb_expires_30_days.png",
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
