import 'package:flutter/material.dart';
import 'onboarding_content.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFBCCCA7);
    final Color buttonColor = const Color(0xFF1D4D3F);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. The Swipeable Content (Images)
            PageView.builder(
              controller: _pageController,
              itemCount: contents.length,
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                // We use a Stack here for every page to layer Image behind Text
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // --- THE IMAGE (Layer 1 - Bottom) ---
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 250, // Leave space at bottom for the card
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(contents[index].image),
                            fit: BoxFit.cover, // Ensures image fills the space
                          ),
                        ),
                      ),
                    ),

                    // --- THE TEXT BOX (Layer 2 - Top) ---
                    // This container sits ON TOP of the image
                    Positioned(
                      bottom: 80, // Lifted up from the very bottom
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Wrap content height
                          children: [
                            Text(
                              contents[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: buttonColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              contents[index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_pageIndex == contents.length - 1) {
                                    print("Navigate to Next Screen");
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // 2. Top Back Button (Floating on top of everything)
            Positioned(
              top: 10,
              left: 16,
              child: _pageIndex != 0
                  ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              )
                  : const SizedBox(),
            ),

            // 3. Skip Button (Floating at the bottom right)
            Positioned(
              bottom: 20,
              right: 20,
              child: TextButton(
                onPressed: () {
                  print("Skip Pressed");
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}