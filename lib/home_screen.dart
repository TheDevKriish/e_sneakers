import 'package:flutter/material.dart';
import 'product_repository.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import 'search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [];
  String selectedCategory = 'All';
  bool isLoading = true;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Sneakers', 'icon': Icons.directions_run},
    {'name': 'Running', 'icon': Icons.fitness_center},
    {'name': 'Casual', 'icon': Icons.weekend},
    {'name': 'Formal', 'icon': Icons.business_center},
    {'name': 'Sports', 'icon': Icons.sports_basketball},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> loadedProducts = await ProductRepository().getProducts();
    if (mounted) {
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 'All') return products;
    return products.where((p) => p['category'] == selectedCategory).toList();
  }

  void _toggleFavorite(Map<String, dynamic> product) async {
    String productId = product['id'].toString();
    bool isFav = await ProductRepository().isFavorite(productId);
    if (isFav) {
      await ProductRepository().removeFromFavorites(productId);
    } else {
      await ProductRepository().addToFavorites(product);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadProducts(),
          color: Colors.black,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildBanner()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildSectionTitle()),
              isLoading
                  ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.black)))
                  : filteredProducts.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildProductCard(filteredProducts[index]),
                              childCount: filteredProducts.length,
                            ),
                          ),
                        ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: const Icon(Icons.directions_run, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('StepUp', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Find your perfect pair', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            icon: const Icon(Icons.shopping_cart_outlined, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[500]),
              const SizedBox(width: 12),
              Text('Search sneakers, brands...', style: TextStyle(color: Colors.grey[500], fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(Icons.directions_run, size: 180, color: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New Collection', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  const Text('Step Into\nStyle', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Shop Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
// ============================================================
// FILE 12: lib/home_screen.dart - PART 2 OF 2
// CONTINUATION - Remaining Widget Methods
// ============================================================

  // --- _buildCategories Widget ---
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- _buildProductsGrid Widget ---
  Widget _buildProductsGrid() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final products = filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No products found for "$_searchQuery"'
                    : 'No products available in this category',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Sneakers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${products.length} items',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // --- _buildProductCard Widget ---
  Widget _buildProductCard(Map<String, dynamic> product) {
    final productId = product['id'] ?? '';
    final isFavorite = _favorites.contains(productId);
    final hasDiscount = product['originalPrice'] != null &&
        product['originalPrice'] > product['price'];
    
    double discountPercent = 0;
    if (hasDiscount) {
      discountPercent = ((product['originalPrice'] - product['price']) /
              product['originalPrice'] *
              100)
          .roundToDouble();
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product',
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Favorite Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: product['imageUrl'] != null &&
                              product['imageUrl'].toString().isNotEmpty
                          ? Image.network(
                              product['imageUrl'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${discountPercent.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(productId),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand
                    Text(
                      product['brand'] ?? 'Brand',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Product Name
                    Text(
                      product['name'] ?? 'Product Name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Rating Row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          '${product['rating'] ?? 4.5}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product['reviews'] ?? 0})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    // Price Row
                    Row(
                      children: [
                        Text(
                          '\$${(product['price'] ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${(product['originalPrice']).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    _addToCart(product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    // --- _addToCart Method (COMPLETE) ---
  void _addToCart(Map<String, dynamic> product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please login to add items to cart'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Login',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
      );
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(product['id']);

      final cartDoc = await cartRef.get();

      if (cartDoc.exists) {
        await cartRef.update({
          'quantity': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await cartRef.set({
          'productId': product['id'],
          'name': product['name'],
          'brand': product['brand'],
          'price': product['price'],
          'originalPrice': product['originalPrice'],
          'imageUrl': product['imageUrl'],
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${product['name']} added to cart',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[500],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart: ${e.toString()}'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // --- _loadFavorites Method ---
  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final favSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      setState(() {
        _favorites = favSnapshot.docs.map((doc) => doc.id).toSet();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
// ============================================================
// END OF FILE 12: lib/home_screen.dart
// ============================================================
