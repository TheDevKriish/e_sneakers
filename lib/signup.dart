import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'main_navigation.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}
class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF6366F1);

    void handleSignup() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));

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
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.directions_run, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text('StepUp', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black)),
                  ]),
                  const SizedBox(height: 32),
                  const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: Colors.black)),
                  const SizedBox(height: 8),
                  const Text('Join thousands of sneaker enthusiasts\nand discover your perfect pair',
                    style: TextStyle(color: Color(0xFF7C7C7C), fontSize: 14)),
                  const SizedBox(height: 32),
                  const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name required' : null,
                  ),
                  const SizedBox(height: 18),
                  const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Enter valid email' : null,
                  ),
                  const SizedBox(height: 18),
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 8) ? 'Minimum 8 characters' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreed,
                        onChanged: (v) => setState(() => _agreed = v ?? false),
                      ),
                      const Text("I agree to Terms & Policy"),
                    ],
                  ),
                  if (!_agreed)
                    const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        'You must agree to Terms & Policy',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _agreed) handleSignup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: Text('Sign In', style: TextStyle(color: accentColor, fontWeight: FontWeight.w600)),
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
