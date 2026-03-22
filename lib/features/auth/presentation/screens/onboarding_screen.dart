import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _blobController;
  final List<Particle> _particles = [];
  final List<FloatingBlob> _blobs = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 25; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 4 + 2,
          speed: _random.nextDouble() * 0.3 + 0.1,
          opacity: _random.nextDouble() * 0.5 + 0.2,
          wobbleOffset: _random.nextDouble() * 2 * pi,
          wobbleSpeed: _random.nextDouble() * 2 + 1,
        ),
      );
    }

    // Initialize floating green blobs - made more visible
    final blobColors = [
      const Color(0xFF4CAF50), // Bright green - more visible
      const Color(0xFF81C784), // Soft green
      const Color(0xFF2E7D32), // Medium green
      const Color(0xFF66BB6A), // Light green
      const Color(0xFFA5D6A7), // Pale green
    ];

    for (int i = 0; i < 8; i++) {
      _blobs.add(
        FloatingBlob(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 200 + 150, // Larger blobs
          speedX: (_random.nextDouble() - 0.5) * 0.0008, // Faster movement
          speedY: (_random.nextDouble() - 0.5) * 0.0005,
          color: blobColors[_random.nextInt(blobColors.length)],
          opacity: _random.nextDouble() * 0.2 + 0.15, // Higher opacity (15-35%)
          phaseOffset: _random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  static const Color primaryColor = Color(0xFF1E4D3C);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image (falls back to gradient if missing)
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF000000), // Pure black
                        Color(0xFF0A2E1A), // Dark green
                        Color(0xFF1B5E20), // Medium green
                        Color(0xFF2E7D32), // Light green
                      ],
                      stops: [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Semi-transparent dark overlay to make blobs more visible
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // Soft glowing blobs for depth
          Positioned(
            left: -size.width * 0.25,
            top: -size.width * 0.15,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -size.width * 0.2,
            bottom: -size.width * 0.1,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating green blobs animation
          AnimatedBuilder(
            animation: _blobController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: FloatingBlobPainter(
                  blobs: _blobs,
                  time: _blobController.value * 2 * pi,
                ),
              );
            },
          ),

          // Floating particles animation
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ParticlePainter(
                  particles: _particles,
                  time: _particleController.value * 2 * pi,
                ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Centered RouteX logo and text
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/RouteX.png',
                            width: size.width * 0.75,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.map,
                                size: 200,
                                color: Colors.white,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'RouteX',
                            style: GoogleFonts.oxanium(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Start button area
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondary) =>
                                            const GetStartedScreen(),
                                    transitionsBuilder:
                                        (context, animation, secondary, child) {
                                          final offset =
                                              Tween<Offset>(
                                                begin: const Offset(0.0, 0.12),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 32.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: primaryColor,
                                      size: 22,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Get Started',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Particle data class
class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double wobbleOffset;
  final double wobbleSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.wobbleOffset,
    required this.wobbleSpeed,
  });
}

// Custom painter for floating particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double time;

  ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      double newY = particle.y - particle.speed * 0.01;
      double wobbleX =
          sin(time * particle.wobbleSpeed + particle.wobbleOffset) * 0.02;
      double newX = particle.x + wobbleX;

      // Reset particle when it goes off screen
      if (newY < -0.1) {
        newY = 1.1;
        newX = Random().nextDouble();
      }

      // Update particle
      particle.x = newX;
      particle.y = newY;

      // Draw particle
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Add glow effect
      final glowPaint = Paint()
        ..color = Colors.white.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(newX * size.width, newY * size.height),
        particle.size * 1.5,
        glowPaint,
      );

      canvas.drawCircle(
        Offset(newX * size.width, newY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Floating blob data class
class FloatingBlob {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final Color color;
  final double opacity;
  final double phaseOffset;

  FloatingBlob({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.opacity,
    required this.phaseOffset,
  });
}

// Custom painter for floating green blobs
class FloatingBlobPainter extends CustomPainter {
  final List<FloatingBlob> blobs;
  final double time;

  FloatingBlobPainter({required this.blobs, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (var blob in blobs) {
      // Update blob position with slow floating movement
      double wobbleX = sin(time * 0.5 + blob.phaseOffset) * 0.01;
      double wobbleY = cos(time * 0.3 + blob.phaseOffset) * 0.008;

      blob.x += blob.speedX + wobbleX;
      blob.y += blob.speedY + wobbleY;

      // Wrap around screen
      if (blob.x < -0.2) blob.x = 1.2;
      if (blob.x > 1.2) blob.x = -0.2;
      if (blob.y < -0.2) blob.y = 1.2;
      if (blob.y > 1.2) blob.y = -0.2;

      // Draw blob with glow effect - more visible
      final center = Offset(blob.x * size.width, blob.y * size.height);

      // Draw outer glow - larger blur
      final glowPaint = Paint()
        ..color = blob.color.withValues(alpha: blob.opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
      canvas.drawCircle(center, blob.size * 0.7, glowPaint);

      // Draw solid inner blob
      final innerGradient = RadialGradient(
        colors: [
          blob.color.withValues(alpha: blob.opacity * 1.2),
          blob.color.withValues(alpha: blob.opacity * 0.8),
        ],
      );

      final rect = Rect.fromCenter(
        center: center,
        width: blob.size,
        height: blob.size * 0.7,
      );

      final paint = Paint()..shader = innerGradient.createShader(rect);

      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(FloatingBlobPainter oldDelegate) => true;
}
