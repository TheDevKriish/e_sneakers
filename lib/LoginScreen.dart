import 'package:flutter/material.dart';
import 'signup.dart';
import 'forgots_password.dart';
import 'main_navigation.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF6366F1);

    void handleLogin() {
      if (emailController.text.endsWith('@admin.com')) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: 330,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.directions_run, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text('StepUp', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black)),
                  ]),
                  const SizedBox(height: 32),
                  const Text('Login', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: Colors.black)),
                  const SizedBox(height: 4),
                  const Text('Premium Sneakers & Footwear', style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 12)),
                  const SizedBox(height: 20),
                  const Text('Welcome back', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                  const SizedBox(height: 8),
                  const Text('Sign in to your account to continue', style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 14)),
                  const SizedBox(height: 28),
                  const Text('Email', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Enter valid email' : null,
                  ),
                  const SizedBox(height: 18),
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 6) ? 'Enter valid password' : null,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotsPassword())),
                      child: const Text('Forgot password?', style: TextStyle(color: accentColor, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) handleLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Don't have an account? "),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Signup())),
                      child: const Text('Sign up', style: TextStyle(color: accentColor, fontWeight: FontWeight.w600)),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
