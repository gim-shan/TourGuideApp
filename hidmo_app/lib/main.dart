import 'package:flutter/material.dart';

//import 'features/auth/presentation/screens/tourist_signin_screen.dart';
import 'features/auth/presentation/screens/guide_signin_screen.dart';

void main() {
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
        useMaterial3: true
      ),
      home: const GSignInScreen(),
    );
  }
}