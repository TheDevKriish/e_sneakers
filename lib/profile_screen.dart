import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(radius: 38, backgroundColor: Colors.black38),
          const SizedBox(height: 12),
          const Text("Lucis Caminos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text("luciscaminos@gmail.com", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          _statsRow(context),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white
              ),
              child: const Text("Edit Profile")
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen())); },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87, foregroundColor: Colors.white
              ),
              child: const Text("Order History")
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200], foregroundColor: Colors.red, elevation: 0
              ),
              child: const Text("Sign Out")
          ),
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _statBox('12', "Orders"),
        _statBox('3', "Saved"),
        _statBox('5', "Reviews"),
      ],
    );
  }
}

class _statBox extends StatelessWidget {
  final String count, label;
  const _statBox(this.count, this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
