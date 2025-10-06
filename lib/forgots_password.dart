import 'package:flutter/material.dart';

class ForgotsPassword extends StatefulWidget {
  const ForgotsPassword({super.key});
  @override
  State<ForgotsPassword> createState() => _ForgotsPasswordState();
}

class _ForgotsPasswordState extends State<ForgotsPassword> {
  final emailController = TextEditingController();
  bool _loading = false;
  String _message = '';

  Future<void> _sendResetEmail() async {
    if (emailController.text.trim().isEmpty) return;
    
    setState(() {
      _loading = true;
      _message = '';
    });

    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _message = 'Password reset email sent successfully!';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your email address below and we\'ll send you a password reset link.',
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const Text('Email Address',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.green[700], fontSize: 14),
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Send Reset Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
