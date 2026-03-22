import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Centralized authentication helper for Google sign‑in.
class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: const ['email']);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  /// Signs in with Google and ensures a user document exists in Firestore.

  Future<User?> signInWithGoogle(String role) async {
    // Start Google sign‑in flow.
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User cancelled.

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase Auth.
    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Unable to sign in with Google. Please try again.',
      );
    }

    // Ensure user document exists / is updated in Firestore.
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': role,
      'name': user.displayName,
      'provider': 'google',
      'lastSignInAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return user;
  }
}
