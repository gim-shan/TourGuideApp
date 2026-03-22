class HotelModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.description,
    this.imageUrl = '',
    this.category = '',
  });

  // Convert HotelModel to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  toJson() => toMap();

  // Create HotelModel from Firestore document
  factory HotelModel.fromMap(Map<String, dynamic> map) {
    return HotelModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
    );
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel.fromMap(json);
  }

  // Sample hotels in Sri Lanka (based on existing data in explore_hotels_screen.dart)
  static List<HotelModel> getSampleHotels() {
    return [
      // Hill Country
      HotelModel(
        id: '1',
        name: 'Little England Cottages',
        location: 'Nuwara Eliya, Sri Lanka',
        rating: 4.5,
        price: 120,
        description: 'Cozy cottage with mountain views',
        category: 'Hill Country',
      ),
      HotelModel(
        id: '2',
        name: '98 Acres Resort and Spa',
        location: 'Ella, Sri Lanka',
        rating: 4.7,
        price: 180,
        description: 'Luxury eco-resort with scenic views',
        category: 'Hill Country',
      ),
      HotelModel(
        id: '3',
        name: 'Heritance Kandalama',
        location: 'Dambulla, Sri Lanka',
        rating: 4.6,
        price: 160,
        description: 'Award-winning architectural wonder',
        category: 'Cultural',
      ),
      HotelModel(
        id: '4',
        name: 'Jetwing Vil Uyana',
        location: 'Sigiriya, Sri Lanka',
        rating: 4.8,
        price: 220,
        description: 'Serene luxury with nature pond',
        category: 'Cultural',
      ),
      // Coastal & Beach
      HotelModel(
        id: '5',
        name: 'Taj Bentota Resort & Spa',
        location: 'Bentota, Sri Lanka',
        rating: 4.6,
        price: 200,
        description: 'Luxury beachfront resort with Ayurvedic spa',
        category: 'Beach',
      ),
      HotelModel(
        id: '6',
        name: 'Shangri-La Hambantota',
        location: 'Hambantota, Sri Lanka',
        rating: 4.7,
        price: 250,
        description: 'Premium resort overlooking the Indian Ocean',
        category: 'Beach',
      ),
      HotelModel(
        id: '7',
        name: 'Amanwella',
        location: 'Tangalle, Sri Lanka',
        rating: 4.9,
        price: 450,
        description: 'Ultra-luxury beachfront villa resort',
        category: 'Beach',
      ),
      HotelModel(
        id: '8',
        name: 'Jungle Beach',
        location: 'Trincomalee, Sri Lanka',
        rating: 4.4,
        price: 150,
        description: 'Eco-friendly resort nestled in nature',
        category: 'Beach',
      ),
      HotelModel(
        id: '9',
        name: 'The Fortress Resort & Spa',
        location: 'Galle, Sri Lanka',
        rating: 4.7,
        price: 220,
        description: 'Colonial-style luxury near Galle Fort',
        category: 'Beach',
      ),
      HotelModel(
        id: '10',
        name: 'Jetwing Sea',
        location: 'Negombo, Sri Lanka',
        rating: 4.5,
        price: 140,
        description: 'Modern beachfront hotel with pool',
        category: 'Beach',
      ),
      HotelModel(
        id: '11',
        name: 'Club Hotel Dolphin',
        location: 'Negombo, Sri Lanka',
        rating: 4.3,
        price: 110,
        description: 'Family-friendly all-inclusive resort',
        category: 'Beach',
      ),
      HotelModel(
        id: '12',
        name: 'Blue Water',
        location: 'Wadduwa, Sri Lanka',
        rating: 4.5,
        price: 160,
        description: 'Luxury hotel with stunning ocean views',
        category: 'Beach',
      ),
      // Hill Country (additional)
      HotelModel(
        id: '13',
        name: 'Ceylon Tea Trails',
        location: 'Hatton, Sri Lanka',
        rating: 4.9,
        price: 400,
        description: 'Exclusive tea plantation bungalows',
        category: 'Hill Country',
      ),
      HotelModel(
        id: '14',
        name: 'Camellia Hills',
        location: 'Dickoya, Sri Lanka',
        rating: 4.7,
        price: 280,
        description: 'Victorian-era luxury in tea country',
        category: 'Hill Country',
      ),
      HotelModel(
        id: '15',
        name: 'Lunuganga Estate',
        location: 'Bentota, Sri Lanka',
        rating: 4.6,
        price: 180,
        description: 'Historic country house with gardens',
        category: 'Hill Country',
      ),
      // Cultural & Kandy
      HotelModel(
        id: '16',
        name: 'The Lanka Collection',
        location: 'Kandy, Sri Lanka',
        rating: 4.4,
        price: 130,
        description: 'Boutique hotel near Kandy Lake',
        category: 'Cultural',
      ),
      HotelModel(
        id: '17',
        name: 'Mahaweli Reach',
        location: 'Kandy, Sri Lanka',
        rating: 4.5,
        price: 145,
        description: 'Riverside hotel with scenic views',
        category: 'Cultural',
      ),
      // Colombo & South
      HotelModel(
        id: '18',
        name: 'Galle Face Hotel',
        location: 'Colombo, Sri Lanka',
        rating: 4.6,
        price: 200,
        description: 'Historic colonial hotel since 1864',
        category: 'City',
      ),
      HotelModel(
        id: '19',
        name: 'The Mount Lavinia Hotel',
        location: 'Mount Lavinia, Sri Lanka',
        rating: 4.5,
        price: 170,
        description: 'Beachfront colonial heritage hotel',
        category: 'City',
      ),
      HotelModel(
        id: '20',
        name: 'Anantara Kalutara',
        location: 'Kalutara, Sri Lanka',
        rating: 4.7,
        price: 230,
        description: 'Luxury villa resort with lagoon',
        category: 'Beach',
      ),
      HotelModel(
        id: '21',
        name: 'Avani Kalutara',
        location: 'Kalutara, Sri Lanka',
        rating: 4.4,
        price: 150,
        description: 'Modern beachfront resort',
        category: 'Beach',
      ),
    ];
  }

  // Get all hotels sorted by rating
  static List<HotelModel> getAllHotels() {
    final hotels = getSampleHotels();
    return hotels..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Get hotels by category
  static List<HotelModel> getHotelsByCategory(String category) {
    return getSampleHotels()
        .where(
          (hotel) => hotel.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  // Get featured hotels (top rated)
  static List<HotelModel> getFeaturedHotels() {
    final hotels = getSampleHotels();
    hotels.sort((a, b) => b.rating.compareTo(a.rating));
    return hotels.take(5).toList();
  }

  @override
  String toString() => 'HotelModel(id: $id, name: $name, location: $location)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
