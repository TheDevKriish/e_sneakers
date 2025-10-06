import 'package:flutter/material.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final List<Map<String, dynamic>> allProducts = [
    {'name': 'Air Max 270', 'brand': 'Nike', 'price': 159, 'image': 'assets/sample1.png', 'rating': 4.5, 'reviews': 128},
    {'name': 'Classic Black', 'brand': 'Adidas', 'price': 129, 'image': 'assets/sample2.png', 'rating': 4.2, 'reviews': 95},
    {'name': 'Ultraboost 22', 'brand': 'Adidas', 'price': 190, 'image': 'assets/sample1.png', 'rating': 4.6, 'reviews': 92},
    {'name': 'Chuck Taylor All Star', 'brand': 'Converse', 'price': 55, 'image': 'assets/sample2.png', 'rating': 4.0, 'reviews': 63},
  ];

  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    results = allProducts;
  }

  void _runSearch(String input) {
    setState(() {
      if (input.isEmpty) {
        results = allProducts;
      } else {
        results = allProducts.where((p) =>
          p['name'].toString().toLowerCase().contains(input.toLowerCase()) ||
          p['brand'].toString().toLowerCase().contains(input.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search sneakers, brands...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: _runSearch,
            ),
            const SizedBox(height: 22),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final product = results[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.directions_run, color: Colors.grey[400], size: 32),
                            title: Text(product['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text(product['brand']),
                            trailing: Text('\$${product['price']}'),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductScreen(product: product),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
