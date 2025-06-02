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
  bool _isRegisterHovered = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isLoginHovered = false;
  bool _isGoogleHovered = false;
  bool _isFacebookHovered = false;

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
                        const SizedBox(height: 20),

                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _isLoginHovered = true),
                          onExit: (_) => setState(() => _isLoginHovered = false),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/login');
                            },
                            child: Text(
                              'Bạn đã có tài khoản? Đăng nhập',
                              style: TextStyle(
                                color: _isLoginHovered ? Colors.black : Color(0xFFAF1515),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: _isLoginHovered ? Colors.black : Color(0xFFAF1515),
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
    onEnter: (_) => setState(() => _isRegisterHovered = true),
    onExit: (_) => setState(() => _isRegisterHovered = false),
    child: GestureDetector(
      onTap: () {
        print('Register button tapped');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: _isRegisterHovered ? const Color(0xFF841111) : const Color(0xFFAF1515),
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
    ),
  );
}

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isGoogleHovered = true),
            onExit: (_) => setState(() => _isGoogleHovered = false),
            child: _socialButton('Google', hovered: _isGoogleHovered),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isFacebookHovered = true),
            onExit: (_) => setState(() => _isFacebookHovered = false),
            child: _socialButton('Facebook', hovered: _isFacebookHovered),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(String title, {bool hovered = false}) {
    return GestureDetector(
      onTap: () {
        print('$title login tapped');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: hovered ? const Color(0xFFB39B76) : const Color(0xFFD5B893),
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
