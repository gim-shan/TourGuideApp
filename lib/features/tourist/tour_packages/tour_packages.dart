import 'package:flutter/material.dart';

class TourPackagesScreen extends StatefulWidget {
  const TourPackagesScreen({super.key});

  @override
  State<TourPackagesScreen> createState() => _TourPackagesScreenState();
}

class _TourPackagesScreenState extends State<TourPackagesScreen> {
  final Color primaryGreen = const Color(0xFF00A008);

  // Controllers
  final PageController _countrysideController = PageController(viewportFraction: 1.0);
  final PageController _beachController = PageController(viewportFraction: 1.0);
  final PageController _citiesController = PageController(viewportFraction: 1.0);
  final PageController _wildlifeController = PageController(viewportFraction: 1.0);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // DAta List
  final List<Map<String, dynamic>> countrysidePackages = [
    {
      "image": "assets/images/Rectangle128.png",
      "title": "The Emerald Wellness &\nTea Retreat",
      "price": "\$700-\$950",
      "rating": "4.8",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle130.png",
      "title": "The Heritage & Highline\nJourney",
      "price": "\$750-\$900",
      "rating": "4.9",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle135.png",
      "title": "The Peaks & Pines Adventure\n(Ella Experience)",
      "price": "\$450-\$600",
      "rating": "4.9",
      "isFavorite": false,
    },
  ];

  final List<Map<String, dynamic>> beachPackages = [
    {
      "image": "assets/images/Rectangle129.png",
      "title": "The Azure Horizon: Private\nSouthern Charter",
      "price": "\$1200-\$1800",
      "rating": "4.9",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle131.png",
      "title": "The Wild & Coastal Escape",
      "price": "\$650-\$800",
      "rating": "4.8",
      "isFavorite": false,
    },
  ];

  final List<Map<String, dynamic>> cityPackages = [
    {
      "image": "assets/images/Rectangle133.png",
      "title": "The Lost Kingdoms & Ancient\nMonasteries (Hidden Heritage)",
      "price": "\$550-\$700",
      "rating": "4.7",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle136.png",
      "title": "Festival & Folklore: The Esala\nPerahera Special",
      "price": "\$900-\$1200",
      "rating": "4.7",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle134.png",
      "title": "The Northern Soul: Tamil\nHeritage & Jaffna Islands",
      "price": "\$650-\$850",
      "rating": "4.8",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle137.png",
      "title": "The Colonial Coast: Galle\nFort & Beyond",
      "price": "\$350-\$500",
      "rating": "4.9",
      "isFavorite": false,
    },
  ];

  final List<Map<String, dynamic>> wildlifePackages = [
    {
      "image": "assets/images/Rectangle132.png",
      "title": "The Masks and Melodies",
      "price": "\$150-\$250",
      "rating": "4.9",
      "isFavorite": false,
    },
    {
      "image": "assets/images/Rectangle138.png",
      "title": "The Leopard's Kingdom: Yala\nSafari Expedition",
      "price": "\$500-\$750",
      "rating": "4.9",
      "isFavorite": false,
    },
  ];

  List<Map<String, dynamic>> get _allPackages {
    return [
      ...countrysidePackages,
      ...beachPackages,
      ...cityPackages,
      ...wildlifePackages,
    ];
  }

  // Filter logic
  List<Map<String, dynamic>> _getFilteredPackages() {
    if (_searchQuery.isEmpty) return [];
    return _allPackages.where((package) {
      return package["title"].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _handleSeeMoreAction() {
    print("See More Action Triggered");
  }

  @override
  void dispose() {
    _countrysideController.dispose();
    _beachController.dispose();
    _citiesController.dispose();
    _wildlifeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchQuery.isNotEmpty;
    List<Map<String, dynamic>> searchResults = _getFilteredPackages();

    return Scaffold(
      backgroundColor: Colors.white,
      
      // Navigation Bar
      bottomNavigationBar: Container(
        height: 70, 
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), 
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3), 
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/icons/home1.png", width: 30, height: 30), 
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/icons/map2.png", width: 30, height: 30),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/icons/note3.png", width: 30, height: 30),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/icons/settings4.png", width: 30, height: 30),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (isSearching) {
              setState(() {
                _searchController.clear();
                _searchQuery = "";
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                image: const DecorationImage(
                  image: AssetImage("assets/images/profile1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      
      // search
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              margin: const EdgeInsets.only(top: 30, bottom: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: -1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Where will you wander today?",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'inter'),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          if (isSearching)
            ..._buildSearchResultsList(searchResults)
          else
            ..._buildHomeContent(),
            
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResultsList(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return [
        const SizedBox(height: 50),
        const Center(child: Text("No packages found", style: TextStyle(fontSize: 16, color: Colors.grey))),
      ];
    }
    return results.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onTap: _handleSeeMoreAction,
          child: _buildPackageCard(
            imagePath: item["image"],
            title: item["title"],
            price: item["price"],
            rating: item["rating"],
            isFavorite: item["isFavorite"],
            onFavoriteTap: () {
              setState(() {
                item["isFavorite"] = !item["isFavorite"];
              });
            },
            onSeeMore: _handleSeeMoreAction,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHomeContent() {
    return [
      // Build Your Own Adventure
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            color: const Color(0xFFECFFF4),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: Image.asset(
                  "assets/images/Rectangle127.png",
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image)),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Build your own Adventure.",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: 190,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A008),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 24),

      // Country Side
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildSectionHeader(
          "Country side",
          onLeftTap: () => _countrysideController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          onRightTap: () => _countrysideController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 360,
        child: PageView.builder(
          controller: _countrysideController,
          itemCount: countrysidePackages.length,
          clipBehavior: Clip.none,
          padEnds: false,
          itemBuilder: (context, index) {
            final item = countrysidePackages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: _buildPackageCard(
                imagePath: item["image"],
                title: item["title"],
                price: item["price"],
                rating: item["rating"],
                isFavorite: item["isFavorite"],
                onFavoriteTap: () {
                  setState(() { item["isFavorite"] = !item["isFavorite"]; });
                },
                onSeeMore: _handleSeeMoreAction,
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 30),

      // Beach
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildSectionHeader(
          "Beach",
          onLeftTap: () => _beachController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          onRightTap: () => _beachController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 360,
        child: PageView.builder(
          controller: _beachController,
          itemCount: beachPackages.length,
          clipBehavior: Clip.none,
          padEnds: false,
          itemBuilder: (context, index) {
            final item = beachPackages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: _buildPackageCard(
                imagePath: item["image"],
                title: item["title"],
                price: item["price"],
                rating: item["rating"],
                isFavorite: item["isFavorite"],
                onFavoriteTap: () {
                  setState(() { item["isFavorite"] = !item["isFavorite"]; });
                },
                onSeeMore: _handleSeeMoreAction,
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 30),

      // Cities
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildSectionHeader(
          "Cities",
          onLeftTap: () => _citiesController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          onRightTap: () => _citiesController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 360,
        child: PageView.builder(
          controller: _citiesController,
          itemCount: cityPackages.length,
          clipBehavior: Clip.none,
          padEnds: false,
          itemBuilder: (context, index) {
            final item = cityPackages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: _buildPackageCard(
                imagePath: item["image"],
                title: item["title"],
                price: item["price"],
                rating: item["rating"],
                isFavorite: item["isFavorite"],
                onFavoriteTap: () {
                  setState(() { item["isFavorite"] = !item["isFavorite"]; });
                },
                onSeeMore: _handleSeeMoreAction,
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 30),

      // Wildlife
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildSectionHeader(
          "Wildlife & Culture",
          onLeftTap: () => _wildlifeController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          onRightTap: () => _wildlifeController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 360,
        child: PageView.builder(
          controller: _wildlifeController,
          itemCount: wildlifePackages.length,
          clipBehavior: Clip.none,
          padEnds: false,
          itemBuilder: (context, index) {
            final item = wildlifePackages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: _buildPackageCard(
                imagePath: item["image"],
                title: item["title"],
                price: item["price"],
                rating: item["rating"],
                isFavorite: item["isFavorite"],
                onFavoriteTap: () {
                  setState(() { item["isFavorite"] = !item["isFavorite"]; });
                },
                onSeeMore: _handleSeeMoreAction,
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onLeftTap, VoidCallback? onRightTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onLeftTap,
          child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        InkWell(
          onTap: onRightTap,
          child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildPackageCard({
    required String imagePath,
    required String title,
    required String price,
    required String rating,
    required bool isFavorite,
    required VoidCallback onFavoriteTap,
    required VoidCallback onSeeMore,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFF00A008),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.1),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(color: Color(0xFF00A600), fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Roboto'),
                      ),
                      const TextSpan(
                        text: " per person",
                        style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: onSeeMore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: const Color(0xFF1E4D3C),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("See more", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
}