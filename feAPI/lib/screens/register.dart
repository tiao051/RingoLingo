import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF921111),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (screenWidth > 900)
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/design7.png',
                        width: 500,
                        height: 600,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 40),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2E9DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/title_logo.png',
                            width: 50, height: 34),
                        const SizedBox(height: 20),
                        const Text(
                          'Đăng Ký',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Color(0xFFAF1515),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInputField('Tên đăng nhập', _usernameController),
                        const SizedBox(height: 10),
                        _buildInputField('Email', _emailController),
                        const SizedBox(height: 10),
                        _buildInputField('Mật khẩu', _passwordController,
                            isPassword: true),
                        const SizedBox(height: 10),
                        _buildInputField(
                            'Xác nhận mật khẩu', _confirmPasswordController,
                            isConfirmPassword: true),
                        const SizedBox(height: 20),
                        _buildRegisterButton(),
                        const SizedBox(height: 20),
                        const Text('Hoặc', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        _buildSocialButtons(),
                        const SizedBox(height: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/login');
                            },
                            child: Text(
                              'Bạn đã có tài khoản? Đăng nhập',
                              style: TextStyle(
                                color: Color(0xFFAF1515),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {bool isPassword = false, bool isConfirmPassword = false}) {
    final isObscured = isPassword
        ? !_isPasswordVisible
        : isConfirmPassword
            ? !_isConfirmPasswordVisible
            : false;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD5B893),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                obscureText: isObscured,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          if (isPassword || isConfirmPassword)
            IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (isPassword) {
                    _isPasswordVisible = !_isPasswordVisible;
                  } else {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isLoading ? null : _onRegisterTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: _isLoading ? Colors.red.shade300 : const Color(0xFFAF1515),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Color(0xFFF2E9DE), strokeWidth: 3),
                  )
                : const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFF2E9DE),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _socialButton('Google'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _socialButton('Facebook'),
        ),
      ],
    );
  }

  Widget _socialButton(String title) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print('$title login tapped');
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFD5B893),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onRegisterTap() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final hasSpaceInPassword = password.contains(' ');

    // Kiểm tra từng trường xem có trống không
    List<String> missingFields = [];
    if (username.isEmpty) missingFields.add('username');
    if (email.isEmpty) missingFields.add('email');
    if (password.isEmpty) missingFields.add('password');
    if (confirmPassword.isEmpty) missingFields.add('confirmPassword');

    // Kiểm tra yêu cầu riêng biệt theo thứ tự ưu tiên
    if (missingFields.length > 1) {
      _showFloatingMessage('Vui lòng nhập đầy đủ thông tin!');
      return;
    } else if (missingFields.length == 1) {
      switch (missingFields.first) {
        case 'username':
          _showFloatingMessage('Vui lòng nhập tên đăng nhập!');
          return;
        case 'email':
          _showFloatingMessage('Vui lòng nhập email!');
          return;
        case 'password':
          _showFloatingMessage('Vui lòng nhập mật khẩu!');
          return;
        case 'confirmPassword':
          _showFloatingMessage('Vui lòng xác nhận lại mật khẩu!');
          return;
      }
    }

    // Kiểm tra tên đăng nhập >= 4 ký tự
    if (username.length < 4) {
      _showFloatingMessage('Tên đăng nhập phải từ 4 ký tự trở lên');
      return;
    }

    // Kiểm tra email hợp lệ
    if (!emailRegex.hasMatch(email)) {
      _showFloatingMessage('Email không hợp lệ');
      return;
    }

    // Kiểm tra password không chứa dấu cách
    if (hasSpaceInPassword) {
      _showFloatingMessage('Mật khẩu không được chứa dấu cách');
      return;
    }

    // Kiểm tra password và confirm password phải giống nhau
    if (password != confirmPassword) {
      _showFloatingMessage('Xác nhận mật khẩu không đúng');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://localhost:7093/api/signup/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Username': username,
          'Email': email,
          'Password': password,
        }),
      );

      if (response.statusCode == 200) {
        _showFloatingMessage('Đăng ký thành công!', isError: false);
        // Ví dụ chuyển sang trang đăng nhập
        Navigator.of(context).pushNamed('/login');
      } else {
        _showFloatingMessage('Đăng ký thất bại!');
      }
    } catch (e) {
      _showFloatingMessage('Lỗi kết nối đến server');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFloatingMessage(String message, {bool isError = true}) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: FloatingNotification(
          message: message,
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class FloatingNotification extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const FloatingNotification({
    Key? key,
    required this.message,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
