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
}
