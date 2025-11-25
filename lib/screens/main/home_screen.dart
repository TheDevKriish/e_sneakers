// FILE: lib/screens/main/home_screen.dart
// PURPOSE: Main home screen with product grid

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/empty_state.dart';
import '../../config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favProvider = Provider.of<FavoritesProvider>(context, listen: false);

    await Future.wait([
      productsProvider.loadProducts(),
      cartProvider.loadCart(),
      favProvider.loadFavorites(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StepUp'),
        actions: [
          // Admin Dashboard Button
          if (authProvider.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.adminDashboard);
              },
              tooltip: 'Admin Dashboard',
            ),

          // Favorites Button
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.favorites);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer<ProductsProvider>(
          builder: (context, productsProvider, _) {
            if (productsProvider.isLoading && productsProvider.products.isEmpty) {
              return const LoadingIndicator(message: 'Loading products...');
            }

            if (productsProvider.products.isEmpty) {
              return EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'No Products Found',
                message: 'Check back later for new arrivals',
                actionLabel: 'Refresh',
                onAction: _loadData,
              );
            }

            return Column(
              children: [
                // Category Filter
                _buildCategoryFilter(productsProvider),

                // Product Grid
                Expanded(
                  child: GridView.builder(
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(ProductsProvider productsProvider) {
    final categories = productsProvider.getCategories();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = productsProvider.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                productsProvider.filterByCategory(category);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
