import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _usersCollection = 'users';

  // Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }

      // Create default profile if doesn't exist
      final profile = UserProfile(
        uid: user.uid,
        name: user.displayName ?? 'User',
        email: user.email,
      );

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(profile.toMap());

      return profile;
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(updatedProfile.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Add tour to favorites
  Future<void> addToFavorites(String tourId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final profile = await getCurrentUserProfile();
      if (profile == null) throw Exception('Profile not found');

      if (!profile.favoriteTours.contains(tourId)) {
        final updatedFavorites = [...profile.favoriteTours, tourId];
        final updatedProfile = profile.copyWith(
          favoriteTours: updatedFavorites,
          updatedAt: DateTime.now(),
        );

        await updateUserProfile(updatedProfile);
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // Remove tour from favorites
  Future<void> removeFromFavorites(String tourId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final profile = await getCurrentUserProfile();
      if (profile == null) throw Exception('Profile not found');

      final updatedFavorites = profile.favoriteTours
          .where((id) => id != tourId)
          .toList();
      final updatedProfile = profile.copyWith(
        favoriteTours: updatedFavorites,
        updatedAt: DateTime.now(),
      );

      await updateUserProfile(updatedProfile);
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // Check if tour is favorite
  Future<bool> isFavorite(String tourId) async {
    try {
      final profile = await getCurrentUserProfile();
      return profile?.favoriteTours.contains(tourId) ?? false;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Get favorite tours
  Future<List<String>> getFavoriteTours() async {
    try {
      final profile = await getCurrentUserProfile();
      return profile?.favoriteTours ?? [];
    } catch (e) {
      print('Error fetching favorite tours: $e');
      return [];
    }
  }
}
