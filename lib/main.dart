import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const OseApp());
}

class OseApp extends StatelessWidget {
  const OseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ose',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
