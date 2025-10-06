import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = [
      {"id": "12345", "date": "2025-09-21", "item": "Air Max 270", "amount": 159, "status": "Delivered"},
      {"id": "12346", "date": "2025-09-18", "item": "Classic Black", "amount": 129, "status": "Shipped"},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: orders.map((o) => Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(o["item"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Date: ${o['date']} • Status: ${o['status']}"),
            trailing: Text("\$${o['amount']}"),
          ),
        )).toList(),
      ),
    );
  }
}
