import 'package:flutter/material.dart';
import '../../data/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Fetch screen size for responsive text scaling
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        // Rounded corners to match the UI design
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Soft shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Top Image Section ---
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              event.imageUrl,
              height: 160, 
              width: double.infinity,
              fit: BoxFit.cover,
              // Fallback if image is not found
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                width: double.infinity,
                color: const Color.fromARGB(109, 227, 228, 228),
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          
          // --- Bottom Details Section ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Location Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.045, // Responsive font size
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Location (Icon + Text) placed on the right
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.grey[500],
                            fontSize: size.width * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Date Text
                Text(
                  event.date,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.grey[800],
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Event Description Text
                Text(
                  event.description,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black87,
                    fontSize: size.width * 0.032,
                    height: 1.4, // Line height for better readability
                  ),
                  // Showing up to 3 lines of description, then adding '...'
                  maxLines: 3, 
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}