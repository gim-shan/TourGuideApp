import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidmo_app/features/tourist/tour_packages/tour_packages.dart';
import 'package:hidmo_app/features/ar/ar_preview_screen.dart';
import 'package:hidmo_app/features/chat/ai_assistant_screen.dart';
import 'package:hidmo_app/features/guides/presentation/screens/guides_screen.dart';
import 'package:hidmo_app/features/translator/translator_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  late final PageController _tabPageController;
  Timer? _topPicksAutoSlideTimer;
  bool _isTopPicksInteracting = false;

  late int selectedIndex;
  String? _userName;

  static const Color _navGreen = Color(0xff1b9c4d);
  static const Color _navIdle = Color(0xff0e5a3c);

  final List<Map<String, Object>> _cards = [
    {
      "image": "assets/images/ninearch.png",
      "title": "The Heritage & Highline Journey",
      "price": "\$750-\$900",
      "rating": "4.9",
      "badge": true,
      "route":
          "Route: Colombo \u2192 Sigiriya \u2192 Kandy \u2192 Nuwara Eliya \u2192 Ella",
      "duration": "Duration: 7 Days / 6 Nights",
    },
    {
      "image": "assets/images/mirissa.jpg",
      "title": "The Wild & Coastal Escape",
      "price": "\$650-\$800",
      "rating": "4.8",
      "badge": false,
      "route":
          "Route: Colombo \u2192 Udawalawe \u2192 Yala \u2192 Mirissa \u2192 Galle",
      "duration": "Duration: 6 Days / 5 Nights",
    },
    {
      "image": "assets/images/jaffna.jpg",
      "title": "The Northern Cultural Explorer",
      "price": "\$850-\$1100",
      "rating": "4.7",
      "badge": false,
      "route":
          "Route: Colombo \u2192 Anuradhapura \u2192 Jaffna \u2192 Trincomalee",
      "duration": "Duration: 8 Days / 7 Nights",
    },
    {
      "image": "assets/images/waterfall.jpg",
      "title": "Hill Country Adventure",
      "price": "\$700-\$950",
      "rating": "4.6",
      "badge": false,
      "route":
          "Route: Colombo \u2192 Kandy \u2192 Nuwara Eliya \u2192 Ella \u2192 Badulla",
      "duration": "Duration: 6 Days / 5 Nights",
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex.clamp(0, 3);
    _tabPageController = PageController(initialPage: selectedIndex);

    _loadUserName();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTopPicksAutoSlide();
    });
  }

  void _startTopPicksAutoSlide() {
    _topPicksAutoSlideTimer?.cancel();
    if (_cards.length < 2) return;

    _topPicksAutoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _isTopPicksInteracting) return;
      if (!_pageController.hasClients) return;

      final current = (_pageController.page ?? _pageController.initialPage)
          .round()
          .clamp(0, _cards.length - 1);
      final next = (current + 1) % _cards.length;

      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _topPicksAutoSlideTimer?.cancel();
    _pageController.dispose();
    _tabPageController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),

      body: PageView(
        controller: _tabPageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, ${_userName == null || _userName!.isEmpty ? 'Traveller' : _userName!}!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 19, 53, 20),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/icons/User.png",
                              width: 38,
                              height: 38,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),

                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              230,
                              220,
                              220,
                            ).withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, size: 22),
                          hintText: "Where will you wander today?",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Top picks for you",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 79, 32),
                      ),
                    ),
                    const SizedBox(height: 13),

                    SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          final page = _pageController.hasClients
                              ? (_pageController.page ??
                                    _pageController.initialPage.toDouble())
                              : _pageController.initialPage.toDouble();

                          return GestureDetector(
                            onPanDown: (_) => _isTopPicksInteracting = true,
                            onPanCancel: () => _isTopPicksInteracting = false,
                            onPanEnd: (_) => _isTopPicksInteracting = false,
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _cards.length,
                              itemBuilder: (context, index) {
                                final card = _cards[index];
                                final diff = (page - index).abs();
                                final scale = (1 - (diff * 0.20)).clamp(
                                  0.9,
                                  1.0,
                                );

                                return Transform.scale(
                                  scale: scale,
                                  child: _buildTopPickCard(
                                    imagePath: card["image"] as String,
                                    title: card["title"] as String,
                                    price: card["price"] as String,
                                    rating: card["rating"] as String,
                                    showBadge: card["badge"] as bool,
                                    route: card["route"] as String? ?? "",
                                    duration: card["duration"] as String? ?? "",
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 27),
                    _buildFeatureGrid(context),
                  ],
                ),
              ),
            ),
          ),
          const Center(child: Text("Map Page", style: TextStyle(fontSize: 24))),
          SafeArea(
            child: TourPackagesScreen(initialIndex: 2, showBottomNav: false),
          ),
          SafeArea(
            child: TourPackagesScreen(initialIndex: 3, showBottomNav: false),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 64,
          backgroundColor: Colors.white,
          indicatorColor: _navGreen,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 0, height: 0),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 26,
              color: isSelected ? Colors.white : _navIdle,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            _tabPageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
            );
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.place_rounded),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Bookings',
            ),
          ],
        ),
      ),
    );
  }
}

//card widget
Widget _buildTopPickCard({
  required String imagePath,
  required String title,
  required String price,
  required String rating,
  bool showBadge = false,
  String? route,
  String? duration,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(33),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
                bottom: Radius.circular(39),
              ),
              child: Image.asset(
                imagePath,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            if (showBadge)
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 55, 36),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Traveller's Choice",
                    style: TextStyle(
                      color: Color.fromARGB(255, 98, 255, 0),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 18,
              top: 8,
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 16,
                  color: Color.fromARGB(255, 65, 141, 18),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(rating, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xff1b9c4d),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "per person",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              if ((route != null && route.isNotEmpty) ||
                  (duration != null && duration.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (route != null && route.isNotEmpty)
                        Text(
                          route,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      if (duration != null && duration.isNotEmpty)
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Container(
                    height: 24,
                    width: 110,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffd8d8d8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "See more",
                      style: TextStyle(
                        color: Color.fromARGB(255, 28, 66, 43),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildFeatureGrid(BuildContext context) {
  final features = [
    {
      "icon": Icons.chat_bubble_outline,
      "title": "Chat",
      "color": const Color(0xff0e5a3c),
    },
    {
      "icon": Icons.card_travel_outlined,
      "title": "Tour Packages",
      "color": const Color(0xff1b9c4d),
    },
    {
      "icon": Icons.person_pin_circle_outlined,
      "title": "Tour Guide",
      "color": const Color(0xff0e5a3c),
    },
    {
      "icon": Icons.event_available_outlined,
      "title": "Live Events",
      "color": const Color(0xff1b9c4d),
    },
    {
      "icon": Icons.vrpano_outlined,
      "title": "AR/VR",
      "color": const Color(0xff0e5a3c),
    },
    {
      "icon": Icons.translate_outlined,
      "title": "Translator",
      "color": const Color(0xff1b9c4d),
    },
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: features.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 0,
      crossAxisSpacing: 5,
      childAspectRatio: 0.988,
    ),
    itemBuilder: (context, index) {
      return _AnimatedFeatureCard(
        icon: features[index]["icon"] as IconData,
        title: features[index]["title"] as String,
        color: features[index]["color"] as Color,
        onTap: () {
          final title = features[index]["title"] as String;
          if (title == "Chat") {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
            );
            return;
          } else if (title == "Tour Packages") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TourPackagesScreen(initialIndex: 2),
              ),
            );
            return;
          } else if (title == "Tour Guide") {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GuidesScreen()));
            return;
          } else if (title == "AR/VR") {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ArPreviewListScreen()),
            );
            return;
          } else if (title == "Translator") {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TranslatorScreen()));
            return;
          }
        },
      );
    },
  );
}

class _AnimatedFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const _AnimatedFeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard> {
  bool isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => isPressed = false);
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: isPressed ? 1.05 : 1.0,
        child: Column(
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                height: 70,
                width: 95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: isPressed ? 10 : 16,
                      offset: Offset(0, isPressed ? 4 : 8),
                    ),
                  ],
                ),
                child: Icon(widget.icon, size: 32, color: widget.color),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
