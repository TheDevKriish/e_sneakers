import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final priceController = TextEditingController();
  final originalPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Running';
  
  final List<String> categories = ['Running', 'Casual', 'Formal', 'Sports', 'Lifestyle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Product Name", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter product name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Product name required' : null,
                ),
                const SizedBox(height: 18),
                
                const Text("Brand", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: brandController,
                  decoration: InputDecoration(
                    hintText: 'Enter brand name (Nike, Adidas, etc.)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Brand name required' : null,
                ),
                const SizedBox(height: 18),
                
                const Text("Price", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: 'Enter selling price',
                    prefixText: '\$',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Price required' : null,
                ),
                const SizedBox(height: 18),
                
                const Text("Original Price (Optional)", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: originalPriceController,
                  decoration: InputDecoration(
                    hintText: 'Enter original price for discount',
                    prefixText: '\$',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 18),
                
                const Text("Category", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: categories.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                const SizedBox(height: 18),
                
                const Text("Description", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter product description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newProduct = {
                          'name': nameController.text.trim(),
                          'brand': brandController.text.trim(),
                          'price': int.parse(priceController.text),
                          'originalPrice': originalPriceController.text.isEmpty 
                              ? null 
                              : int.parse(originalPriceController.text),
                          'category': selectedCategory,
                          'description': descriptionController.text.trim(),
                          'image': 'assets/sample1.png',
                          'rating': 4.0 + (DateTime.now().millisecond % 10) / 10, // Random rating 4.0-4.9
                          'reviews': 15 + (DateTime.now().millisecond % 85), // Random reviews 15-100
                        };
                        Navigator.pop(context, newProduct);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
