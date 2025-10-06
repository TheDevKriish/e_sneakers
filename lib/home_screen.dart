import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import 'product_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> featuredProducts = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Sneakers', 'icon': Icons.directions_run},
    {'name': 'Running', 'icon': Icons.fitness_center},
    {'name': 'Formal', 'icon': Icons.business},
    {'name': 'Sports', 'icon': Icons.sports_basketball},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Small delay for smooth loading
    setState(() {
      featuredProducts = ProductRepository().getProducts();
      isLoading = false;
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    await ProductRepository().addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_run, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text('StepUp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
          ],
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadProducts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.black, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'New',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Step into\nStyle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.directions_run, color: Colors.white, size: 40),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Categories
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Icon(
                                category['icon'],
                                color: Colors.black87,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category['name'],
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Featured Products
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Products',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: _loadProducts,
                      child: const Text('Refresh', style: TextStyle(color: Colors.black54)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.black))
                    : featuredProducts.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No products available',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Admin can add products from admin panel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredProducts.length,
                              itemBuilder: (context, index) {
                                final product = featuredProducts[index];
                                return _buildProductCard(product);
                              },
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    // Safe field access with null checks and defaults
    final String name = product['name']?.toString() ?? 'Unknown Product';
    final String brand = product['brand']?.toString() ?? 'Unknown Brand';
    final int price = (product['price'] is int) ? product['price'] : ((product['price'] is double) ? product['price'].toInt() : 0);
    final int? originalPrice = product['originalPrice'] != null ? 
        ((product['originalPrice'] is int) ? product['originalPrice'] : ((product['originalPrice'] is double) ? product['originalPrice'].toInt() : null)) 
        : null;
    final double rating = (product['rating'] ?? 0.0).toDouble();
    final int reviews = (product['reviews'] ?? 0).toInt();
    final int productId = (product['id'] ?? DateTime.now().millisecondsSinceEpoch).toInt();

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.directions_run,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      if (ProductRepository().isFavorite(productId)) {
                        await ProductRepository().removeFromFavorites(productId);
                      } else {
                        await ProductRepository().addToFavorites(product);
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        ProductRepository().isFavorite(productId) 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        size: 16,
                        color: ProductRepository().isFavorite(productId) 
                            ? Colors.red 
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  brand,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${rating.toStringAsFixed(1)} ($reviews)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$$price',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (originalPrice != null && originalPrice > price)
                          Text(
                            '\$$originalPrice',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _addToCart(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
