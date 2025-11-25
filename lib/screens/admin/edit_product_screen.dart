// Edit product screen
// FILE: lib/screens/admin/edit_product_screen.dart
// PURPOSE: Edit existing product (WEB + MOBILE COMPATIBLE)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/products_provider.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';
import '../../services/firebase_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _storageService = FirebaseStorageService();

  Product? _product;
  XFile? _newImageXFile; // Changed from File? to XFile?
  final _imagePicker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Product) {
      _product = args;
      _populateFields();
    }
  }

  void _populateFields() {
    if (_product != null) {
      _nameController.text = _product!.name;
      _brandController.text = _product!.brand;
      _priceController.text = _product!.price.toString();
      _originalPriceController.text = _product!.originalPrice?.toString() ?? '';
      _categoryController.text = _product!.category;
      _descriptionController.text = _product!.description;
      _stockController.text = _product!.stock.toString();
    }
  }

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
        // Validate using XFile methods
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
          _newImageXFile = pickedFile;
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

  Future<void> _updateProduct() async {
    if (_product == null) return;
    if (!_formKey.currentState!.validate()) return;

    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    final success = await productsProvider.updateProduct(
      productId: _product!.id,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      originalPrice: _originalPriceController.text.trim().isNotEmpty
          ? double.parse(_originalPriceController.text.trim())
          : null,
      category: _categoryController.text.trim(),
      imageFile: _newImageXFile, // Pass XFile
      description: _descriptionController.text.trim(),
      stock: int.parse(_stockController.text.trim()),
      existingImageUrl: _product!.imageUrl,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productsProvider.errorMessage ?? 'Failed to update product'),
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
        title: const Text('Edit Product'),
      ),
      body: _product == null
          ? const Center(child: Text('Product not found'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Image Display/Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Stack(
                        children: [
                          // Display image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _newImageXFile != null
                                ? (kIsWeb
                                    ? Image.network(
                                        _newImageXFile!.path,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_newImageXFile!.path),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ))
                                : CachedNetworkImage(
                                    imageUrl: _product!.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),

                          // Change image overlay
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Change Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                    text: 'Update Product',
                    onPressed: _updateProduct,
                    isLoading: productsProvider.isLoading,
                  ),
                ],
              ),
            ),
    );
  }
}
