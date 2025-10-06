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
    Colors.grey,
    Colors.blue,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    isFavorite = ProductRepository().isFavorite((widget.product['id'] ?? 0).toInt());
  }

  void _addToCart() async {
    await ProductRepository().addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product['name']} added to cart'), backgroundColor: Colors.green),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  void _toggleFavorite() async {
    final id = (widget.product['id'] ?? 0).toInt();
    if (isFavorite) {
      await ProductRepository().removeFromFavorites(id);
    } else {
      await ProductRepository().addToFavorites(widget.product);
    }
    setState(() => isFavorite = !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.product['name']?.toString() ?? 'Unknown';
    final brand = widget.product['brand']?.toString() ?? 'Brand';
    final price = widget.product['price'] ?? 0;
    final originalPrice = widget.product['originalPrice'];
    final rating = (widget.product['rating'] ?? 0.0).toDouble();
    final reviews = (widget.product['reviews'] ?? 0).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.black54),
            onPressed: _toggleFavorite,
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 260,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Icon(Icons.directions_run, size: 120, color: Colors.grey[400])),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(brand, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                        ]),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                        if (originalPrice != null && originalPrice > price)
                          Text('\$$originalPrice', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[500])),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(i < rating.floor() ? Icons.star : Icons.star_border, color: Colors.amber, size: 18)),
                      const SizedBox(width: 6),
                      Text('${rating.toStringAsFixed(1)} ($reviews)', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: sizes.map((s) {
                      final sel = selectedSize == s;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = s),
                        child: Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                            color: sel ? Colors.black : Colors.white,
                            border: Border.all(color: sel ? Colors.black : const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text('$s', style: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: colors.asMap().entries.map((e) {
                      final i = e.key; final c = e.value;
                      final sel = selectedColorIndex == i;
                      return GestureDetector(
                        onTap: () => setState(() => selectedColorIndex = i),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(color: sel ? Colors.black : Colors.grey[300]!, width: sel ? 3 : 1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    widget.product['description']?.toString() ??
                        'Experience comfort and style every step of the day.',
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
