import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _cartItem("Air Jordan 1 Retro", "White/Black, Size 9", 170, 1),
                _cartItem("Ultraboost 22", "Core Black, Size 8", 190, 2),
                _cartItem("Chuck Taylor All Star", "Optical White, Size 7", 55, 1),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  Text("Subtotal (4 items)"),
                  Text("\$805"),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  Text("Shipping"),
                  Text("\$15"),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  Text("Tax"),
                  Text("\$48.40"),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$868.40", style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(String title, String subtitle, int price, int qty) => Card(
    child: ListTile(
      leading: const Icon(Icons.shopping_bag, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("\$$price", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Qty: $qty"),
        ],
      ),
    ),
  );
}
