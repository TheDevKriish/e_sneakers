import 'package:flutter/material.dart';
import 'product_repository.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> all = [];
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    all = ProductRepository().getProducts();
    results = List.from(all);
  }

  String _getString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  int _getInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  void _run(String v) {
    setState(() {
      if (v.trim().isEmpty) {
        results = List.from(all);
      } else {
        results = all.where((p) {
          final name = _getString(p['name'], '').toLowerCase();
          final brand = _getString(p['brand'], '').toLowerCase();
          final query = v.toLowerCase();
          return name.contains(query) || brand.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: _run,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search sneakers, brands...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final p = results[i];
                        final name = _getString(p['name'], 'Unknown Product');
                        final brand = _getString(p['brand'], 'Unknown Brand');
                        final price = _getInt(p['price'], 0);
                        
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.directions_run, color: Colors.grey[400], size: 32),
                            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(brand),
                            trailing: Text('\$$price'),
                            onTap: () => Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (_) => ProductScreen(product: p))
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
