import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/guide_profile.dart';

class GuideProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _guidesCollection = 'guides';

  // Get current guide profile
  Future<GuideProfile?> getCurrentGuideProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection(_guidesCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return GuideProfile.fromMap(doc.data() as Map<String, dynamic>);
      }

      // Create default profile if doesn't exist
      final profile = GuideProfile(
        uid: user.uid,
        name: user.displayName ?? 'Guide',
        email: user.email,
      );

      await _firestore
          .collection(_guidesCollection)
          .doc(user.uid)
          .set(profile.toMap());

      return profile;
    } catch (e) {
      print('Error fetching guide profile: $e');
      rethrow;
    }
  }

  // Update guide profile
  Future<void> updateGuideProfile(GuideProfile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_guidesCollection)
          .doc(user.uid)
          .set(updatedProfile.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating guide profile: $e');
      rethrow;
    }
  }

  // Get guide profile by ID
  Future<GuideProfile?> getGuideProfileById(String guideId) async {
    try {
      final doc = await _firestore
          .collection(_guidesCollection)
          .doc(guideId)
          .get();

      if (doc.exists) {
        return GuideProfile.fromMap(doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      print('Error fetching guide profile: $e');
      return null;
    }
  }

  // Get all guides
  Future<List<GuideProfile>> getAllGuides() async {
    try {
      final snapshot = await _firestore.collection(_guidesCollection).get();

      return snapshot.docs
          .map(
            (doc) => GuideProfile.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error fetching guides: $e');
      return [];
    }
  }

  /// Get dummy/sample guides for display
  static List<GuideProfile> getDummyGuides() {
    return [
      // Hardcoded guide 1
      GuideProfile(
        uid: 'dummy_001',
        name: 'Kamal Perera',
        email: 'kamal.perera@tourguide.lk',
        phone: '+94 77 123 4567',
        location: 'Kandy, Sri Lanka',
        bio: 'History expert with 10 years of experience in cultural tours.',
        yearsOfExperience: 10,
        languages: const ['English', 'Sinhala', 'Tamil'],
        specializations: const [
          'Cultural Tours',
          'Archaeological Sites',
          'Temple Tours',
        ],
        certification: 'Certified Tour Guide - Sri Lanka Tourism',
        rating: 4.8,
        totalTours: 156,
      ),
      // Hardcoded guide 2
      GuideProfile(
        uid: 'dummy_002',
        name: 'Nimali Silva',
        email: 'nimali.silva@tourguide.lk',
        phone: '+94 76 234 5678',
        location: 'Sigiriya, Sri Lanka',
        bio: 'Friendly local guide specializing in wildlife and nature tours.',
        yearsOfExperience: 7,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Wildlife Safaris',
          'Nature Walks',
          'Bird Watching',
        ],
        certification: 'Certified Wildlife Guide',
        rating: 4.9,
        totalTours: 98,
      ),
      // Hardcoded guide 3
      GuideProfile(
        uid: 'dummy_003',
        name: 'Ranjan Fernando',
        email: 'ranjan.fernando@tourguide.lk',
        phone: '+94 71 345 6789',
        location: 'Galle, Sri Lanka',
        bio:
            'Colonial heritage expert. Specializes in walking tours of Galle Fort.',
        yearsOfExperience: 12,
        languages: const ['English', 'Sinhala', 'German'],
        specializations: const [
          'Heritage Tours',
          'Colonial Architecture',
          'Beach Tours',
        ],
        certification: 'Certified Heritage Guide',
        rating: 4.7,
        totalTours: 210,
      ),
      // Hardcoded guide 4
      GuideProfile(
        uid: 'dummy_004',
        name: 'Sanjaya Rajapaksa',
        email: 'sanjaya.rajapaksa@tourguide.lk',
        phone: '+94 72 456 7890',
        location: 'Nuwara Eliya, Sri Lanka',
        bio: 'Mountain guide and adventure enthusiast. Expert in hiking tours.',
        yearsOfExperience: 8,
        languages: const ['English', 'Sinhala'],
        specializations: const ['Adventure Tours', 'Hiking', 'Tea Tours'],
        certification: 'Certified Mountain Guide',
        rating: 4.6,
        totalTours: 75,
      ),
      // Hardcoded guide 5
      GuideProfile(
        uid: 'dummy_005',
        name: 'Priyangika Dissanayake',
        email: 'priyangika@tourguide.lk',
        phone: '+94 75 567 8901',
        location: 'Anuradhapura, Sri Lanka',
        bio: 'Spiritual guide specializing in Buddhist pilgrimages.',
        yearsOfExperience: 15,
        languages: const ['English', 'Sinhala', 'Japanese'],
        specializations: const [
          'Pilgrimage Tours',
          'Ancient Cities',
          'Buddhist History',
        ],
        certification: 'Certified Buddhist Guide',
        rating: 4.9,
        totalTours: 320,
      ),
      // Hardcoded guide 6
      GuideProfile(
        uid: 'dummy_006',
        name: 'Thilina Wickramage',
        email: 'thilina.w@tourguide.lk',
        phone: '+94 76 111 2222',
        location: 'Colombo, Sri Lanka',
        bio:
            'Urban tour expert specializing in city exploration and shopping tours.',
        yearsOfExperience: 5,
        languages: const ['English', 'Sinhala'],
        specializations: const ['City Tours', 'Shopping', 'Nightlife'],
        certification: 'Certified City Guide',
        rating: 4.5,
        totalTours: 180,
      ),
      // Hardcoded guide 7
      GuideProfile(
        uid: 'dummy_007',
        name: 'Ayoma Karunaratne',
        email: 'ayoma.k@tourguide.lk',
        phone: '+94 77 333 4444',
        location: 'Jaffna, Sri Lanka',
        bio: 'Heritage and culture specialist from the northern peninsula.',
        yearsOfExperience: 9,
        languages: const ['English', 'Tamil', 'Sinhala'],
        specializations: const ['Cultural Tours', 'Temple Tours', 'History'],
        certification: 'Certified Cultural Guide',
        rating: 4.7,
        totalTours: 145,
      ),
      // Hardcoded guide 8
      GuideProfile(
        uid: 'dummy_008',
        name: 'Malith Perera',
        email: 'malith.p@tourguide.lk',
        phone: '+94 71 555 6666',
        location: 'Ella, Sri Lanka',
        bio: 'Adventure seeker specializing in hiking and scenic viewpoints.',
        yearsOfExperience: 6,
        languages: const ['English', 'Sinhala'],
        specializations: const ['Hiking', 'Nature Walks', 'Photography'],
        certification: 'Certified Adventure Guide',
        rating: 4.8,
        totalTours: 220,
      ),
      // Hardcoded guide 9
      GuideProfile(
        uid: 'dummy_009',
        name: 'Chathura Jayasiri',
        email: 'chathura.j@tourguide.lk',
        phone: '+94 72 777 8888',
        location: 'Dambulla, Sri Lanka',
        bio: 'Cave temple specialist and ancient civilization enthusiast.',
        yearsOfExperience: 11,
        languages: const ['English', 'Sinhala', 'French'],
        specializations: const [
          'Archaeological Sites',
          'Temple Tours',
          'History',
        ],
        certification: 'Certified Archaeological Guide',
        rating: 4.6,
        totalTours: 190,
      ),
      // Hardcoded guide 10
      GuideProfile(
        uid: 'dummy_010',
        name: 'Isuri Fernando',
        email: 'isuri.f@tourguide.lk',
        phone: '+94 75 999 0000',
        location: 'Mirissa, Sri Lanka',
        bio:
            'Beach and marine expert. Whale watching and beach tour specialist.',
        yearsOfExperience: 4,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Beach Tours',
          'Whale Watching',
          'Water Sports',
        ],
        certification: 'Certified Marine Guide',
        rating: 4.9,
        totalTours: 85,
      ),
      // Hardcoded guide 11
      GuideProfile(
        uid: 'dummy_011',
        name: 'Nuwan Silva',
        email: 'nuwan.s@tourguide.lk',
        phone: '+94 76 121 2121',
        location: 'Polonnaruwa, Sri Lanka',
        bio: 'Ancient city ruins expert. Passionate about medieval history.',
        yearsOfExperience: 13,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Ancient Cities',
          'Archaeological Sites',
          'History',
        ],
        certification: 'Certified History Guide',
        rating: 4.8,
        totalTours: 275,
      ),
      // Hardcoded guide 12
      GuideProfile(
        uid: 'dummy_012',
        name: 'Dilani Wickremesinghe',
        email: 'dilani.w@tourguide.lk',
        phone: '+94 77 343 4343',
        location: 'Kandy, Sri Lanka',
        bio: 'Traditional dance and cultural performance expert.',
        yearsOfExperience: 8,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Cultural Shows',
          'Dance Tours',
          'Festival Tours',
        ],
        certification: 'Certified Cultural Expert',
        rating: 4.7,
        totalTours: 165,
      ),
      // Hardcoded guide 13
      GuideProfile(
        uid: 'dummy_013',
        name: 'Madusha Ranasinghe',
        email: 'madusha.r@tourguide.lk',
        phone: '+94 71 565 6565',
        location: 'Yala, Sri Lanka',
        bio: 'Safari expert. Best spotter for leopards in Yala national park.',
        yearsOfExperience: 10,
        languages: const ['English', 'Sinhala'],
        specializations: const ['Safari', 'Wildlife', 'Bird Watching'],
        certification: 'Certified Safari Guide',
        rating: 4.9,
        totalTours: 340,
      ),
      // Hardcoded guide 14
      GuideProfile(
        uid: 'dummy_014',
        name: 'Kalpani Devendra',
        email: 'kalpani.d@tourguide.lk',
        phone: '+94 72 787 8787',
        location: 'Horton Plains, Sri Lanka',
        bio: 'Mountain specialist and eco-tourism guide.',
        yearsOfExperience: 7,
        languages: const ['English', 'Sinhala'],
        specializations: const ['Eco Tours', 'Hiking', 'Mountain Tours'],
        certification: 'Certified Eco Guide',
        rating: 4.6,
        totalTours: 120,
      ),
      // Hardcoded guide 15
      GuideProfile(
        uid: 'dummy_015',
        name: 'Charitha Dissanayake',
        email: 'charitha.d@tourguide.lk',
        phone: '+94 75 909 0909',
        location: 'Sigiriya, Sri Lanka',
        bio:
            'Rock fortress specialist. Expert in ancient Sri Lankan architecture.',
        yearsOfExperience: 9,
        languages: const ['English', 'Sinhala', 'Italian'],
        specializations: const [
          'Architecture Tours',
          'Historical Tours',
          'Photography',
        ],
        certification: 'Certified Heritage Expert',
        rating: 4.8,
        totalTours: 205,
      ),
      // Hardcoded guide 16
      GuideProfile(
        uid: 'dummy_016',
        name: 'Shehani Perera',
        email: 'shehani.p@tourguide.lk',
        phone: '+94 76 232 3232',
        location: 'Trincomalee, Sri Lanka',
        bio: 'Beach resort and diving guide for eastern coast.',
        yearsOfExperience: 5,
        languages: const ['English', 'Sinhala'],
        specializations: const ['Diving', 'Beach Tours', 'Snorkeling'],
        certification: 'Certified Diving Guide',
        rating: 4.5,
        totalTours: 95,
      ),
      // Hardcoded guide 17
      GuideProfile(
        uid: 'dummy_017',
        name: 'Dinuka Fernando',
        email: 'dinuka.f@tourguide.lk',
        phone: '+94 71 454 5454',
        location: 'Sinharaja, Sri Lanka',
        bio: 'Rainforest specialist and biodiversity expert.',
        yearsOfExperience: 6,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Rainforest Tours',
          'Wildlife',
          'Nature Photography',
        ],
        certification: 'Certified Nature Guide',
        rating: 4.7,
        totalTours: 110,
      ),
      // Hardcoded guide 18
      GuideProfile(
        uid: 'dummy_018',
        name: 'Hasitha Wije',
        email: 'hasitha.w@tourguide.lk',
        phone: '+94 72 676 7676',
        location: 'Negombo, Sri Lanka',
        bio: 'Fishing village tours and seafood culinary expert.',
        yearsOfExperience: 4,
        languages: const ['English', 'Sinhala'],
        specializations: const [
          'Culinary Tours',
          'Fishing Tours',
          'Beach Tours',
        ],
        certification: 'Certified Culinary Guide',
        rating: 4.6,
        totalTours: 70,
      ),
      // Hardcoded guide 19
      GuideProfile(
        uid: 'dummy_019',
        name: 'Ruwanthi Kumarage',
        email: 'ruwanthi.k@tourguide.lk',
        phone: '+94 75 898 9898',
        location: 'Kandy, Sri Lanka',
        bio: 'Tea plantation tours and spice garden specialist.',
        yearsOfExperience: 8,
        languages: const ['English', 'Sinhala', 'Mandarin'],
        specializations: const [
          'Tea Tours',
          'Spice Tours',
          'Agricultural Tours',
        ],
        certification: 'Certified Tea Expert',
        rating: 4.8,
        totalTours: 185,
      ),
      // Hardcoded guide 20
      GuideProfile(
        uid: 'dummy_020',
        name: 'Lakshan Rodrigo',
        email: 'lakshan.r@tourguide.lk',
        phone: '+94 76 010 1010',
        location: 'Bentota, Sri Lanka',
        bio:
            'Water sports and luxury resort guide. All-inclusive tour specialist.',
        yearsOfExperience: 6,
        languages: const ['English', 'Sinhala', 'Russian'],
        specializations: const ['Water Sports', 'Luxury Tours', 'Family Tours'],
        certification: 'Certified Resort Guide',
        rating: 4.9,
        totalTours: 230,
      ),
    ];
  }

  // Update guide rating
  Future<void> updateGuideRating(String guideId, double newRating) async {
    try {
      final doc = await _firestore
          .collection(_guidesCollection)
          .doc(guideId)
          .get();

      if (doc.exists) {
        final currentData = doc.data() as Map<String, dynamic>;
        final currentRating = (currentData['rating'] ?? 0.0).toDouble();
        final totalTours = currentData['totalTours'] ?? 0;

        // Calculate new average rating
        final newTotalRating =
            (currentRating * totalTours + newRating) / (totalTours + 1);

        await _firestore.collection(_guidesCollection).doc(guideId).update({
          'rating': newTotalRating,
          'totalTours': totalTours + 1,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      print('Error updating guide rating: $e');
    }
  }

  // Initialize sample guides in the database
  Future<void> initializeSampleGuides() async {
    try {
      // Check if sample guides were already initialized (stored in Firestore)
      final settingsDoc = await _firestore
          .collection('settings')
          .doc('sampleGuides')
          .get();

      if (settingsDoc.exists && settingsDoc.data()?['initialized'] == true) {
        print('Sample guides already initialized');
        return;
      }

      print('Adding sample guides to database...');

      final sampleGuides = [
        {
          'uid': 'guide_001',
          'name': 'Kamal Perera',
          'email': 'kamal.perera@tourguide.lk',
          'phone': '+94 77 123 4567',
          'location': 'Kandy, Sri Lanka',
          'bio':
              'History expert with 10 years of experience in cultural tours. Passionate about ancient Sri Lankan history.',
          'yearsOfExperience': 10,
          'languages': ['English', 'Sinhala', 'Tamil'],
          'specializations': [
            'Cultural Tours',
            'Archaeological Sites',
            'Temple Tours',
          ],
          'certification': 'Certified Tour Guide - Sri Lanka Tourism',
          'rating': 4.8,
          'totalTours': 156,
        },
        {
          'uid': 'guide_002',
          'name': 'Nimali Silva',
          'email': 'nimali.silva@tourguide.lk',
          'phone': '+94 76 234 5678',
          'location': 'Sigiriya, Sri Lanka',
          'bio':
              'Friendly local guide specializing in wildlife and nature tours. Expert in bird watching and safari trips.',
          'yearsOfExperience': 7,
          'languages': ['English', 'Sinhala'],
          'specializations': [
            'Wildlife Safaris',
            'Nature Walks',
            'Bird Watching',
          ],
          'certification': 'Certified Wildlife Guide - Department of Wildlife',
          'rating': 4.9,
          'totalTours': 98,
        },
        {
          'uid': 'guide_003',
          'name': 'Ranjan Fernando',
          'email': 'ranjan.fernando@tourguide.lk',
          'phone': '+94 71 345 6789',
          'location': 'Galle, Sri Lanka',
          'bio':
              'Colonial heritage expert. Specializes in walking tours of Galle Fort and southern coast exploration.',
          'yearsOfExperience': 12,
          'languages': ['English', 'Sinhala', 'German'],
          'specializations': [
            'Heritage Tours',
            'Colonial Architecture',
            'Beach Tours',
          ],
          'certification': 'Certified Heritage Guide',
          'rating': 4.7,
          'totalTours': 210,
        },
        {
          'uid': 'guide_004',
          'name': 'Sanjaya Rajapaksa',
          'email': 'sanjaya.rajapaksa@tourguide.lk',
          'phone': '+94 72 456 7890',
          'location': 'Nuwara Eliya, Sri Lanka',
          'bio':
              'Mountain guide and adventure enthusiast. Expert in hiking tours and tea plantation visits.',
          'yearsOfExperience': 8,
          'languages': ['English', 'Sinhala'],
          'specializations': ['Adventure Tours', 'Hiking', 'Tea Tours'],
          'certification': 'Certified Mountain Guide',
          'rating': 4.6,
          'totalTours': 75,
        },
        {
          'uid': 'guide_005',
          'name': 'Priyangika Dissanayake',
          'email': 'priyangika@tourguide.lk',
          'phone': '+94 75 567 8901',
          'location': 'Anuradhapura, Sri Lanka',
          'bio':
              'Spiritual guide specializing in Buddhist pilgrimages and ancient city tours.',
          'yearsOfExperience': 15,
          'languages': ['English', 'Sinhala', 'Japanese'],
          'specializations': [
            'Pilgrimage Tours',
            'Ancient Cities',
            'Buddhist History',
          ],
          'certification': 'Certified Buddhist Guide',
          'rating': 4.9,
          'totalTours': 320,
        },
      ];

      for (final guide in sampleGuides) {
        final guideData = Map<String, dynamic>.from(guide);
        guideData['createdAt'] = DateTime.now().millisecondsSinceEpoch;
        guideData['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
        guideData['profilePictureUrl'] = null;
        await _firestore
            .collection(_guidesCollection)
            .doc(guide['uid'] as String)
            .set(guideData);
      }

      // Mark sample guides as initialized in Firestore
      await _firestore.collection('settings').doc('sampleGuides').set({
        'initialized': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      print('Sample guides added successfully!');
    } catch (e) {
      print('Error initializing sample guides: $e');
    }
  }

  // Force re-initialize sample guides (for testing/development)
  Future<void> forceInitializeSampleGuides() async {
    try {
      // Clear the initialization flag
      await _firestore.collection('settings').doc('sampleGuides').delete();

      // Delete any existing sample guides
      for (final uid in [
        'guide_001',
        'guide_002',
        'guide_003',
        'guide_004',
        'guide_005',
      ]) {
        await _firestore.collection(_guidesCollection).doc(uid).delete();
      }

      // Re-initialize
      await initializeSampleGuides();
    } catch (e) {
      print('Error forcing sample guides re-initialization: $e');
    }
  }
}
