import 'package:flutter/material.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List<String> demoResults = ["Air Max Pro", "Classic Black", "Ultraboost 22", "Canvas White", "Sport Gray"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search sneakers, brands, etc.",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                children: demoResults.where((r) =>
                  r.toLowerCase().contains(searchController.text.toLowerCase())
                ).map((r) =>
                    Card(
                      child: ListTile(
                        title: Text(r, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen())),
                      ),
                    ))
                .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
