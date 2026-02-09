import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GSignInScreen extends StatefulWidget {
  const GSignInScreen({super.key});

  @override
  State<GSignInScreen> createState() => _GSignInScreenState();
}

class _GSignInScreenState extends State<GSignInScreen> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  bool showPass = false;

  final Color primaryColor = const Color(0xFF1E4D3C);

  void _checkSignIn() {
    String email = txtEmail.text.trim();
    String password = txtPassword.text.trim();

    if (email.isEmpty) {
      _errorMessage("Please enter your email.");
      return;
    }

    if (password.isEmpty) {
      _errorMessage("Please enter your password.");
      return;
    }

    final emailFormat = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailFormat.hasMatch(email)) {
      _errorMessage("Please enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      _errorMessage("Password must be at least 6 characters.");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sign-in successful!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screen.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image17.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0, -1.0),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screen.height * 0.78,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 30.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Welcome Back !",
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    labelWidget("Email"),
                    const SizedBox(height: 18),
                    inputField(ctrl: txtEmail, hint: "example@gmail.com"),

                    const SizedBox(height: 35),

                    labelWidget("Password"),
                    const SizedBox(height: 18),
                    inputField(
                      ctrl: txtPassword,
                      hint: "...................",
                      isSecure: true,
                      showContent: showPass,
                      onEyeTap: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _checkSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: const Color(0xFF266D44),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
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
        ],
      ),
    );
  }

  Widget inputField({
    required TextEditingController ctrl,
    required String hint,
    bool isSecure = false,
    bool showContent = false,
    VoidCallback? onEyeTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3E4E4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isSecure && !showContent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon: isSecure
              ? IconButton(
                  icon: Icon(
                    showContent
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: onEyeTap,
                )
              : null,
        ),
      ),
    );
  }

  Widget labelWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
