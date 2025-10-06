import 'package:flutter/material.dart';
import 'product_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final demoFavorites = [
      {"title": "Air Max Pro", "price": 149},
      {"title": "Classic Black", "price": 129},
      {"title": "Sport Gray", "price": 169},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: demoFavorites.map((fav) => Card(
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pink),
            title: Text(fav['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("\$${fav['price']}", style: const TextStyle(color: Colors.black54)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {},
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen())),
          ),
        )).toList(),
      ),
    );
  }
}
