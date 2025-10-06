import 'package:flutter/material.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_run, color: Colors.black, size: 64),
            SizedBox(height: 20),
            Text(
              "StepUp",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Sneaker Store",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
