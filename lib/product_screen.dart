import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'product_repository.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedSize = 8;
  int selectedColorIndex = 0;
  bool isFavorite = false;

  final List<int> sizes = [7, 8, 9, 10, 11, 12];
  final List<Color> colors = [
    Colors.black,
    Colors.grey[600]!,
    Colors.blue[700]!,
    Colors.brown[400]!,
  ];

  @override
  void initState() {
    super.initState();
    isFavorite = ProductRepository().isFavorite(widget.product['id']);
  }

  void _addToCart() async {
    await ProductRepository().addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['name']} added to cart!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navigate to cart after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await ProductRepository().removeFromFavorites(widget.product['id']);
    } else {
      await ProductRepository().addToFavorites(widget.product);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.product['name']),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black54,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_run,
                        size: 120,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.product['brand'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${widget.product['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                if (widget.product['originalPrice'] != null)
                                  Text(
                                    '\$${widget.product['originalPrice']}',
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Rating
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < (widget.product['rating'] ?? 0).floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.product['rating'] ?? 0} (${widget.product['reviews'] ?? 0} reviews)',
                              style: const TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Size Selection
                        const Text(
                          'Size',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: sizes.map((size) {
                            final isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    size.toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Color Selection
                        const Text(
                          'Color',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: colors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final color = entry.value;
                            final isSelected = selectedColorIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedColorIndex = index),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.grey[300]!,
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'] ?? 'Experience ultimate comfort and style with the ${widget.product['name']}. Featuring premium materials and innovative design, these sneakers are perfect for both casual wear and athletic activities.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
      