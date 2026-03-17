import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hidmo_app/features/tourist/hotels/explore_hotels_screen.dart';

class TourPackageHighlight {
  const TourPackageHighlight({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class TourPackageDetailScreen extends StatefulWidget {
  const TourPackageDetailScreen({
    super.key,
    this.title = "The Emerald Wellness & Tea Retreat",
    this.rating = "4.8",
    this.description =
        "Designed for travelers seeking \"Slow Travel\"focusing on mental health, meditation, and the serenity of the highlands.",
    this.route = "Kandy → Knuckles Mountain Range → Ella → Deniyaya",
    this.duration = "6 Days / 5 Nights",
    this.guide = "Wellness Coach & Local Naturalist",
    this.guideAvatarPath = "assets/images/guide.jpg",
    this.images = const [
      "assets/images/sinharaja.jpg",
      "assets/images/knuckles.jpg",
      "assets/images/ella.jpg",
      "assets/images/deniyaya.JPG",
      "assets/images/kandy.jpg",
    ],
    this.initialAccommodationName = "98 Acres Resort and Spa",
    this.highlights = const [
      TourPackageHighlight(
        icon: Icons.forest_rounded,
        title: "Forest Bathing",
        description:
            "A mindful trekking experience in the Knuckles Forest Reserve (UNESCO site).",
      ),
      TourPackageHighlight(
        icon: Icons.eco_rounded,
        title: "Tea Leaf to Cup",
        description:
            "A private workshop at a sustainable organic tea plantation, ending with a professional tasting session.",
      ),
      TourPackageHighlight(
        icon: Icons.self_improvement_rounded,
        title: "Sunrise Yoga",
        description: "Daily morning sessions overlooking the Ella Gap.",
      ),
      TourPackageHighlight(
        icon: Icons.park_rounded,
        title: "Sinharaja Rainforest",
        description:
            "A guided tour through the last viable area of primary tropical rainforest in Sri Lanka to spot endemic birds.",
      ),
      TourPackageHighlight(
        icon: Icons.water_drop_rounded,
        title: "Waterfall Meditation",
        description:
            "A silent meditation session at the base of the secluded Bambarakanda Falls.",
      ),
    ],
    this.budgetUsd = "\$400 – \$550 per person",
    this.budgetLkr = "LKR 124,000 – LKR 171,000",
    this.budgetNote = "Includes luxury wellness resort stays and organic meals",
  });

  final String title;
  final String rating;
  final String description;
  final String route;
  final String duration;
  final String guide;
  final String? guideAvatarPath;
  final List<String> images;
  final String initialAccommodationName;
  final List<TourPackageHighlight> highlights;
  final String budgetUsd;
  final String? budgetLkr;
  final String? budgetNote;

  @override
  State<TourPackageDetailScreen> createState() =>
      _TourPackageDetailScreenState();
}

class _TourPackageDetailScreenState extends State<TourPackageDetailScreen> {
  static const Color _primaryGreen = Color(0xff1b9c4d);
  static const Color _textDark = Color(0xFF1E4D3C);
  static const Map<String, List<String>> _accommodationImagesByName = {
    "98 Acres Resort and Spa": [
      "assets/images/98acres1.jpg",
      "assets/images/98acres2.jpg",
      "assets/images/98acres3.jpeg",
    ],
    "Little England Cottages": [
      "assets/images/littleengland1.jpg",
      "assets/images/lilengland2.jpg",
    ],
    "Heritance Kandalama": [
      "assets/images/heritance1.jpg",
      "assets/images/heritance2.jpg",
      "assets/images/heritance3.jpg",
      "assets/images/heritance4.jpg",
    ],
    "Jetwing Vil Uyana": [
      "assets/images/jetwing.jpg",
      "assets/images/jetwing2.jpg",
      "assets/images/jetwing3.jpg",
    ],
  };

  late String _selectedAccommodation;
  late List<String> _activeAccommodationImages;
  int _accommodationImageIndex = 0;

  void _applyAccommodationSelection(String name) {
    final images = _accommodationImagesByName[name];
    setState(() {
      _selectedAccommodation = name;
      _activeAccommodationImages = images ?? const [];
      _accommodationImageIndex = 0;
    });
  }

  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  Timer? _imageAutoSlideTimer;
  bool _isImageInteracting = false;

  @override
  void initState() {
    super.initState();
    _selectedAccommodation = widget.initialAccommodationName;
    _activeAccommodationImages =
        _accommodationImagesByName[_selectedAccommodation] ?? const [];
    _currentImageIndex = 0;
    _imageController.addListener(() {
      final page = _imageController.page?.round() ?? 0;
      if (page != _currentImageIndex && mounted) {
        setState(() => _currentImageIndex = page);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _startImageAutoSlide());
  }

  void _startImageAutoSlide() {
    _imageAutoSlideTimer?.cancel();
    _imageAutoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _isImageInteracting) return;
      if (!_imageController.hasClients) return;
      if (widget.images.isEmpty) return;
      final next = (_currentImageIndex + 1) % widget.images.length;
      _imageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _imageAutoSlideTimer?.cancel();
    _imageController.dispose();
    super.dispose();
  }

  Widget _buildImageCarousel() {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onPanDown: (_) => _isImageInteracting = true,
          onPanEnd: (_) => _isImageInteracting = false,
          onPanCancel: () => _isImageInteracting = false,
          child: PageView.builder(
            controller: _imageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 64),
                ),
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentImageIndex == i ? 10 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentImageIndex == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _goToNextAccommodationImage() {
    if (_activeAccommodationImages.isEmpty) return;
    setState(() {
      _accommodationImageIndex =
          (_accommodationImageIndex + 1) % _activeAccommodationImages.length;
    });
  }

  void _goToPreviousAccommodationImage() {
    if (_activeAccommodationImages.isEmpty) return;
    setState(() {
      _accommodationImageIndex =
          (_accommodationImageIndex - 1 + _activeAccommodationImages.length) %
              _activeAccommodationImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: _buildImageCarousel(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4D3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        Icons.route,
                        "Route",
                        widget.route,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.schedule,
                        "Duration",
                        widget.duration,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.person,
                        "Guide",
                        widget.guide,
                        avatarPath: widget.guideAvatarPath,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Accommodation",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E4D3C),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final selected = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ExploreHotelsScreen(),
                                ),
                              );
                              if (!mounted) return;
                              if (selected is Map) {
                                final name = selected['name']?.toString();
                                if (name != null && name.trim().isNotEmpty) {
                                  _applyAccommodationSelection(name);
                                }
                              }
                            },
                            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                            label: const Text("Change"),
                            style: TextButton.styleFrom(
                              foregroundColor: _primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      _activeAccommodationImages.isNotEmpty
                                          ? _activeAccommodationImages[
                                              _accommodationImageIndex]
                                          : "assets/images/98acres1.jpg",
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: _ArrowCircleButton(
                                        icon: Icons.chevron_left_rounded,
                                        onPressed:
                                            _goToPreviousAccommodationImage,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: _ArrowCircleButton(
                                        icon: Icons.chevron_right_rounded,
                                        onPressed: _goToNextAccommodationImage,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        _activeAccommodationImages.length,
                                        (i) => Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          width: _accommodationImageIndex == i
                                              ? 10
                                              : 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: _accommodationImageIndex == i
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _primaryGreen.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.hotel_rounded,
                                    color: _primaryGreen,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedAccommodation,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E4D3C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Luxury resort stay included (5 nights)",
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.35,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: OutlinedButton.icon(
                                          onPressed: () async {
                                            final selected =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const ExploreHotelsScreen(),
                                              ),
                                            );
                                            if (!mounted) return;
                                            if (selected is Map) {
                                              final name = selected['name']
                                                  ?.toString();
                                              if (name != null &&
                                                  name.trim().isNotEmpty) {
                                                _applyAccommodationSelection(
                                                  name,
                                                );
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search_rounded,
                                            color: _primaryGreen,
                                            size: 18,
                                          ),
                                          label: Text(
                                            "Explore hotels",
                                            style: TextStyle(
                                              color: _primaryGreen,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: _primaryGreen,
                                              width: 1.8,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Highlights",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4D3C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.highlights.map(
                        (h) => _buildHighlightTile(
                          h.icon,
                          h.title,
                          h.description,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _primaryGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.savings, color: _primaryGreen, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Budget",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.budgetUsd,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _textDark,
                                    ),
                                  ),
                                  if (widget.budgetLkr != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.budgetLkr!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _textDark,
                                      ),
                                    ),
                                  ],
                                  if (widget.budgetNote != null)
                                    Text(
                                      widget.budgetNote!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: _primaryGreen.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.call, color: _primaryGreen, size: 20),
                      label: Text(
                        "Call Now",
                        style: TextStyle(
                          color: _primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: _primaryGreen, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    String? avatarPath,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _primaryGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1E4D3C),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (avatarPath != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: _primaryGreen.withOpacity(0.15),
              backgroundImage: AssetImage(avatarPath),
              onBackgroundImageError: (_, __) {},
            ),
          ),
      ],
    );
  }

  Widget _buildHighlightTile(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _primaryGreen, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E4D3C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.grey[700],
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

class _ArrowCircleButton extends StatelessWidget {
  const _ArrowCircleButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.25),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        splashRadius: 22,
        tooltip: null,
      ),
    );
  }
}
