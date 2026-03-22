import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize push notifications
  static Future<void> initialize() async {
    // Request permission for iOS
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission status: ${settings.authorizationStatus}');
    }

    // Get the token
    final token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // Save token to Firestore for this user
    await _saveTokenToFirestore(token);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  /// Save the FCM token to the user's document in Firestore
  static Future<void> _saveTokenToFirestore(String? token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || token == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // If document doesn't exist, create it
      await _firestore.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  /// Handle incoming messages when app is in foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Received foreground message: ${message.notification?.title}');
    }

    // Show a local notification
    _showLocalNotification(
      title: message.notification?.title ?? 'New Booking',
      body: message.notification?.body ?? 'You have a new tour request!',
      data: message.data,
    );
  }

  /// Handle when user taps on notification
  static void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      print('User opened app from notification: ${message.data}');
    }

    // Handle navigation based on notification data
    _handleNotificationNavigation(message.data);
  }

  /// Show a local notification
  static void _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    // In a production app, you would use flutter_local_notifications
    // or another local notifications plugin for this
    // For now, we'll use Firebase's built-in handling
  }

  /// Handle navigation based on notification data
  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    final bookingId = data['bookingId'];

    if (type == 'new_booking' && bookingId != null) {
      // Navigate to the guide home screen to see the new booking
      // This would be handled by the app's navigation system
    }
  }

  /// Subscribe to a topic for receiving notifications
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Send a notification to a specific user (guide) when a tour is assigned
  static Future<void> sendTourAssignedNotification({
    required String guideId,
    required String touristName,
    required String packageName,
    required String bookingId,
  }) async {
    try {
      // Get the guide's FCM token
      final guideDoc = await _firestore.collection('users').doc(guideId).get();
      final fcmToken = guideDoc.data()?['fcmToken'];

      if (fcmToken == null) {
        if (kDebugMode) {
          print('Guide has no FCM token');
        }
        return;
      }

      // Store notification in Firestore for the guide to see
      await _firestore.collection('notifications').add({
        'type': 'new_booking',
        'title': 'New Tour Request!',
        'body': '$touristName has selected you as their guide for $packageName',
        'touristName': touristName,
        'packageName': packageName,
        'bookingId': bookingId,
        'guideId': guideId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // In production, you would use Firebase Cloud Functions to send
      // the push notification via FCM API
      if (kDebugMode) {
        print('Notification created in Firestore');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }
}
