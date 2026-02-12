import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'features/auth/presentation/screens/tourist_signin_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async Firebase init
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
    );
  }
}
// update pubspec.yaml to add firebase_core dependency