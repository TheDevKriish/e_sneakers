import 'package:flutter/material.dart';
import 'product_repository.dart';
import 'product_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => favs = ProductRepository().getFavorites());

  void _remove(int id) async {
    await ProductRepository().removeFromFavorites(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: Text('Saved (${favs.length})')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final f = favs[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pink),
                    title: Text(f['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${f['brand']} • \$${f['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () => _remove((f['id'] ?? 0).toInt()),
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: f))),
                  ),
                );
              },
            ),
    );
  }
}
