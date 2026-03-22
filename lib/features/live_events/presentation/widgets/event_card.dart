import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  String _formatDateRange() {
    final startDate = DateFormat('MMM dd').format(event.startDate);
    final endDate = DateFormat('MMM dd, yyyy').format(event.endDate);
    return '$startDate - $endDate';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xff1b9c4d).withOpacity(0.1),
              child: Stack(
                children: [
                  // Placeholder or actual image
                  Center(
                    child: Icon(
                      Icons.event,
                      size: 80,
                      color: const Color(0xff1b9c4d).withOpacity(0.3),
                    ),
                  ),
                  // Badge for upcoming
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff1b9c4d),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Event Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3a20),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xff0e5a3c),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff0e5a3c),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Dates
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xff1b9c4d),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatDateRange(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff666666),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Learn More Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1b9c4d),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Could open detailed event page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${event.title} - Learn more feature'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
}
