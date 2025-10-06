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
      appBar: AppBar(
        title: const Text("Order History", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: orders.map((order) => Card(
          child: ListTile(
            title: Text(order["item"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Date: ${order['date']}\nStatus: ${order['status']}"),
            trailing: Text("\$${order['amount']}"),
          ),
        )).toList(),
      ),
    );
  }
}
