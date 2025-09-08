import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BlackjackApp());
}

class BlackjackApp extends StatelessWidget {
  const BlackjackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack Capstone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF006400), // dark green
      ),
      home: const HomeScreen(),
    );
  }
}
