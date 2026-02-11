import 'package:flutter/material.dart';
import 'tourist_signin_screen.dart';
import 'guide_signin_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/choose.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback gradient if image fails to load
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF1B5E20),
                      Color(0xFF0A2E1A),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              );
            },
          ),

          // Dark overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Choose Your Role',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Role circles row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tourist Circle -> go to tourist sign‑in
                      _buildRoleCircle(
                        context: context,
                        imagePath: 'assets/images/user.jpg',
                        label: 'Tourist',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TSignInScreen(),
                            ),
                          );
                        },
                        size: size,
                      ),

                      // Guide Circle -> go to guide sign‑in
                      _buildRoleCircle(
                        context: context,
                        imagePath: 'assets/images/guide.png',
                        label: 'Guide',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const GSignInScreen(),
                            ),
                          );
                        },
                        size: size,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCircle({
    required BuildContext context,
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    required Size size,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular container with image
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size.width * 0.35,
            height: size.width * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback icon if image fails to load
                  return const Icon(Icons.person, size: 80, color: Colors.grey);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
