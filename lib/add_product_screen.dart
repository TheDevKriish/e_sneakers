import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  File? selectedImage;
  
  final List<String> categories = ['Running', 'Casual', 'Formal', 'Sports', 'Lifestyle'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Add New Product", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Selection
                const Text("Product Image (Optional)", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text("Tap to add product image", style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text("Product Name", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter product name',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Product name required' : null,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Brand name required' : null,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Price required';
                    if (double.tryParse(v) == null) return 'Enter valid price';
                    return null;
                  },
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newProduct = {
                          'name': nameController.text.trim(),
                          'brand': brandController.text.trim(),
                          'price': double.parse(priceController.text).toInt(),
                          'originalPrice': originalPriceController.text.isEmpty 
                              ? null 
                              : double.parse(originalPriceController.text).toInt(),
                          'category': selectedCategory,
                          'description': descriptionController.text.trim().isEmpty 
                              ? 'No description available.' 
                              : descriptionController.text.trim(),
                          'image': selectedImage?.path ?? 'assets/sample1.png',
                          'rating': 4.0 + (DateTime.now().millisecond % 10) / 10,
                          'reviews': 15 + (DateTime.now().millisecond % 85),
                        };
                        Navigator.pop(context, newProduct);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
