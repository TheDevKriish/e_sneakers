import 'package:flutter/material.dart';
import 'loginscreen.dart';

void main() {
  runApp(const StepUpApp());
}

class StepUpApp extends StatelessWidget {
  const StepUpApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "StepUp",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
        primaryColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}
