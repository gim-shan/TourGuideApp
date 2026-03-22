import 'package:flutter/material.dart';
import 'package:hidmo_app/features/guides/presentation/screens/guide_profile_screen.dart';
import 'package:hidmo_app/core/widgets/profile_avatar.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  static const Color _green = Color(0xff1b9c4d);

  // sample data extended with `verified`, `expertise` and `price`
  final Map<String, List<Map<String, Object>>> _sample = {
    "Galle": [
      {
        "name": "John Perera",
        "rating": "4.9",
        "trips": 98,
        "price": 50,
        "verified": true,
        "expertise": ["history", "story telling"],
      },
      {
        "name": "Kamal De SIlva",
        "rating": "4.8",
        "trips": 88,
        "price": 45,
        "verified": true,
        "expertise": ["leopard tracking", "hiking and nature"],
      },
      {
        "name": "Nimal Perera",
        "rating": "4.7",
        "trips": 70,
        "price": 35,
        "verified": false,
        "expertise": ["history"],
      },
      {
        "name": "Sunil D.",
        "rating": "4.6",
        "trips": 55,
        "price": 30,
        "verified": false,
        "expertise": ["story telling"],
      },
    ],
    "Kandy": [
      {
        "name": "Sunitha Raj",
        "rating": "4.9",
        "trips": 120,
        "price": 55,
        "verified": true,
        "expertise": ["history", "story telling"],
      },
      {
        "name": "Aruna Kumar",
        "rating": "4.7",
        "trips": 65,
        "price": 40,
        "verified": false,
        "expertise": ["hiking and nature"],
      },
      {
        "name": "Priya L.",
        "rating": "4.6",
        "trips": 42,
        "price": 35,
        "verified": false,
        "expertise": ["leopard tracking"],
      },
      {
        "name": "Rohan T.",
        "rating": "4.5",
        "trips": 30,
        "price": 30,
        "verified": false,
        "expertise": ["story telling"],
      },
    ],
    "Trincomalee": [
      {
        "name": "Nadeesha P.",
        "rating": "4.8",
        "trips": 76,
        "price": 45,
        "verified": true,
        "expertise": ["history"],
      },
      {
        "name": "Lasitha M.",
        "rating": "4.6",
        "trips": 54,
        "price": 35,
        "verified": false,
        "expertise": ["hiking and nature"],
      },
      {
        "name": "Dulip S.",
        "rating": "4.4",
        "trips": 22,
        "price": 30,
        "verified": false,
        "expertise": ["leopard tracking"],
      },
      {
        "name": "Maya K.",
        "rating": "4.3",
        "trips": 18,
        "price": 25,
        "verified": false,
        "expertise": ["story telling"],
      },
    ],
    "Mirissa": [
      {
        "name": "Kusuma R.",
        "rating": "4.9",
        "trips": 102,
        "price": 50,
        "verified": true,
        "expertise": ["hiking and nature"],
      },
      {
        "name": "Vasantha F.",
        "rating": "4.7",
        "trips": 68,
        "price": 40,
        "verified": false,
        "expertise": ["history"],
      },
      {
        "name": "Saman G.",
        "rating": "4.5",
        "trips": 44,
        "price": 35,
        "verified": false,
        "expertise": ["leopard tracking"],
      },
      {
        "name": "Leena Q.",
        "rating": "4.4",
        "trips": 26,
        "price": 30,
        "verified": false,
        "expertise": ["story telling"],
      },
    ],
    "Ella": [
      {
        "name": "John Perera",
        "rating": "4.9",
        "trips": 98,
        "price": 55,
        "verified": true,
        "expertise": ["history"],
      },
      {
        "name": "Kamal De SIlva",
        "rating": "4.8",
        "trips": 88,
        "price": 50,
        "verified": true,
        "expertise": ["leopard tracking"],
      },
      {
        "name": "Nimal Perera",
        "rating": "4.7",
        "trips": 70,
        "price": 40,
        "verified": false,
        "expertise": ["hiking and nature"],
      },
      {
        "name": "Sunil D.",
        "rating": "4.6",
        "trips": 55,
        "price": 35,
        "verified": false,
        "expertise": ["story telling"],
      },
    ],
    "Anuradhapura": [
      {
        "name": "John Perera",
        "rating": "4.9",
        "price": 50,
        "trips": 98,
        "verified": true,
        "expertise": ["history"],
      },
      {
        "name": "Kamal De SIlva",
        "rating": "4.8",
        "price": 45,
        "trips": 88,
        "verified": true,
        "expertise": ["hiking and nature"],
      },
      {
        "name": "Nimal Perera",
        "rating": "4.7",
        "price": 35,
        "trips": 70,
        "verified": false,
        "expertise": ["story telling"],
      },
      {
        "name": "Sunil D.",
        "rating": "4.6",
        "price": 30,
        "trips": 55,
        "verified": false,
        "expertise": ["leopard tracking"],
      },
    ],
  };

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
    final locations = _sample.keys.toList();
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

  Widget _buildGuideCard(Map<String, Object> info, int index) {
    final name = info['name'] as String;
    final rating = info['rating'] as String;
    final trips = info['trips'] as int;
    final price = (info['price'] as int?) ?? 0;
    final verified = (info['verified'] as bool?) ?? false;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(info);
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
                  size: 64,
                  showBorder: true,
                  borderWidth: 4,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rating),
                      ],
                    ),
                    Text(
                      '($trips trips)',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$$price/day',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                if (verified)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
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
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc107),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(100, 36),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GuideProfileScreen(info: info),
                      ),
                    );
                  },
                  child: const Text('View'),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(info);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Select',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  List<Map<String, Object>> _applyFilters(List<Map<String, Object>> list) {
    var filtered = List<Map<String, Object>>.from(list);

    if (_selectedMainFilter == 'Top Rated') {
      filtered.sort((a, b) {
        final ra = double.tryParse(a['rating'] as String) ?? 0;
        final rb = double.tryParse(b['rating'] as String) ?? 0;
        return rb.compareTo(ra);
      });
    }

    if (_selectedMainFilter == 'Experts' && _selectedExpertCategory != null) {
      filtered = filtered.where((g) {
        final expertise =
            (g['expertise'] as List<Object>?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];
        return expertise.contains(_selectedExpertCategory);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),
      body: SafeArea(
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

                // Sections per location (respect selected location)
                ..._sample.entries
                    .where(
                      (e) =>
                          _selectedLocation == null ||
                          e.key == _selectedLocation,
                    )
                    .map((entry) {
                      final location = entry.key;
                      final list = _applyFilters(
                        List<Map<String, Object>>.from(entry.value),
                      );
                      if (list.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.6,
                                ),
                            itemCount: list.length,
                            itemBuilder: (context, i) =>
                                _buildGuideCard(list[i], i),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                'View more',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Icon(Icons.arrow_right_alt),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                      );
                    })
                    .toList(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
