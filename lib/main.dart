import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const StepUpApp());
}

class StepUpApp extends StatelessWidget {
  const StepUpApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StepUp',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F9FA),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
