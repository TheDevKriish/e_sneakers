import 'package:flutter/material.dart';
import 'product_repository.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController brandCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController originalCtrl;
  late final TextEditingController descCtrl;
  String category = 'Sneakers';

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: (widget.product['name'] ?? '').toString());
    brandCtrl = TextEditingController(text: (widget.product['brand'] ?? '').toString());
    priceCtrl = TextEditingController(text: (widget.product['price'] ?? 0).toString());
    originalCtrl = TextEditingController(text: (widget.product['originalPrice'] ?? '').toString());
    descCtrl = TextEditingController(text: (widget.product['description'] ?? '').toString());
    category = (widget.product['category'] ?? 'Sneakers').toString();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    brandCtrl.dispose();
    priceCtrl.dispose();
    originalCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, {String? prefix}) => InputDecoration(
        hintText: hint,
        prefixText: prefix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final id = (widget.product['id'] ?? 0).toInt();
    final list = ProductRepository().getProducts();

    final idx = list.indexWhere((e) => ((e['id'] ?? -1).toInt()) == id);
    if (idx >= 0) {
      list[idx] = {
        'id': id,
        'name': nameCtrl.text.trim(),
        'brand': brandCtrl.text.trim(),
        'price': int.tryParse(priceCtrl.text.trim()) ?? 0,
        'originalPrice': originalCtrl.text.trim().isEmpty ? null : int.tryParse(originalCtrl.text.trim()),
        'category': category,
        'image': widget.product['image'] ?? 'assets/sample1.png',
        'rating': (widget.product['rating'] ?? 4.2).toDouble(),
        'reviews': (widget.product['reviews'] ?? 25).toInt(),
        'description': descCtrl.text.trim().isEmpty ? 'No description available.' : descCtrl.text.trim(),
      };
      await ProductRepository().saveProducts();
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final cats = ['Sneakers', 'Running', 'Casual', 'Formal', 'Sports'];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('Edit Product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: nameCtrl, decoration: _dec('Product Name'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: brandCtrl, decoration: _dec('Brand'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  decoration: _dec('Price', prefix: '\$'),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || int.tryParse(v) == null) ? 'Enter valid price' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: originalCtrl,
                  decoration: _dec('Original Price (optional)', prefix: '\$'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  items: cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => category = v ?? 'Sneakers'),
                  decoration: _dec('Category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: _dec('Description'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
