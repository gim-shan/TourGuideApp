import 'package:flutter/material.dart';
import 'screens/tsignup.dart';
import 'screens/tsignin.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HIDMO',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Times New Roman',
      ),
      routes: {
        '/': (context) => const TSignupPage(),
        '/signnin': (context) => const TSigninPage(),
      },
    );
  }
}