import 'package:flutter/material.dart';
import 'package:hidmo_app/features/guide/data/models/guide_profile.dart';
import 'package:hidmo_app/features/guide/data/services/guide_profile_service.dart';
import 'package:hidmo_app/features/guide/presentation/screens/guide_profile_screen.dart';
import 'package:hidmo_app/core/widgets/profile_avatar.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  static const Color _green = Color(0xff1b9c4d);

  final GuideProfileService _guideService = GuideProfileService();
  List<GuideProfile> _guides = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get real guides from Firestore
      final realGuides = await _guideService.getAllGuides();

      // Get dummy guides
      final dummyGuides = GuideProfileService.getDummyGuides();

      // Combine real guides + dummy guides (always show both)
      final guides = [...realGuides, ...dummyGuides];

      setState(() {
        _guides = guides;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Group guides by location
  Map<String, List<GuideProfile>> get _guidesByLocation {
    final Map<String, List<GuideProfile>> grouped = {};
    for (var guide in _guides) {
      final location = guide.location ?? 'Other';
      grouped.putIfAbsent(location, () => []);
      grouped[location]!.add(guide);
    }
    return grouped;
  }

  // filters
  String _selectedMainFilter =
      'Top Rated'; // 'Top Rated' or 'Experts' or 'Locations'
  String?
  _selectedExpertCategory; // e.g. 'leopard tracking', 'history', 'hiking and nature', 'story telling'
  String? _selectedLocation;

  final List<String> _expertCategories = [
    'leopard tracking',
    'history',
    'hiking and nature',
    'story telling',
  ];

  Widget _buildFilterChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMainFilterChip('Locations', Icons.location_on_outlined),
              const SizedBox(width: 8),
              _buildMainFilterChip('Top Rated', Icons.star),
              const SizedBox(width: 8),
              _buildMainFilterChip('Experts', Icons.flag),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedMainFilter == 'Experts')
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _expertCategories.map((cat) {
                final selected = _selectedExpertCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat[0].toUpperCase() + cat.substring(1)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedExpertCategory = selected ? null : cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        if (_selectedMainFilter == 'Locations')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildLocationDropdown(),
          ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    final locations = _guidesByLocation.keys.toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation,
          hint: const Text('Select location'),
          items: locations
              .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
              .toList(),
          onChanged: (v) => setState(() {
            _selectedLocation = v;
          }),
        ),
      ),
    );
  }

  Widget _buildMainFilterChip(String label, IconData icon) {
    final selected = _selectedMainFilter == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedMainFilter = label;
        if (label != 'Experts') _selectedExpertCategory = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(GuideProfile guide, int index) {
    final name = guide.name;
    final rating = guide.rating > 0 ? guide.rating.toStringAsFixed(1) : 'New';
    final trips = guide.totalTours;
    // Use a default price or you could add price to the model
    final price = 50; // Default price

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(guide);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(
                  userName: name,
                  size: 60,
                  showBorder: true,
                  borderWidth: 3,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(rating, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Text(
                      '($trips tours)',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$$price/day',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. $name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Show verified badge if guide has certification
                if (guide.certification != null &&
                    guide.certification!.isNotEmpty)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            // Show specializations
            if (guide.specializations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: guide.specializations.take(2).map((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        spec,
                        style: const TextStyle(fontSize: 9, color: _green),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc107),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(100, 36),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GuideProfileScreen(guideId: guide.uid),
                      ),
                    );
                  },
                  child: const Text('View', style: TextStyle(fontSize: 13)),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(guide);
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Select',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E4D3C)),
                ),
              )
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $_error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadGuides,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadGuides,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        const Center(
                          child: Text(
                            'Find your Local Guide',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0e5a3c),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildFilterChips(),
                        const SizedBox(height: 18),

                        // Check if there are any guides
                        if (_guides.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_search,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No guides available yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    ' guides will appear here once they sign up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          // Sections per location (respect selected location)
                          ..._buildGuideSections(),
                        const SizedBox(height: 56),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildGuideSections() {
    final guidesByLocation = _guidesByLocation;
    final sections = <Widget>[];

    // Get unique locations from guides
    final locations = guidesByLocation.keys.toList();

    // Filter locations based on selected location
    final filteredLocations = _selectedLocation == null
        ? locations
        : locations.where((l) => l == _selectedLocation).toList();

    for (final location in filteredLocations) {
      final guidesInLocation = guidesByLocation[location] ?? [];

      // Apply filters
      var filteredGuides = _applyRealFilters(guidesInLocation);

      if (filteredGuides.isEmpty) continue;

      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              location,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: filteredGuides.length,
              itemBuilder: (context, i) =>
                  _buildGuideCard(filteredGuides[i], i),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('View more', style: TextStyle(color: Colors.black54)),
                Icon(Icons.arrow_right_alt),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      );
    }

    return sections;
  }

  List<GuideProfile> _applyRealFilters(List<GuideProfile> list) {
    var filtered = List<GuideProfile>.from(list);

    if (_selectedMainFilter == 'Top Rated') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    if (_selectedMainFilter == 'Experts' && _selectedExpertCategory != null) {
      filtered = filtered.where((g) {
        final specializations = g.specializations
            .map((e) => e.toLowerCase())
            .toList();
        return specializations.any(
          (spec) =>
              spec.contains(_selectedExpertCategory!.toLowerCase()) ||
              _selectedExpertCategory!.toLowerCase().contains(spec),
        );
      }).toList();
    }

    return filtered;
  }
}
