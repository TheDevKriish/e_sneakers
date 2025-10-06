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
  String selectedCategory = 'All';
  bool isLoading = true;

  final List<Map<String, dynamic>> categories = const [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Sneakers', 'icon': Icons.directions_run},
    {'name': 'Running', 'icon': Icons.fitness_center},
    {'name': 'Casual', 'icon': Icons.weekend},
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
    await ProductRepository().loadData();
    setState(() {
      featuredProducts = ProductRepository().getProducts();
      isLoading = false;
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    await ProductRepository().addToCart(product);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
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
    final filtered = selectedCategory == 'All'
        ? featuredProducts
        : featuredProducts.where((e) => (e['category'] ?? '') == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              child: const Icon(Icons.directions_run, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text('StepUp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
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
                _hero(),
                const SizedBox(height: 24),
                const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _categories(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Featured Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: _loadProducts, child: const Text('Refresh', style: TextStyle(color: Colors.black54))),
                  ],
                ),
                const SizedBox(height: 12),
                if (isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: Colors.black)))
                else if (filtered.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No products in this category', style: TextStyle(color: Colors.black54)),
                    ),
                  )
                else
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        return _productCard(p);
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

  Widget _hero() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.black, Colors.grey], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 20,
            top: 20,
            child: Text('Step into\nStyle', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.directions_run, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final c = categories[i];
          final isSel = c['name'] == selectedCategory;
          return InkWell(
            onTap: () => setState(() => selectedCategory = c['name'] as String),
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: isSel ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSel ? Colors.black : const Color(0xFFE5E7EB)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(c['icon'] as IconData, color: isSel ? Colors.white : Colors.black87, size: 26),
                  const SizedBox(height: 4),
                  Text(c['name'] as String, style: TextStyle(color: isSel ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.w600))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    final name = product['name']?.toString() ?? 'Unknown';
    final brand = product['brand']?.toString() ?? 'Brand';
    final price = product['price'] ?? 0;
    final originalPrice = product['originalPrice'];
    final rating = (product['rating'] ?? 0.0).toDouble();
    final reviews = (product['reviews'] ?? 0).toInt();

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 150,
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: Stack(
              children: [
                Center(child: Icon(Icons.directions_run, size: 70, color: Colors.grey[400])),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      final id = (product['id'] ?? 0).toInt();
                      if (ProductRepository().isFavorite(id)) {
                        await ProductRepository().removeFromFavorites(id);
                      } else {
                        await ProductRepository().addToFavorites(product);
                      }
                      if (!mounted) return;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        ProductRepository().isFavorite((product['id'] ?? 0).toInt()) ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: ProductRepository().isFavorite((product['id'] ?? 0).toInt()) ? Colors.red : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(brand, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text('${rating.toStringAsFixed(1)} ($reviews)', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (originalPrice != null && originalPrice > price)
                        Text('\$$originalPrice', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[500], fontSize: 12)),
                    ]),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: product))),
                          icon: const Icon(Icons.open_in_new, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: () => _addToCart(product),
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                        ),
                      ],
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
