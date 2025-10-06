import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {"name": "Air Max 270", "price": 159},
      {"name": "Classic Black", "price": 129},
      {"name": "Canvas White", "price": 89},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin: Product Manager", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0, iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ...products.map((p) => Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.black54),
              title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text("\$${p['price']}"),
              subtitle: const Text("Status: Live"),
              onTap: () {},
            ),
          )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {},
              label: const Text("Add New Product"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
