import 'package:flutter/material.dart';
import 'product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StepUp", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0, centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Image.asset("assets/sample_sneaker.png", height: 70),
              title: const Text('Air Max Pro', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              subtitle: const Text('Premium comfort\n\$149'),
              trailing: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Add to Cart'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categoryBox("Sneakers"), _categoryBox("Running"), _categoryBox("Formal"), _categoryBox("Sports"),
            ],
          ),
          const SizedBox(height: 30),
          const Text("Featured", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _productRow(context, "Classic Black", 129),
          _productRow(context, "Canvas White", 89),
          _productRow(context, "Sport Gray", 169),
          const SizedBox(height: 30),
          const Text("Popular Brands", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(children: [for (var brand in ["Nike", "Adidas", "Puma", "Vans"]) _brandCircle(brand)]),
        ],
      ),
    );
  }

  static Widget _categoryBox(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 3),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xFFE5E7EB)),
    ),
    child: Column(
      children: [
        Icon(Icons.checkroom_outlined, size: 24, color: Colors.black54),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
      ],
    ),
  );

  static Widget _brandCircle(String brand) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: 23,
      child: Text(brand[0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    ),
  );

  static Widget _productRow(BuildContext ctx, String title, int price) => Card(
    child: ListTile(
      leading: const Icon(Icons.shopping_bag_outlined, color: Colors.black87, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('\$$price', style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: TextButton(
        onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ProductScreen())),
        child: const Text('Add'),
      ),
    ),
  );
}
