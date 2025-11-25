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
  
  final List<String> categories = ['Running', 'Casual', 'Formal', 'Sports', 'Sneakers'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => selectedImage = File(picked.path));
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Product Image (Optional)", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(selectedImage!, fit: BoxFit.cover, width: double.infinity),
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
                const SizedBox(height: 18),

                _label('Product Name'),
                _input(nameController, 'Enter product name', validator: (v) => v!.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 14),

                _label('Brand'),
                _input(brandController, 'Enter brand name', validator: (v) => v!.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 14),

                _label('Price'),
                _input(priceController, 'Enter price', prefix: '\$', keyboard: TextInputType.number,
                    validator: (v) => (v == null || double.tryParse(v) == null) ? 'Enter valid price' : null),
                const SizedBox(height: 14),

                _label('Original Price (Optional)'),
                _input(originalPriceController, 'Enter original price', prefix: '\$', keyboard: TextInputType.number),
                const SizedBox(height: 14),

                _label('Category'),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                  decoration: _dec(),
                ),
                const SizedBox(height: 14),

                _label('Description'),
                TextFormField(
                  controller: descriptionController,
                  decoration: _dec(hint: 'Enter product description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final p = {
                          'name': nameController.text.trim(),
                          'brand': brandController.text.trim(),
                          'price': double.parse(priceController.text).toInt(),
                          'originalPrice': originalPriceController.text.isEmpty ? null : double.parse(originalPriceController.text).toInt(),
                          'category': selectedCategory,
                          'description': descriptionController.text.trim().isEmpty ? 'No description available.' : descriptionController.text.trim(),
                          'image': selectedImage?.path ?? 'assets/sample1.png',
                          'rating': 4.2,
                          'reviews': 25,
                        };
                        Navigator.pop(context, p);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w500));
  InputDecoration _dec({String? hint, String? prefix}) => InputDecoration(
    hintText: hint,
    prefixText: prefix,
    filled: true, fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _input(TextEditingController c, String hint, {String? prefix, TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      decoration: _dec(hint: hint, prefix: prefix),
      validator: validator,
    );
  }
}
