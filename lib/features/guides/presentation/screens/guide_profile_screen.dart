import 'package:flutter/material.dart';

class GuideProfileScreen extends StatelessWidget {
  final Map<String, Object> info;

  const GuideProfileScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final name = info['name'] as String? ?? 'Unknown';
    final rating = info['rating'] as String? ?? '-';
    final trips = info['trips'] as int? ?? 0;
    final verified = (info['verified'] as bool?) ?? false;
    final expertise =
        (info['expertise'] as List<Object>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1b9c4d),
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff1b9c4d),
                          width: 4,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (verified)
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xff1b9c4d),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text('$rating • ($trips trips)'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Expertise',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: expertise.map((e) => Chip(label: Text(e))).toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                'About',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Experienced local guide offering personalized tours and deep local knowledge.',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1b9c4d),
                ),
                onPressed: () {},
                child: const Text('Contact guide'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
