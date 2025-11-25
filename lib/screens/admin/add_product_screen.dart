// Add product screen
// FILE: lib/screens/admin/add_product_screen.dart
// PURPOSE: Add new product with image upload (WEB + MOBILE COMPATIBLE)

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';
import '../../services/firebase_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _storageService = FirebaseStorageService();

  XFile? _selectedImageXFile; // Use XFile for web compatibility
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Validate image format using XFile methods
        if (!_storageService.isValidImageXFile(pickedFile)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a valid image (JPG, JPEG, or PNG format)'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Check file size using XFile methods
        if (!await _storageService.isValidFileSizeXFile(pickedFile)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image size must be less than 5MB'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _selectedImageXFile = pickedFile;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // Image is optional
    
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    final success = await productsProvider.addProduct(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      originalPrice: _originalPriceController.text.trim().isNotEmpty
          ? double.parse(_originalPriceController.text.trim())
          : null,
      category: _categoryController.text.trim(),
      imageFile: _selectedImageXFile, // Pass XFile
      description: _descriptionController.text.trim(),
      stock: int.parse(_stockController.text.trim()),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productsProvider.errorMessage ?? 'Failed to add product'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _selectedImageXFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                _selectedImageXFile!.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedImageXFile!.path),
                                fit: BoxFit.cover,
                              ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to select product image (Optional)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Formats: JPG, JPEG, PNG',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            CustomTextField(
              controller: _nameController,
              label: 'Product Name',
              validator: (value) => Validators.validateRequired(value, 'Product name'),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _brandController,
              label: 'Brand',
              validator: (value) => Validators.validateRequired(value, 'Brand'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _priceController,
                    label: 'Price (₹)',
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePrice,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _originalPriceController,
                    label: 'Original Price (Optional)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _categoryController,
              label: 'Category',
              validator: (value) => Validators.validateRequired(value, 'Category'),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _stockController,
              label: 'Stock Quantity',
              keyboardType: TextInputType.number,
              validator: Validators.validateStock,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
              validator: (value) => Validators.validateRequired(value, 'Description'),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Add Product',
              onPressed: _addProduct,
              isLoading: productsProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
