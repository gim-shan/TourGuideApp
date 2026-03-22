import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hidmo_app/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:hidmo_app/features/auth/presentation/screens/auth_service.dart';
import 'package:hidmo_app/features/live_events/data/utils/event_database_initializer.dart';

//import 'features/auth/presentation/screens/tourist_signin_screen.dart';
import 'features/auth/presentation/screens/dashboard_screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async async Firebase init

  // Initialize Stripe with your publishable key
  // Get this from https://dashboard.stripe.com/test/apikeys
  Stripe.publishableKey =
      'pk_test_51TCDnp7lC3WAYGa8JemAIbhkFSMj3jf6QvG2G90LkSqeozeRFIDFtLFEjQ9MiBHQEULCo0t7cHrvnrqlVRpvI5jC00VXzlrmHH';

  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize Live Events Database
  await EventDatabaseInitializer.initializeDatabase();

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
            // User has completed onboarding, go to dashboard
            return const DashboardScreen();
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
