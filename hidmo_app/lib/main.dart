import 'package:flutter/material.dart';
import 'screens/t_signup.dart';
import 'screens/t_signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIDMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, 
      ),
      home: const TSignup(),
      routes: {
        '/signup': (context) => const TSignup(), //check
        '/signin': (context) => const TSignin(),
      },
    );
  }
}