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
        Uri.parse('https://localhost:7093/api/login/login'),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left Panel (Background design)
              Expanded(
                child: Container(
                  color: const Color(0xFF921111),
                  child: Center(
                    child: Image.asset(
                      'assets/images/design3.png',
                      width: constraints.maxWidth * 0.4,
                    ),
                  ),
                ),
              ),

              // Right Panel (Login form)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  color: const Color(0xFFF2E9DE),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/title_logo.png', width: 71, height: 48),
                          const SizedBox(height: 32),
                          const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFAF1515),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username Field
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5B893),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email của bạn',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5B893),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Button with hover effect
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _hoveredLogin = true),
                              onExit: (_) => setState(() => _hoveredLogin = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: _hoveredLogin == true
                                      ? [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))]
                                      : [],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _hoveredLogin == true ? const Color(0xFFC21717) : const Color(0xFFAF1515),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          'Đăng nhập',
                                          style: TextStyle(fontSize: 20, color: Color(0xFFF2E9DE)),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          // Error message
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],

                          const SizedBox(height: 20),
                          const Text('Hoặc', style: TextStyle(fontSize: 18)),

                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Social Button with hover effect
                              _socialButton('Google'),
                              _socialButton('Facebook'),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Link Row with hover and navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => setState(() => _hoveredLink = 'register'),
                                onExit: (_) => setState(() => _hoveredLink = null),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/register');
                                  },
                                  child: Text(
                                    'Chưa có tài khoản?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _hoveredLink == 'register' ? const Color(0xFFC21717) : Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => setState(() => _hoveredLink = 'forgot'),
                                onExit: (_) => setState(() => _hoveredLink = null),
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: Add forgot password navigation
                                  },
                                  child: Text(
                                    'Quên mật khẩu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _hoveredLink == 'forgot' ? const Color(0xFFC21717) : Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _socialButton(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredSocial = label),
      onExit: (_) => setState(() => _hoveredSocial = null),
      child: GestureDetector(
        onTap: () {}, // TODO: Add social login logic
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 140,
          height: 45,
          decoration: BoxDecoration(
            color: _hoveredSocial == label ? const Color(0xFFEEDFC2) : const Color(0xFFD5B893),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hoveredSocial == label
                ? [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  String? _hoveredSocial;
  bool? _hoveredLogin = false;
  String? _hoveredLink;
}
