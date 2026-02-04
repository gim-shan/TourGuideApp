import 'package:flutter/material.dart';

class Tnewpass extends StatefulWidget {
  const Tnewpass({super.key});

  @override
  State<Tnewpass> createState() => _TnewpassState();
}

class _TnewpassState extends State<Tnewpass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Password Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NewPasswordScreen(),
    );
  }
}

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  String? _newPasswordError;
  String? _confirmPasswordError;

  final List<String> _previousPasswords = [
    'password123',
    'hello123',
    'welcome123'
  ];

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateNewPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _newPasswordError = 'Please enter a password';
      });
      return;
    }

    if (value.length < 6) {
      setState(() {
        _newPasswordError = 'Password must be at least 6 characters';
      });
      return;
    }

    if (_previousPasswords.contains(value)) {
      setState(() {
        _newPasswordError = 'Password has been used before';
      });
      return;
    }

    setState(() {
      _newPasswordError = null;
    });
  }

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return;
    }

    if (value != _newPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _confirmPasswordError = null;
    });
  }

  Future<void> _savePassword() async {
    _validateNewPassword(_newPasswordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);

    if (_newPasswordError == null && _confirmPasswordError == null) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF4CAF50),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Password has been changed\nsuccessfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();

                      setState(() {
                        _showNewPassword = false;
                        _showConfirmPassword = false;
                      });

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF134734),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _premiumPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 313,
          height: 54,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 230, 230),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 130, 128, 128).withOpacity(0.9),
                blurRadius: 6,
                offset: const Offset(0, 5),
              ),
            ],
            border: errorText != null
                ? Border.all(
                    color: const Color(0xFFF44336),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: !isVisible,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 72, 72, 72),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    isVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Container(
            width: 313,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFF44336),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      errorText,
                      style: const TextStyle(
                        color: Color(0xFFF44336),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "New Password",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "Your New Password Must Be Different from\nPreviously Used Password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 68, 105, 71),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          "New Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _premiumPasswordField(
                        controller: _newPasswordController,
                        hint: "..................",
                        isVisible: _showNewPassword,
                        onToggle: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                        onChanged: _validateNewPassword,
                        errorText: _newPasswordError,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _premiumPasswordField(
                        controller: _confirmPasswordController,
                        hint: "..................",
                        isVisible: _showConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        onChanged: _validateConfirmPassword,
                        errorText: _confirmPasswordError,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 313,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF134734),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(44.5),
                        ),
                        elevation: 8,
                        shadowColor:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "SAVE",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
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
}
