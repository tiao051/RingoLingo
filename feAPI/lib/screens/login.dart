import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await http.post(
        Uri.parse('https://localhost:7093/api/login/login'), // Đổi endpoint đúng theo yêu cầu
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': _usernameController.text,
          'Password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = 'Sai tài khoản hoặc mật khẩu';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối server';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1440,
            height: 1024,
            child: Container(
              color: const Color(0xFF921111),
              child: Stack(
                children: [
                  // White Panel
                  Positioned(
                    left: 732,
                    top: 24,
                    child: Container(
                      width: 683,
                      height: 976,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E9DE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  // Logo (ringo)
                  Positioned(
                    left: 1058,
                    top: 82,
                    child: Image.asset(
                      'assets/images/title_logo.png',
                      width: 71,
                      height: 48,
                    ),
                  ),

                  // Background design
                  Positioned(
                    left: 44,
                    top: 225,
                    child: Image.asset(
                      'assets/images/design3.png',
                      width: 622,
                      height: 622,
                    ),
                  ),

                  // Heading: Đăng nhập
                  Positioned(
                    left: 975,
                    top: 271,
                    child: SizedBox(
                      width: 223,
                      height: 36,
                      child: Text(
                        'Đăng nhập',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 31,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAF1515),
                        ),
                      ),
                    ),
                  ),

                  // Ô tên đăng nhập
                  Positioned(
                    left: 896,
                    top: 325,
                    child: Container(
                      width: 400,
                      height: 49,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5B893),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tên đăng nhập',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Ô mật khẩu
                  Positioned(
                    left: 893,
                    top: 401,
                    child: Container(
                      width: 400,
                      height: 49,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5B893),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mật khẩu',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Hide mật khẩu (biểu tượng)
                  Positioned(
                    left: 1255,
                    top: 415,
                    child: Icon(
                      Icons.visibility_off,
                      color: Color(0xFFC21717),
                      size: 21,
                    ),
                  ),

                  // Nút Đăng nhập
                  Positioned(
                    left: 893,
                    top: 502,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _login,
                      child: Container(
                        width: 400,
                        height: 49,
                        decoration: BoxDecoration(
                          color: Color(0xFFAF1515),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Inter',
                                    color: Color(0xFFF2E9DE),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  // Hiển thị lỗi nếu có
                  if (_errorMessage != null)
                    Positioned(
                      left: 893,
                      top: 560,
                      child: SizedBox(
                        width: 400,
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.yellow, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  // Text "Hoặc"
                  Positioned(
                    left: 1031,
                    top: 575,
                    child: SizedBox(
                      width: 140,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Hoặc',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Button Google
                  Positioned(
                    left: 893,
                    top: 622,
                    child: Container(
                      width: 190,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Color(0xFFD5B893),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Google',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Button Facebook
                  Positioned(
                    left: 1103,
                    top: 622,
                    child: Container(
                      width: 190,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Color(0xFFD5B893),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Facebook',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Chưa có tài khoản?
                  Positioned(
                    left: 892,
                    top: 705,
                    child: SizedBox(
                      width: 145,
                      height: 19,
                      child: Center(
                        child: Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Quên mật khẩu
                  Positioned(
                    left: 1171,
                    top: 705,
                    child: SizedBox(
                      width: 115,
                      height: 19,
                      child: Center(
                        child: Text(
                          'Quên mật khẩu',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Vector đỏ nhỏ trên góc phải
                  Positioned(
                    left: 1278,
                    top: 46,
                    child: Container(
                      width: 119.38,
                      height: 18.95,
                      decoration: BoxDecoration(
                        color: Color(0xFF982B15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
