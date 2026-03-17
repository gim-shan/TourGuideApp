import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34), // mobile frame
          child: SizedBox(
            width: 393,
            height: 852,
            child: Stack(
              children: [
                //  Gradient background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF0B2E1A),
                        Color(0xFF1B5E20),
                      ],
                    ),
                  ),
                ),

                // soft overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                        Colors.black.withOpacity(0.18),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      // title (right aligned)
                      Padding(
                        padding: const EdgeInsets.only(top: 36, right: 22),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Guiding every\nadventure.",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Input bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.mic_none,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  "Ask Gemini",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  size: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ✅ Bottom Navigation (icons matched)
                      Container(
                        height: 60,
                        color: Colors.white.withOpacity(0.95),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _navItemIcon(index: 0, icon: Icons.home_outlined),

                            // Location
                            _navItemWidget(
                              index: 1,
                              child: _locationMapIcon(color: _navColor(1)),
                            ),

                            //  Clipboard
                            _navItemIcon(
                              index: 2,
                              icon: Icons.content_paste_outlined,
                            ),

                            _navItemIcon(
                              index: 3,
                              icon: Icons.settings_outlined,
                            ),
                          ],
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
    );
  }

  Color _navColor(int index) =>
      selectedIndex == index ? Colors.black : Colors.black87;

  Widget _navItemIcon({required int index, required IconData icon}) {
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      child: Icon(icon, size: 24, color: _navColor(index)),
    );
  }

  Widget _navItemWidget({required int index, required Widget child}) {
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      child: SizedBox(width: 34, height: 34, child: Center(child: child)),
    );
  }

  //  map
  Widget _locationMapIcon({required Color color}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.map_outlined, size: 24, color: color),
        Positioned(
          top: 3,
          child: Icon(Icons.location_on, size: 16, color: color),
        ),
      ],
    );
  }
}
