import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text("Building 12, Main Street, Springfield", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Change"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFE5E7EB))),
              child: Row(
                children: const [
                  Icon(Icons.credit_card, color: Colors.black),
                  SizedBox(width: 8),
                  Expanded(child: Text("Credit / Debit Card")),
                  Icon(Icons.expand_more)
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: const Text('Thank you! Your order has been placed.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Place Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
