import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import 'product_repository.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => items = ProductRepository().getCart());
  }

  void _updateQty(int id, int qty) async {
    await ProductRepository().updateCartQuantity(id, qty);
    _load();
  }

  double get subtotal => items.fold(0.0, (s, i) => s + (i['price'] * (i['quantity'] ?? 1)));
  double get shipping => items.isEmpty ? 0 : 15.0;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Cart (${items.length})'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await ProductRepository().clearCart();
                _load();
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? _empty()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _item(items[i]),
                  ),
                ),
                _summary(),
              ],
            ),
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Add some sneakers to get started', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );

  Widget _item(Map<String, dynamic> i) {
    final id = (i['id'] ?? 0).toInt();
    final qty = (i['quantity'] ?? 1).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.directions_run, size: 36, color: Colors.grey[400])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(i['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${i['brand']} • Size ${i['size']} • ${i['color']}'),
              const SizedBox(height: 6),
              Text('\$${i['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
          ),
          Column(
            children: [
              Row(children: [
                _qtyButton(Icons.remove, () => _updateQty(id, qty - 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                _qtyButton(Icons.add, () => _updateQty(id, qty + 1)),
              ]),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _updateQty(id, 0),
                child: Icon(Icons.delete_outline, color: Colors.red[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData ic, VoidCallback onTap) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
        child: InkWell(onTap: onTap, child: Icon(ic, size: 18)),
      );

  Widget _summary() => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            _row('Subtotal (${items.fold<int>(0, (s, i) => s + ((i['quantity'] ?? 1) as int))} items)', subtotal),
            _row('Shipping', shipping),
            _row('Tax', tax),
            const Divider(),
            _row('Total', total, bold: true),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );

  Widget _row(String label, double amount, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: TextStyle(color: bold ? Colors.black : Colors.black54, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ]),
      );
}
