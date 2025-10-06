import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main_navigation.dart';
import 'admin_dashboard.dart';
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
    _go();
  }

  Future<void> _go() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      if (user['isAdmin'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_run, size: 72, color: Colors.black),
            SizedBox(height: 18),
            Text('StepUp', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.black)
          ],
        ),
      ),
    );
  }
}
