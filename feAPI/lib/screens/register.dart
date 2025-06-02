import 'package:flutter/material.dart';

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
                // Hình ảnh trang trí (ẩn nếu màn nhỏ)
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

                // Form đăng ký
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
                        Image.asset('assets/images/title_logo.png', width: 50, height: 34),
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
                        _buildInputField('Mật khẩu', _passwordController, isPassword: true),
                        const SizedBox(height: 10),
                        _buildInputField('Xác nhận mật khẩu', _confirmPasswordController, isConfirmPassword: true),
                        const SizedBox(height: 20),

                        _buildRegisterButton(),

                        const SizedBox(height: 20),
                        const Text('Hoặc', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),

                        _buildSocialButtons(),
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
    return GestureDetector(
      onTap: () {
        print('Register button tapped');
      },
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFAF1515),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Đăng ký',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFF2E9DE),
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
    return GestureDetector(
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
    );
  }
}
