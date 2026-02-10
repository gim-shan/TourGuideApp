import 'package:flutter/material.dart';
import 'choose_role_screen.dart';
import 'get_started_vr_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  static const Color primaryColor = Color(0xFF1E4D3C);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFD5E3D3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Top image with white gradient overlay at the very top (status bar area)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.52,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/getstarted1.png',
                    fit: BoxFit.cover,
                  ),
                  // white gradient overlay at the very top to reach into status bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).padding.top + 28,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1.0),
                            Color.fromRGBO(255, 255, 255, 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom green area with card (use SafeArea here so content doesn't clash with system UI)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.55,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Floating card
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: size.height * 0.42,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Meet your perfect\nLocal Guide',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: primaryColor,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Get personalized tours and insider tips\nfrom guides who live\nwhere you're going.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF7A7A7A),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Next button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondary) =>
                                            const GetStartedVrScreen(),
                                    transitionsBuilder:
                                        (context, animation, secondary, child) {
                                          final offset =
                                              Tween<Offset>(
                                                begin: const Offset(0.0, 0.2),
                                                end: Offset.zero,
                                              ).chain(
                                                CurveTween(
                                                  curve: Curves.easeOut,
                                                ),
                                              );
                                          return SlideTransition(
                                            position: animation.drive(offset),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Positioned Skip button bottom-right -> go directly to role selection
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondary) =>
                        const ChooseRoleScreen(),
                    transitionsBuilder:
                        (context, animation, secondary, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFBFDCC4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
