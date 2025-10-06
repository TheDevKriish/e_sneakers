import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/login"); // Make sure route is defined in MaterialApp if using named routes
    });
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.directions_run, color: Colors.black, size: 60),
              SizedBox(height: 20),
              Text("StepUp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black)),
              SizedBox(height: 5),
              Text("Sneaker Store", style: TextStyle(color: Colors.black54)),
            ],
          ),
        )
      );
  }
}
