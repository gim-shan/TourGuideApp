import 'package:flutter/material.dart';
import '../../data/event_model.dart';

// This is a custom reusable widget that displays a single event's details.
class EventCard extends StatelessWidget {
  // We pass the specific event data into this card.
  final EventModel event;
  
  // Primary color matching the Sign-In screens for UI consistency.
  final Color primaryColor = const Color(0xFF1E4D3C);

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adds space below each card in the list
      margin: const EdgeInsets.only(bottom: 20), 
      decoration: BoxDecoration(
        color: Colors.white,
        // Rounded corners matching the input fields in the auth screens
        borderRadius: BorderRadius.circular(10), 
        // A subtle shadow effect to make the card "pop" off the background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The image section of the card
          ClipRRect(
            // Rounds only the top corners of the image to match the container
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              event.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover, // Ensures the image fills the space without stretching
              // Fallback UI just in case the image fails to load from the internet
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: const Color(0xFFE3E4E4),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          
          // The text and details section below the image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Date
                Text(
                  event.date,
                  style: TextStyle(
                    color: primaryColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Event Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Location and Price Row
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    
                    // Event Location
                    Text(
                      event.location,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    
                    // Pushes the price badge all the way to the right side
                    const Spacer(), 
                    
                    // Price Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        // High border radius to make it look pill-shaped like the Sign-In button
                        borderRadius: BorderRadius.circular(30), 
                      ),
                      child: Text(
                        event.price,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}