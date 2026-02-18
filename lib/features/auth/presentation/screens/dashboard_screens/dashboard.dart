import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.65);

  double currentPage = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        "image": "assets/images/Rectangle 127 (3).png",
        "title": "The Heritage &\nHighline Journey",
        "price": "\$750-\$900",
        "rating": "4.9",
        "badge": true,
      },
      {
        "image": "assets/images/Rectangle 127 (4).png",
        "title": "The Wild &\nCoastal Escape",
        "price": "\$650-\$800",
        "rating": "4.8",
        "badge": false,
      },
      {
        "image": "assets/images/Rectangle 127 (5).png",
        "title": "The Northern\nCultural Explorer",
        "price": "\$850-\$1100",
        "rating": "4.7",
        "badge": false,
      },
      {
        "image": "assets/images/waterfall.jpg",
        "title": "Hill Country\nAdventure",
        "price": "\$700-\$950",
        "rating": "4.6",
        "badge": false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),

     
      body: selectedIndex == 0
    ? SafeArea(
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
                  const Text(
                    "Hello, Chris!",
                    style: TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 230, 220, 220).withOpacity(0.15),
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
                "TOP picks for you",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 30, 79, 32),
                ),
              ),
              const SizedBox(height: 13),

              SizedBox(
                height: 288,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    double diff = (currentPage - index).abs();
                    double scale = (1 - (diff * 0.20)).clamp(0.85, 1.0);

                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: _buildTopPickCard(
                          imagePath: card["image"] as String,
                          title: card["title"] as String,
                          price: card["price"] as String,
                          rating: card["rating"] as String,
                          showBadge: card["badge"] as bool,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 27),
                   _buildFeatureGrid(),

            ],
          ),
        ),
      )
    )
    
    : Center(
        child: Text(
          selectedIndex == 1
              ? "Map Page"
              : selectedIndex == 2
                  ? "Explore Page"
                  : "Settings Page",
          style: const TextStyle(fontSize: 24),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 60,
        backgroundColor: const Color.fromARGB(255, 241, 238, 238),
        color: Colors.white,
        buttonBackgroundColor: const Color(0xff0e5a3c),
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: [
          Image.asset(
            "assets/icons/Home.png",
            width: 24,
            height: 24,
            color: selectedIndex == 0 ? Colors.white : const Color(0xff0e5a3c),
          ),
          Image.asset(
            "assets/icons/pngimg.com - google_maps_pin_PNG55 1.png",
            width: 24,
            height: 24,
            color: selectedIndex == 1 ? Colors.white : const Color(0xff0e5a3c),
          ),
          Image.asset(
            "assets/icons/image 18.png",
            width: 24,
            height: 24,
            color: selectedIndex == 2 ? Colors.white : const Color(0xff0e5a3c),
          ),
          Image.asset(
            "assets/icons/Settings.png",
            width: 24,
            height: 24,
            color: selectedIndex == 3 ? Colors.white : const Color(0xff0e5a3c),
          ),
        ],
       onTap: (index) {
           setState(() {
              selectedIndex = index;
          });
        },    
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
}) {
  return Container(
    width: 178,
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28), bottom: Radius.circular(39)),
              child: Image.asset(
                imagePath,
                height: 166,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            if (showBadge)
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 55, 36),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Traveller's Choice",
                    style: TextStyle(color: Color.fromARGB(255, 98, 255, 0), fontSize: 9, fontWeight: FontWeight.bold,),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(rating, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(price,
                      style: const TextStyle(
                          color: Color(0xff1b9c4d), fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 4),
                  const Text("per person", style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Container(
                    height: 24,
                    width: 110,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xffd8d8d8), borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "See more",
                      style: TextStyle(color: Color.fromARGB(255, 28, 66, 43), fontSize: 11,fontWeight: FontWeight.bold),
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

Widget _buildFeatureGrid() {
  final features = [
    {"icon": "assets/images/image-Photoroom 1.png", "title": "Chat"},
    {"icon": "assets/images/image-Photoroom (1) 2.png", "title": "Tour Packages"},
    {"icon": "assets/images/image-Photoroom (2) 1.png", "title": "Tour Guide"},
    {"icon": "assets/images/unnamed-Photoroom 1.png", "title": "Live Events"},
    {"icon": "assets/images/image-Photoroom (3) 1.png", "title": "AR/VR"},
    {"icon": "assets/images/image-Photoroom (4) 1.png", "title": "Translator"},
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: features.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing:0,
      crossAxisSpacing: 5,
      childAspectRatio: 0.988,
    ),
    itemBuilder: (context, index) {
      
      return _AnimatedFeatureCard(
          icon: features[index]["icon"]!,
          title: features[index]["title"]!,
        );

    },
  );
  
}
class _AnimatedFeatureCard extends StatefulWidget {
  final String icon;
  final String title;

  const _AnimatedFeatureCard({
    required this.icon,
    required this.title,
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

   
    print("${widget.title} tapped");
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
                  color: isPressed
                      ? const Color(0xff0b3f2c)
                      : const Color.fromARGB(255, 15, 54, 38),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: isPressed ? 4 : 8,
                      offset: Offset(0, isPressed ? 3 : 7),
                    ),
                  ],
                ),
                child: Image.asset(widget.icon),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




