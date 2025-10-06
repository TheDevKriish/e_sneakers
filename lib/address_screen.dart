import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> addresses = [
      {"title": "Home", "address": "12 Main Street, Springfield"},
      {"title": "Office", "address": "Block B, Downtown Plaza"},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ...addresses.map((a) => Card(
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.black),
              title: Text(a["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(a["address"]!),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.pop(context); // select, return to checkout
              },
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add New Address"),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black), foregroundColor: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
