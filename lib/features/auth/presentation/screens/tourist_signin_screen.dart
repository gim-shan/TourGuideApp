import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'tourist_signup_screen.dart';

class TSignInScreen extends StatefulWidget {
  const TSignInScreen({super.key});

  @override
  State<TSignInScreen> createState() => _TSignInScreenState();
}

class _TSignInScreenState extends State<TSignInScreen> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool showPass = false;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF1E4D3C);

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> _checkSignIn() async {
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

    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signed in successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Navigate to tourist home screen
    } on FirebaseAuthException catch (e) {
      _errorMessage(_mapAuthError(e));
    } catch (_) {
      _errorMessage("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn(
        scopes: const <String>['email'],
      ).signIn();
      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Unable to sign in with Google. Please try again.',
        );
      }

      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'role': 'tourist',
        'name': user.displayName,
        'provider': 'google',
        'lastSignInAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signed in with Google as Tourist"),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Navigate to tourist home screen
    } on FirebaseAuthException catch (e) {
      _errorMessage(_mapAuthError(e));
    } catch (_) {
      _errorMessage("Google sign-in failed. Please try again.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication error. Please try again.';
    }
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
                  image: AssetImage("assets/images/image16.png"),
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

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _checkSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
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

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_googleBtn('assets/icons/Google1.png')],
                    ),

                    const SizedBox(height: 15),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
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
                                fontFamily: 'Roboto',
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const TSignUpScreen(),
                                    ),
                                  );
                                },
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

  Widget _googleBtn(String imgpath) {
    return InkWell(
      onTap: _isLoading ? null : _signInWithGoogle,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.transparent,
        child: Image.asset(
          imgpath,
          height: 50,
          width: 50,
          errorBuilder: (ctx, err, stack) {
            return const Icon(Icons.circle, color: Colors.grey, size: 40);
          },
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
//Added comment by Kaveesha