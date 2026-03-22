class EventModel {
  final String id;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.imageUrl,
  });

  // Convert EventModel to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  toJson() => toMap();

  // Create EventModel from Firestore document
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : DateTime.now(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel.fromMap(json);
  }

  // Sample live events in Sri Lanka
  static List<EventModel> getSampleEvents() {
    return [
      EventModel(
        id: '1',
        title: 'Sky Lanterns Festival',
        location: 'Hikkaduwa',
        startDate: DateTime(2026, 12, 20),
        endDate: DateTime(2026, 12, 22),
        description:
            'Experience the magical sky lanterns festival with thousands of lanterns lighting up the night sky over Hikkaduwa beach.',
        imageUrl: 'assets/images/sky_lanterns.jpg',
      ),
      EventModel(
        id: '2',
        title: 'Bonfire & Barbeque Night',
        location: 'Yala',
        startDate: DateTime(2026, 12, 25),
        endDate: DateTime(2026, 12, 26),
        description:
            'Enjoy a spectacular bonfire and barbeque experience under the stars in the scenic Yala region with wildlife safaris.',
        imageUrl: 'assets/images/bonfire.jpg',
      ),
      EventModel(
        id: '3',
        title: 'Vesak Poya',
        location: 'Kandy',
        startDate: DateTime(2026, 5, 22),
        endDate: DateTime(2026, 5, 23),
        description:
            'Celebrate the birth of Lord Buddha with traditional lantern processions, decorated streets, and cultural performances across Sri Lanka.',
        imageUrl: 'assets/images/vesak.jpg',
      ),
      EventModel(
        id: '4',
        title: 'Esala Perahara',
        location: 'Kandy',
        startDate: DateTime(2026, 7, 25),
        endDate: DateTime(2026, 8, 4),
        description:
            'The most famous festival in Sri Lanka featuring a grand procession with decorated elephants, dancers, and musicians.',
        imageUrl: 'assets/images/esala.jpg',
      ),
      EventModel(
        id: '5',
        title: 'New Year Celebration',
        location: 'Colombo',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 2),
        description:
            'Ring in the New Year with fireworks, parties, and celebrations at the Galle Face Green and other venues across Colombo.',
        imageUrl: 'assets/images/newyear.jpg',
      ),
      EventModel(
        id: '6',
        title: 'Deepavali Festival',
        location: 'Jaffna & Trincomalee',
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 2),
        description:
            'Celebrate the Festival of Lights with beautiful oil lamps, fireworks, and traditional Tamil celebrations.',
        imageUrl: 'assets/images/deepavali.jpg',
      ),
      EventModel(
        id: '7',
        title: 'Indepen Day Celebrations',
        location: 'Colombo',
        startDate: DateTime(2026, 2, 4),
        endDate: DateTime(2026, 2, 5),
        description:
            'Celebrate Sri Lanka\'s Independence Day with cultural shows, parades, and festive gatherings nationwide.',
        imageUrl: 'assets/images/independence.jpg',
      ),
      EventModel(
        id: '8',
        title: 'Water Festival',
        location: 'Nuwara Eliya',
        startDate: DateTime(2026, 8, 15),
        endDate: DateTime(2026, 8, 17),
        description:
            'Experience water sports, boating competitions, and cultural performances at the picturesque Lake Gregory.',
        imageUrl: 'assets/images/waterfestival.jpg',
      ),
    ];
  }

  // Get events for the next 3 months
  static List<EventModel> getUpcomingEvents() {
    final allEvents = getSampleEvents();
    final now = DateTime.now();
    final threeMonthsLater = now.add(const Duration(days: 90));

    return allEvents
        .where(
          (event) =>
              event.startDate.isAfter(now) &&
              event.startDate.isBefore(threeMonthsLater),
        )
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  // Get all events sorted by date
  static List<EventModel> getAllEvents() {
    final allEvents = getSampleEvents();
    return allEvents..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  @override
  String toString() =>
      'EventModel(id: $id, title: $title, location: $location)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
