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
    setState(() {
      _loading = true;
      _message = '';
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _message = 'Password reset email sent! (Simulated)';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF8F9FA);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Forgot Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email address to receive a password reset link.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF272727))),
            const SizedBox(height: 28),
            const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            if (_message.isNotEmpty)
              Text(_message, style: const TextStyle(color: Colors.green, fontSize: 14)),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)), elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Send Reset Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
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
