import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String userName;
  final String? imageUrl;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? textStyle;

  const ProfileAvatar({
    super.key,
    required this.userName,
    this.imageUrl,
    this.size = 80,
    this.showBorder = false,
    this.borderColor = const Color(0xff1b9c4d),
    this.borderWidth = 4,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xff1b9c4d), Color(0xff0e5a3c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: showBorder
            ? Border.all(
                color: borderColor ?? const Color(0xff1b9c4d),
                width: borderWidth ?? 4,
              )
            : null,
      ),
      child: imageUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(imageUrl!),
              onBackgroundImageError: (_, _) {
                // Fallback to initial if image fails
              },
              child: _buildInitialText(),
            )
          : _buildInitialText(),
    );
  }

  Widget _buildInitialText() {
    return Center(
      child: Text(
        (userName.isNotEmpty ? userName[0] : 'U').toUpperCase(),
        style:
            textStyle ??
            const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
