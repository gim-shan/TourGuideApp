import 'package:flutter/material.dart';
// Importing the main Live Events screen
import 'features/live_events/presentation/screens/live_events_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Setting LiveEventsScreen as the starting point for this test
      home: LiveEventsScreen(),
    );
  }
}