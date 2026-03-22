import 'package:flutter/material.dart';

class TourGuide1 extends StatefulWidget {
  const TourGuide1({super.key});

  @override
  State<TourGuide1> createState() => _TourGuide1State();
}

class _TourGuide1State extends State<TourGuide1> {
  int selectedFilterIndex = 0;
  int _selectedNavIndex = 0;

  String selectedLocation = 'All';
  String selectedExpert = 'All';

  final List<String> locationOptions = ['All', 'Galle', 'Ella', 'Anuradhapura'];
  final List<String> expertOptions = [
    'All',
    'History',
    'Leopard Tracking',
    'Hiking & Nature',
  ];

  final Map<String, List<Map<String, dynamic>>> locationGuides = {
    'Galle': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
      {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
      {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
    ],
    'Ella': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
      {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
      {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
    ],
    'Anuradhapura': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
    ],
  };

  final Map<String, List<Map<String, dynamic>>> expertGuides = {
    'History': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
      {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
      {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
    ],
    'Leopard Tracking': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
      {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
      {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
    ],
    'Hiking & Nature': [
      {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
      {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 140,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: const Text(
            'Find your Local\nGuide',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 30, 77, 60),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              children: [
                _buildFilterChipWithDropdown(
                  index: 0,
                  icon: Icons.location_on_outlined,
                  label: 'Locations',
                  dropdownValue: selectedLocation,
                  dropdownItems: locationOptions,
                  onDropdownChanged: (val) {
                    setState(() {
                      selectedLocation = val!;
                      selectedFilterIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(1, Icons.star_border, 'Top Rated'),
                const SizedBox(width: 8),
                _buildFilterChipWithDropdown(
                  index: 2,
                  icon: Icons.flag_outlined,
                  label: 'Experts',
                  dropdownValue: selectedExpert,
                  dropdownItems: expertOptions,
                  onDropdownChanged: (val) {
                    setState(() {
                      selectedExpert = val!;
                      selectedFilterIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildContent(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilterChip(int index, IconData icon, String label) {
    final bool isSelected = selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilterIndex = index),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 109, 115, 112)
                : const Color.fromARGB(255, 0, 160, 8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChipWithDropdown({
    required int index,
    required IconData icon,
    required String label,
    required String dropdownValue,
    required List<String> dropdownItems,
    required ValueChanged<String?> onDropdownChanged,
  }) {
    final bool isSelected = selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilterIndex = index),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 109, 115, 112)
                : const Color.fromARGB(255, 0, 160, 8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 14,
              ),
              isDense: true,
              isExpanded: true,
              dropdownColor: const Color.fromARGB(255, 0, 160, 8),
              selectedItemBuilder: (context) {
                return dropdownItems.map((_) {
                  return Row(
                    children: [
                      Icon(icon, size: 18, color: Colors.white),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          dropdownValue == 'All' ? label : dropdownValue,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onDropdownChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedFilterIndex) {
      case 0:
        return _buildLocationsView();
      case 1:
        return _buildTopRatedView();
      case 2:
        return _buildExpertsView();
      default:
        return _buildLocationsView();
    }
  }

  Widget _buildLocationsView() {
    if (selectedLocation == 'All') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in locationGuides.entries) ...[
              _buildSectionHeader(entry.key),
              const SizedBox(height: 16),
              _buildGuideGrid(entry.value),
              _buildViewMore(),
              const SizedBox(height: 32),
            ],
          ],
        ),
      );
    } else {
      final guides = locationGuides[selectedLocation] ?? [];
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(selectedLocation),
            const SizedBox(height: 16),
            _buildGuideGrid(guides),
          ],
        ),
      );
    }
  }

  Widget _buildTopRatedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGuideGrid([
            {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
            {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
            {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
            {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
            {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
            {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
            {'name': 'Nimal Perera', 'rating': 4.7, 'trips': 70},
            {'name': 'Sunil D.', 'rating': 4.6, 'trips': 55},
            {'name': 'John Perera', 'rating': 4.9, 'trips': 98},
            {'name': 'Kamal De Silva', 'rating': 4.8, 'trips': 88},
          ]),
        ],
      ),
    );
  }

  Widget _buildExpertsView() {
    if (selectedExpert == 'All') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in expertGuides.entries) ...[
              _buildSectionHeader(entry.key),
              const SizedBox(height: 16),
              _buildGuideGrid(entry.value),
              _buildViewMore(),
              const SizedBox(height: 32),
            ],
          ],
        ),
      );
    } else {
      final guides = expertGuides[selectedExpert] ?? [];
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(selectedExpert),
            const SizedBox(height: 16),
            _buildGuideGrid(guides),
          ],
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _buildGuideGrid(List<Map<String, dynamic>> guides) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 17,
        mainAxisSpacing: 19,
        childAspectRatio: 161 / 164,
      ),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return _buildGuideCard(
          number: index + 1,
          name: guide['name'],
          rating: guide['rating'],
          trips: guide['trips'],
        );
      },
    );
  }

  Widget _buildGuideCard({
    required int number,
    required String name,
    required double rating,
    required int trips,
  }) {
    return SizedBox(
      width: 161,
      height: 164,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: SizedBox(
                width: 16,
                height: 16,
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.shield,
                      size: 16,
                      color: Color.fromARGB(255, 41, 185, 57),
                    ),
                    Icon(
                      Icons.check,
                      size: 10,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 61,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00A008),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFD9D9D9),
                          radius: 26,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD700),
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '($trips trips)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(135, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$number. $name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: 95,
                    height: 24,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBB00),
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'View profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
    );
  }

  Widget _buildViewMore() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'View more',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 1),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
          _buildNavItem(
            1,
            Icons.location_on_outlined,
            Icons.location_on,
            'Locations',
          ),
          _buildNavItem(2, Icons.article_outlined, Icons.article, 'Articles'),
          _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
  ) {
    final bool isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? filledIcon : outlinedIcon,
            size: 26,
            color: isSelected
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
