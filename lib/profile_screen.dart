import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'order_history_screen.dart';
import 'change_password_screen.dart';
import 'address_book_screen.dart';
import 'payment_methods_screen.dart';
import 'loginscreen.dart';
import 'auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Guest User';
  String email = 'guest@example.com';
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      if (user != null) {
        name = user['name'] ?? name;
        email = user['email'] ?? email;
        isAdmin = user['isAdmin'] ?? false;
      }
    });
  }

  Future<void> _signOut() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 6),
              CircleAvatar(radius: 38, backgroundColor: Colors.black38, child: const Icon(Icons.person, color: Colors.white, size: 40)),
              const SizedBox(height: 10),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(email, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: _StatCard(label: 'Orders', value: '12')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Saved', value: '3')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Reviews', value: '5')),
                ],
              ),
              const SizedBox(height: 20),

              _tile(Icons.shopping_bag_outlined, 'Order History', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
              }),
              _tile(Icons.location_on_outlined, 'Address Book', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressBookScreen()));
              }),
              _tile(Icons.credit_card_outlined, 'Payment Methods', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
              }),
              _tile(Icons.person_outline, 'Edit Profile', () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                _loadUser();
              }),
              _tile(Icons.lock_outline, 'Change Password', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
              }),
              if (isAdmin)
                _tile(Icons.admin_panel_settings_outlined, 'Admin access enabled', () {}),

              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                    foregroundColor: Colors.red[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  const _StatCard({required this.label, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
