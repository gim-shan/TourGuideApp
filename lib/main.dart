import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hidmo_app/features/auth/presentation/screens/onboarding_screen.dart';

//import 'features/auth/presentation/screens/tourist_signin_screen.dart';
import 'features/auth/presentation/screens/dashboard_screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async async Firebase init

  // Initialize Stripe with your publishable key
  // Get this from https://dashboard.stripe.com/test/apikeys
  Stripe.publishableKey =
      'pk_test_51TCDnp7lC3WAYGa8JemAIbhkFSMj3jf6QvG2G90LkSqeozeRFIDFtLFEjQ9MiBHQEULCo0t7cHrvnrqlVRpvI5jC00VXzlrmHH';

  await Firebase.initializeApp(); // Initialize Firebase
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
      home: const OnboardingScreen(),
      // home: const DashboardScreen(),
    );
  }
}
