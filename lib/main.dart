import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'screens/onboarding/welcome_screen.dart'; // Note the folder path!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
=======
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
>>>>>>> origin/develop

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'Sri Lanka Travel',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
      ),
      home: const WelcomeScreen(),
    );
  }
}
=======
      title: 'Hidden Moments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E4D3C)),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
>>>>>>> origin/develop
