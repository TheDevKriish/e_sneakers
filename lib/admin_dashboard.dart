import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'loginscreen.dart';
import 'product_repository.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      products = ProductRepository().getProducts();
    });
  }

  void addNewProduct(Map<String, dynamic> newProduct) async {
    await ProductRepository().addProduct(newProduct);
    _loadProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin: Product Manager"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text("Products Management", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text("Total Products: ${products.length}", style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 16),
          ...products.map((p) => Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.black54),
              title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${p['brand']} | ${p['category']} | Status: Live"),
              trailing: Text("\$${p['price']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
                if (result != null) {
                  addNewProduct(result);
                }
              },
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
