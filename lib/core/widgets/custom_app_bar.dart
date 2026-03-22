import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hidmo_app/core/widgets/profile_avatar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? additionalActions;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool isProfileScreen;
  final VoidCallback? onProfileTapped;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.additionalActions,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xff1b3a20),
    this.isProfileScreen = false,
    this.onProfileTapped,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) return;

      final data = doc.data();
      if (!mounted || data == null) return;

      setState(() {
        _userName = (data['name'] as String?)?.trim();
      });
    } catch (_) {
      // Ignore errors and keep fallback name
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: widget.backgroundColor,
      leading: widget.showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: widget.titleColor),
              onPressed:
                  widget.onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: widget.titleColor,
        ),
      ),
      centerTitle: false,
      actions: [
        ...?widget.additionalActions,
        if (!widget.isProfileScreen)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: widget.onProfileTapped,
              child: ProfileAvatar(userName: _userName ?? 'User', size: 40),
            ),
          ),
      ],
    );
  }
}
