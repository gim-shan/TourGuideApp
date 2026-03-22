import 'package:flutter/material.dart';
import 'package:hidmo_app/core/widgets/custom_app_bar.dart';
import 'package:hidmo_app/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:hidmo_app/features/auth/presentation/screens/dashboard_screens/dashboard.dart';
import 'package:hidmo_app/features/guides/presentation/screens/guides_screen.dart';
import 'package:hidmo_app/features/guide/data/models/guide_profile.dart';
import 'package:hidmo_app/features/tourist/hotels/explore_hotels_screen.dart';
import 'package:hidmo_app/features/tourist/payment/payment_screen.dart';

class TourCustomizerScreen extends StatefulWidget {
  const TourCustomizerScreen({super.key});

  @override
  State<TourCustomizerScreen> createState() => _TourCustomizerScreenState();
}

class _TourCustomizerScreenState extends State<TourCustomizerScreen> {
  int people = 1;
  DateTime? selectedDate;
  static const Color _navGreen = Color(0xff1b9c4d);
  static const Color _navIdle = Color(0xff0e5a3c);
  int _selectedNavIndex = 2;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1b9c4d),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E4D3C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<Map<String, dynamic>> accommodations = [
    {
      'name': 'Sigiriya View Hotel',
      'price': 40,
      'desc': 'Comfortable budget hotel',
    },
    {
      'name': 'Kandy Hills Resort',
      'price': 60,
      'desc': 'Mid-range resort with AC',
    },
    {
      'name': 'Galle Fort Boutique',
      'price': 80,
      'desc': 'Charming colonial stay',
    },
  ];

  final List<Map<String, dynamic>> guides = [
    {'name': 'Kamal Perera (English)', 'price': 50, 'desc': 'History expert'},
    {
      'name': 'Nimali Silva (Sinhala/English)',
      'price': 40,
      'desc': 'Friendly local guide',
    },
  ];

  final List<Map<String, dynamic>> attractions = [
    {
      'name': 'Sigiriya',
      'price': 15,
      'desc': 'Lion Rock Fortress',
      'image': 'assets/images/sigiriya.jpg',
    },
    {
      'name': 'Kandy',
      'price': 10,
      'desc': 'Temple of the Tooth',
      'image': 'assets/images/kandy.jpg',
    },
    {
      'name': 'Galle Fort',
      'price': 8,
      'desc': 'Colonial-era fortifications',
      'image': 'assets/images/gallefort.jpg',
    },
    {
      'name': 'Nuwara Eliya',
      'price': 12,
      'desc': 'Little England - Tea Gardens',
      'image': 'assets/images/nuwaraeliya.jpg',
    },
    {
      'name': 'Ella',
      'price': 10,
      'desc': 'Nine Arches & Little Adam\'s Peak',
      'image': 'assets/images/ella.jpg',
    },
    {
      'name': 'Yala Safari',
      'price': 25,
      'desc': 'Leopard & Wildlife Park',
      'image': 'assets/images/yala.jpg',
    },
    {
      'name': 'Polonnaruwa',
      'price': 15,
      'desc': 'Ancient Kingdom Ruins',
      'image': 'assets/images/polonnaruwa.jpg',
    },
    {
      'name': 'Anuradhapura',
      'price': 12,
      'desc': 'Sacred Ancient City',
      'image': 'assets/images/anuradhapura.jpg',
    },
    {
      'name': 'Mirissa',
      'price': 8,
      'desc': 'Whale Watching & Beach',
      'image': 'assets/images/mirissa.jpg',
    },
    {
      'name': 'Sinharaja',
      'price': 10,
      'desc': 'Rainforest & Nature Reserve',
      'image': 'assets/images/sinharaja.jpg',
    },
    {
      'name': 'Dambulla',
      'price': 10,
      'desc': 'Cave Temple Complex',
      'image': 'assets/images/dambulla.jpg',
    },
    {
      'name': 'Horton Plains',
      'price': 15,
      'desc': 'World\'s End & Baker\'s Falls',
      'image': 'assets/images/horton.jpg',
    },
  ];

  final List<Map<String, dynamic>> hiddenPlaces = [
    {'name': 'Little-known Waterfall', 'price': 6, 'desc': 'Scenic walk'},
    {'name': 'Old Tea Factory', 'price': 5, 'desc': 'Local experience'},
  ];

  final List<Map<String, dynamic>> transportOptions = [
    {'name': 'Self-Drive (Tuk-Tuk)', 'price': 15, 'selected': false},
    {'name': 'Private Car with AC', 'price': 45, 'selected': false},
    {'name': 'Luxury Van', 'price': 70, 'selected': false},
  ];

  List<Map<String, dynamic>> selectedAccommodations = [];
  List<Map<String, dynamic>> selectedGuides = [];
  List<Map<String, dynamic>> selectedAttractions = [];
  List<Map<String, dynamic>> selectedHidden = [];

  int get transportPriceSelected {
    final opt = transportOptions.firstWhere(
      (e) => e['selected'] == true,
      orElse: () => {'price': 0},
    );
    return opt['price'] as int;
  }

  int get guidePriceSelected {
    if (selectedGuides.isEmpty) return 0;
    return (selectedGuides.first['price'] as int);
  }

  int get attractionsPrice =>
      selectedAttractions.fold(0, (s, e) => s + (e['price'] as int));
  int get hiddenPrice =>
      selectedHidden.fold(0, (s, e) => s + (e['price'] as int));
  int get accommodationPrice =>
      selectedAccommodations.fold(0, (s, e) => s + (e['price'] as int));
  int get totalPerPerson =>
      accommodationPrice + guidePriceSelected + attractionsPrice + hiddenPrice;
  int get totalAll => (totalPerPerson + transportPriceSelected) * people;

  Future<List<Map<String, dynamic>>?> _showSelectionDialog(
    String title,
    List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> initiallySelected, {
    bool single = false,
  }) {
    final selected = List<Map<String, dynamic>>.from(initiallySelected);
    return showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (c, setStateDialog) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final it = items[i];
                    final isSel = selected.any((e) => e['name'] == it['name']);
                    return CheckboxListTile(
                      title: Text(it['name']),
                      subtitle: Text('\$${it['price']} - ${it['desc'] ?? ''}'),
                      value: isSel,
                      onChanged: (v) {
                        setStateDialog(() {
                          if (single) {
                            selected.clear();
                            if (v == true) selected.add(it);
                          } else {
                            if (v == true) {
                              selected.add(it);
                            } else {
                              selected.removeWhere(
                                (e) => e['name'] == it['name'],
                              );
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(selected),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
          selectedIndex: _selectedNavIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardScreen(initialIndex: index),
              ),
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
              label: 'Tour Packages',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Bookings',
            ),
          ],
        ),
      ),
      appBar: CustomAppBar(
        title: 'Customize Your Adventure',
        showBackButton: true,
        onProfileTapped: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const UserProfileScreen())),
      ),
      body: Column(
        children: [
          // Step Progress Indicator
          _buildStepProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // People Section
                  _buildSectionCard(
                    title: 'Travelers',
                    step: '01',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(6, (i) {
                        final label = i == 5 ? '5+' : '${i + 1}';
                        final value = i == 5 ? 5 : i + 1;
                        final selected = people == value;
                        return _buildChoiceChip(
                          label: label,
                          isSelected: selected,
                          onSelected: (_) => setState(() => people = value),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Attractions Section
                  _buildSectionCard(
                    title: 'Popular Attractions',
                    step: '02',
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.5,
                          ),
                      itemCount: attractions.length,
                      itemBuilder: (context, idx) {
                        final item = attractions[idx];
                        final isSelected = selectedAttractions.any(
                          (e) => e['name'] == item['name'],
                        );
                        return _buildAttractionCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => setState(() {
                            if (isSelected) {
                              selectedAttractions.removeWhere(
                                (e) => e['name'] == item['name'],
                              );
                            } else {
                              selectedAttractions.add(item);
                            }
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transportation Section
                  _buildSectionCard(
                    title: 'Transportation',
                    step: '03',
                    child: Column(
                      children: transportOptions.map((opt) {
                        return _buildTransportTile(
                          name: opt['name'] as String,
                          price: opt['price'] as int,
                          isSelected: opt['selected'] as bool,
                          onChanged: (v) => setState(() {
                            for (var e in transportOptions) {
                              e['selected'] = false;
                            }
                            opt['selected'] = v;
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Accommodation Section
                  _buildSelectionCard(
                    title: 'Accommodation',
                    subtitle: selectedAccommodations.isNotEmpty
                        ? selectedAccommodations.first['name'].toString()
                        : 'Tap to explore hotels',
                    price: selectedAccommodations.isNotEmpty
                        ? '\$${selectedAccommodations.first['price']}/night'
                        : null,
                    icon: Icons.hotel_rounded,
                    color: const Color(0xFF8B5CF6),
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ExploreHotelsScreen(),
                        ),
                      );
                      if (result != null && result is Map) {
                        setState(() {
                          selectedAccommodations = [
                            Map<String, dynamic>.from(result),
                          ];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Guide Section
                  _buildSelectionCard(
                    title: 'Tour Guide',
                    subtitle: selectedGuides.isNotEmpty
                        ? selectedGuides.first['name'].toString()
                        : 'Tap to explore guides',
                    price: selectedGuides.isNotEmpty
                        ? '\$${selectedGuides.first['price']}/day'
                        : null,
                    icon: Icons.person_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GuidesScreen()),
                      );
                      if (result != null && result is GuideProfile) {
                        setState(() {
                          // Convert GuideProfile to a Map for display
                          selectedGuides = [
                            {
                              'name': result.name,
                              'price':
                                  50, // Default price - can be updated if GuideProfile has price field
                              'desc': result.specializations.isNotEmpty
                                  ? result.specializations.join(', ')
                                  : 'Local guide',
                              'guide':
                                  result, // Keep the full GuideProfile for reference
                            },
                          ];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Hidden Gems Section
                  _buildSelectionCard(
                    title: 'Hidden Gems',
                    subtitle: selectedHidden.isNotEmpty
                        ? '${selectedHidden.length} selected'
                        : 'Tap to add experiences',
                    price: selectedHidden.isNotEmpty
                        ? '\$$hiddenPrice total'
                        : null,
                    icon: Icons.explore_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () async {
                      final res = await _showSelectionDialog(
                        'Select Hidden Gems',
                        hiddenPlaces,
                        selectedHidden,
                      );
                      if (res != null) {
                        setState(() => selectedHidden = res);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Summary Section
                  _buildSummaryCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step Progress Indicator Widget
  Widget _buildStepProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Step 1: Tour Customizer (Current - filled dot)
          _buildStepDot(label: 'Customize', isActive: true, isCompleted: false),
          // Line connecting to next step
          _buildConnectingLine(isCompleted: false),
          // Step 2: Payment (next - hollow dot with border)
          _buildStepDot(label: 'Payment', isActive: false, isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildStepDot({
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF1E4D3C) : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? const Color(0xFF1E4D3C)
                  : const Color(0xFF9CA3AF),
              width: 2,
            ),
          ),
          child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : null,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF1E4D3C) : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingLine({required bool isCompleted}) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF1E4D3C) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  // Modern Section Card Widget
  Widget _buildSectionCard({
    required String title,
    required String step,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E4D3C).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Step $step',
                    style: const TextStyle(
                      color: Color(0xFF1E4D3C),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E4D3C),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // Selection Card Widget
  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    String? price,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF1E4D3C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (price != null) ...[
                const SizedBox(width: 8),
                Text(
                  price,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern Choice Chip
  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E4D3C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E4D3C)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E4D3C).withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Modern Attraction Card
  Widget _buildAttractionCard({
    required Map<String, dynamic> item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E4D3C) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF1E4D3C).withAlpha(25)
                  : Colors.black.withAlpha(8),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: Image.asset(
                        item['image'] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_rounded,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E4D3C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['desc'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      '\$${item['price']}',
                      style: const TextStyle(
                        color: Color(0xFF1E4D3C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Transport Tile
  Widget _buildTransportTile({
    required String name,
    required int price,
    required bool isSelected,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E4D3C).withAlpha(12)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E4D3C)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF1E4D3C)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E4D3C)
                      : const Color(0xFF9CA3AF),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected
                          ? const Color(0xFF1E4D3C)
                          : const Color(0xFF374151),
                    ),
                  ),
                  Text(
                    '\$$price/day',
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? const Color(0xFF1E4D3C)
                          : const Color(0xFF6B7280),
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

  // Summary Card
  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E4D3C), Color(0xFF2D6A4F)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E4D3C).withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'Booking Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSummaryRow(
              'Travelers',
              '$people person${people > 1 ? 's' : ''}',
            ),
            _buildSummaryRow(
              'Accommodation',
              selectedAccommodations.isNotEmpty
                  ? selectedAccommodations.first['name']
                  : 'None selected',
            ),
            _buildSummaryRow(
              'Guide',
              selectedGuides.isNotEmpty ? selectedGuides.first['name'] : 'None',
            ),
            _buildSummaryRow(
              'Attractions',
              '${selectedAttractions.length} selected',
            ),
            _buildSummaryRow(
              'Hidden Gems',
              '${selectedHidden.length} selected',
            ),
            _buildSummaryRow(
              'Transport',
              transportPriceSelected > 0 ? '\$$transportPriceSelected' : 'None',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.white24, height: 1),
            ),
            _buildSummaryRow('Per Person', '\$$totalPerPerson', isTotal: true),
            _buildSummaryRow(
              'Total Amount',
              '\$$totalAll',
              isTotal: true,
              isLarge: true,
            ),
            const SizedBox(height: 20),

            // Date Selector
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Booking Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF6B7280)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Select Date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedDate != null
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedDate != null
                    ? () {
                        // Collect booking details
                        final bookingDetails = {
                          'accommodation': selectedAccommodations.isNotEmpty
                              ? selectedAccommodations.first['name']
                              : 'None',
                          'guide': selectedGuides.isNotEmpty
                              ? selectedGuides.first['name']
                              : 'None',
                          'attractions': selectedAttractions.length,
                          'hiddenGems': selectedHidden.length,
                          'transport': transportPriceSelected,
                        };

                        // Get guide info if selected
                        final selectedGuide = selectedGuides.isNotEmpty
                            ? selectedGuides.first
                            : null;
                        final guideId = selectedGuide?['guide']?.uid;
                        final guideName = selectedGuide?['name'];

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              packageName: 'Custom Tour Package',
                              totalAmount: totalAll.toDouble(),
                              numberOfPeople: people,
                              bookingDate: selectedDate!,
                              packageDetails: bookingDetails,
                              guideId: guideId,
                              guideName: guideName,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDate != null
                      ? Colors.white
                      : Colors.grey[200],
                  foregroundColor: const Color(0xFF1E4D3C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  selectedDate != null ? 'Book Now' : 'Please select a date',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isLarge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.white : Colors.white70,
              fontSize: isLarge ? 18 : 14,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLarge ? 22 : 14,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
