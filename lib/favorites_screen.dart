import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'product_repository.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      favorites = ProductRepository().getFavorites();
    });
  }

  void _removeFavorite(int productId) async {
    await ProductRepository().removeFromFavorites(productId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Favorites (${favorites.length})"),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text("No favorites yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text("Add products to favorites to see them here", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: favorites.length,
              itemBuilder: (ctx, idx) {
                final fav = favorites[idx];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.pink[400]),
                    title: Text(fav['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${fav['brand']} • \$${fav['price']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () => _removeFavorite(fav['id']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductScreen(product: fav)),
                      ).then((_) => _loadFavorites());
                    },
                  ),
                );
              },
            ),
    );
  }
}
