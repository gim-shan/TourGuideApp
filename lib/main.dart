import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hidmo_app/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:hidmo_app/features/auth/presentation/screens/auth_service.dart';
import 'package:hidmo_app/features/live_events/data/utils/event_database_initializer.dart';
import 'package:hidmo_app/features/tourist/hotels/data/utils/hotel_database_initializer.dart';
import 'package:hidmo_app/features/tourist/tour_packages/data/utils/tour_package_database_initializer.dart';
import 'package:hidmo_app/features/guide/data/utils/guide_database_initializer.dart';
import 'package:hidmo_app/core/services/push_notification_service.dart';

//import 'features/auth/presentation/screens/tourist_signin_screen.dart';
import 'features/auth/presentation/screens/dashboard_screens/dashboard.dart';
import 'features/guide/dashboard/guide_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async async Firebase init

  // Initialize Stripe with your publishable key
  // Get this from https://dashboard.stripe.com/test/apikeys
  Stripe.publishableKey =
      'pk_test_51TCDnp7lC3WAYGa8JemAIbhkFSMj3jf6QvG2G90LkSqeozeRFIDFtLFEjQ9MiBHQEULCo0t7cHrvnrqlVRpvI5jC00VXzlrmHH';

  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize Push Notifications
  await PushNotificationService.initialize();

  // Initialize Live Events Database
  await EventDatabaseInitializer.initializeDatabase();

  // Initialize Hotels Database
  await HotelDatabaseInitializer.initializeDatabase();

  // Initialize Tour Packages Database
  await TourPackageDatabaseInitializer.initializeDatabase();

  // Initialize Guides Database
  await GuideDatabaseInitializer.initializeDatabase();

  runApp(const HiddenMonentsApp());
}

class HiddenMonentsApp extends StatelessWidget {
  const HiddenMonentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hidden Moments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E4D3C)),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in and has completed onboarding
    if (AuthService.isLoggedIn()) {
      // User is logged in, check if they completed onboarding
      return FutureBuilder<bool>(
        future: AuthService.hasCompletedOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            // User has completed onboarding, check their role
            return FutureBuilder<String?>(
              future: AuthService.getUserRole(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // If user is a guide, redirect to guide home screen
                if (roleSnapshot.data == 'guide') {
                  return const GuideHomeScreen();
                }

                // Otherwise go to regular dashboard (tourist)
                return const DashboardScreen();
              },
            );
          }
          // User logged in but hasn't completed onboarding, show onboarding
          return const OnboardingScreen();
        },
      );
    }

    // No user logged in, show onboarding
    return const OnboardingScreen();
  }
}
