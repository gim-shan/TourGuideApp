import 'package:flutter/material.dart';
import 'package:hidmo_app/core/widgets/custom_app_bar.dart';
import 'package:hidmo_app/features/profile/presentation/screens/user_profile_screen.dart';

class ExploreHotelsScreen extends StatelessWidget {
  const ExploreHotelsScreen({super.key});

  static const Color _primaryGreen = Color(0xff1b9c4d);
  static const Color _textDark = Color(0xFF1E4D3C);

  @override
  Widget build(BuildContext context) {
    final hotels = <Map<String, dynamic>>[
      {
        'name': 'Little England Cottages',
        'location': 'Nuwara Eliya, Sri Lanka',
        'rating': '4.5',
        'price': 120,
        'desc': 'Cozy cottage with mountain views',
      },
      {
        'name': '98 Acres Resort and Spa',
        'location': 'Ella, Sri Lanka',
        'rating': '4.7',
        'price': 180,
        'desc': 'Luxury eco-resort with scenic views',
      },
      {
        'name': 'Heritance Kandalama',
        'location': 'Dambulla, Sri Lanka',
        'rating': '4.6',
        'price': 160,
        'desc': 'Award-winning architectural wonder',
      },
      {
        'name': 'Jetwing Vil Uyana',
        'location': 'Sigiriya, Sri Lanka',
        'rating': '4.8',
        'price': 220,
        'desc': 'Serene luxury with nature pond',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Explore Hotels',
        showBackButton: false,
        onProfileTapped: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const UserProfileScreen())),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hotels.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final h = hotels[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).pop(h);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: _primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.hotel_rounded,
                      color: _primaryGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (h['name'] ?? '').toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (h['location'] ?? '').toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (h['rating'] ?? '').toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'From \$${h['price']}/night',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
