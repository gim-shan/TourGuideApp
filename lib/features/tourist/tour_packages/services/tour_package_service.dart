import 'package:cloud_firestore/cloud_firestore.dart';

class TourPackageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _packagesCollection = 'tour_packages';

  // List of predefined tour packages
  static final List<Map<String, dynamic>> defaultPackages = [
    // Countryside Packages
    {
      "id": "tour_001",
      "image": "assets/images/Rectangle128.png",
      "title": "The Emerald Wellness & Tea Retreat",
      "price": "\$400-\$550",
      "priceValue": 400,
      "rating": "4.8",
      "ratingValue": 4.8,
      "category": "countryside",
      "isFavorite": false,
    },
    {
      "id": "tour_002",
      "image": "assets/images/Rectangle130.png",
      "title": "The Heritage & Highline Journey",
      "price": "\$750-\$900",
      "priceValue": 750,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "countryside",
      "isFavorite": false,
    },
    {
      "id": "tour_003",
      "image": "assets/images/Rectangle135.png",
      "title": "The Peaks & Pines Adventure (Ella Experience)",
      "price": "\$450-\$600",
      "priceValue": 450,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "countryside",
      "isFavorite": false,
    },
    // Beach Packages
    {
      "id": "tour_004",
      "image": "assets/images/Rectangle129.png",
      "title": "The Azure Horizon: Private Southern Charter",
      "price": "\$1200-\$1800",
      "priceValue": 1200,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "beach",
      "isFavorite": false,
    },
    {
      "id": "tour_005",
      "image": "assets/images/Rectangle131.png",
      "title": "The Wild & Coastal Escape",
      "price": "\$650-\$800",
      "priceValue": 650,
      "rating": "4.8",
      "ratingValue": 4.8,
      "category": "beach",
      "isFavorite": false,
    },
    // City Packages
    {
      "id": "tour_006",
      "image": "assets/images/Rectangle133.png",
      "title": "The Lost Kingdoms & Ancient Monasteries (Hidden Heritage)",
      "price": "\$550-\$700",
      "priceValue": 550,
      "rating": "4.7",
      "ratingValue": 4.7,
      "category": "city",
      "isFavorite": false,
    },
    {
      "id": "tour_007",
      "image": "assets/images/Rectangle136.png",
      "title": "Festival & Folklore: The Esala Perahera Special",
      "price": "\$900-\$1200",
      "priceValue": 900,
      "rating": "4.7",
      "ratingValue": 4.7,
      "category": "city",
      "isFavorite": false,
    },
    {
      "id": "tour_008",
      "image": "assets/images/Rectangle134.png",
      "title": "The Northern Soul: Tamil Heritage & Jaffna Islands",
      "price": "\$650-\$850",
      "priceValue": 650,
      "rating": "4.8",
      "ratingValue": 4.8,
      "category": "city",
      "isFavorite": false,
    },
    {
      "id": "tour_009",
      "image": "assets/images/Rectangle137.png",
      "title": "The Colonial Coast: Galle Fort & Beyond",
      "price": "\$350-\$500",
      "priceValue": 350,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "city",
      "isFavorite": false,
    },
    // Wildlife Packages
    {
      "id": "tour_010",
      "image": "assets/images/Rectangle132.png",
      "title": "The Masks and Melodies",
      "price": "\$150-\$250",
      "priceValue": 150,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "wildlife",
      "isFavorite": false,
    },
    {
      "id": "tour_011",
      "image": "assets/images/Rectangle138.png",
      "title": "The Leopard's Kingdom: Yala Safari Expedition",
      "price": "\$500-\$750",
      "priceValue": 500,
      "rating": "4.9",
      "ratingValue": 4.9,
      "category": "wildlife",
      "isFavorite": false,
    },
  ];

  // Initialize packages in Firestore (call this on app startup)
  Future<void> initializePackages() async {
    try {
      // Check if packages already exist
      final existingPackages = await _firestore
          .collection(_packagesCollection)
          .limit(1)
          .get();

      if (existingPackages.docs.isNotEmpty) {
        // Packages already initialized
        return;
      }

      // Add all default packages to Firestore
      final batch = _firestore.batch();

      for (var package in defaultPackages) {
        final docRef = _firestore
            .collection(_packagesCollection)
            .doc(package['id']);
        batch.set(docRef, {
          ...package,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to initialize packages: $e');
    }
  }

  // Get all packages from Firestore
  Future<List<Map<String, dynamic>>> getAllPackages() async {
    try {
      final snap = await _firestore
          .collection(_packagesCollection)
          .orderBy('ratingValue', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get packages: $e');
    }
  }

  // Get packages by category
  Future<List<Map<String, dynamic>>> getPackagesByCategory(
    String category,
  ) async {
    try {
      final snap = await _firestore
          .collection(_packagesCollection)
          .where('category', isEqualTo: category)
          .orderBy('ratingValue', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get packages by category: $e');
    }
  }

  // Get a single package by ID
  Future<Map<String, dynamic>?> getPackageById(String packageId) async {
    try {
      final doc = await _firestore
          .collection(_packagesCollection)
          .doc(packageId)
          .get();

      if (doc.exists) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get package: $e');
    }
  }

  // Update package rating
  Future<void> updatePackageRating(String packageId, double newRating) async {
    try {
      await _firestore.collection(_packagesCollection).doc(packageId).update({
        'rating': newRating.toStringAsFixed(1),
        'ratingValue': newRating,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update package rating: $e');
    }
  }

  // Update package favorite status
  Future<void> updatePackageFavorite(String packageId, bool isFavorite) async {
    try {
      await _firestore.collection(_packagesCollection).doc(packageId).update({
        'isFavorite': isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update package favorite: $e');
    }
  }
}
