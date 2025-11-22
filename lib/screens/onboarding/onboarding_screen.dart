import 'package:flutter/material.dart';
import '../auth_selection.dart'; // Import the next screen so we can navigate to it

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Make sure these images exist in your assets folder!
  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/intro_bg.jpg", // Added the forest image first
      "title": "Discover the world, your way",
      "desc": "Unforgettable trips await your tap."
    },
    {
      "image": "assets/images/guide_bg.jpg",
      "title": "Meet Your Perfect Local Guide",
      "desc": "Get personalized tours and insider tips from guides who live where you're going."
    },
    {
      "image": "assets/images/vr_bg.jpg",
      "title": "Experience It Before You Go",
      "desc": "Step into your destination with immersive VR — see the sights before you even arrive!"
    },
    {
      "image": "assets/images/mood_bg.jpg",
      "title": "Mood Based Destinations Just for You",
      "desc": "Happy, relaxed, or adventurous — we'll find a place that matches your vibe."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Swipeable Background Images
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_pages[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // 2. The White Card Overlay
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _pages[_currentPage]['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3B2B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _pages[_currentPage]['desc']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3B2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          // Move to next slide
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Navigate to Auth Selection Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthSelectionScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}