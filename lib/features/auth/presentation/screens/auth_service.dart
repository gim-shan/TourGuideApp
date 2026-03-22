import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get the user's role from Firestore
  static Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;
      return userDoc.data()?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is a guide
  static Future<bool> isGuide() async {
    final role = await getUserRole();
    return role == 'guide';
  }

  /// Check if user is a tourist
  static Future<bool> isTourist() async {
    final role = await getUserRole();
    return role == 'tourist';
  }

  /// Check if user has completed onboarding (is logged in for the first time)
  static Future<bool> hasCompletedOnboarding() async {
    final user = _auth.currentUser;
    if (user == null) {
      // No user logged in, show onboarding
      return false;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // User document doesn't exist, first time
        return false;
      }

      final data = userDoc.data();
      // If hasCompletedOnboarding field is false or doesn't exist, show onboarding
      return data?['hasCompletedOnboarding'] == true;
    } catch (e) {
      // If error, assume not completed
      return false;
    }
  }

  /// Mark user as having completed onboarding
  static Future<void> markOnboardingComplete() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'hasCompletedOnboarding': true,
        'onboardingCompletedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check if user is currently logged in
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
