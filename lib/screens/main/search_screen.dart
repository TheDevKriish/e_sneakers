// Search screen
// FILE: lib/screens/main/search_screen.dart
// PURPOSE: Product search screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.searchProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search sneakers...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
          autofocus: true,
        ),
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsProvider, _) {
          if (productsProvider.searchQuery.isEmpty) {
            return const EmptyState(
              icon: Icons.search,
              title: 'Search Products',
              message: 'Enter a product name, brand, or category',
            );
          }

          if (productsProvider.products.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'No Results Found',
              message: 'Try searching with different keywords',
              actionLabel: 'Clear Search',
              onAction: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: productsProvider.products.length,
            itemBuilder: (context, index) {
              final product = productsProvider.products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
