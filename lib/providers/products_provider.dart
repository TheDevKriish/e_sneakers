// Products provider
// FILE: lib/providers/products_provider.dart
// PURPOSE: Products state management with Provider

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_product_service.dart';
import '../services/firebase_storage_service.dart';
import 'dart:io';

class ProductsProvider with ChangeNotifier {
  final FirebaseProductService _productService = FirebaseProductService();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products => _filteredProducts.isEmpty && _searchQuery.isEmpty 
      ? _products 
      : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      // Check in memory first
      final cachedProduct = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => _products.first,
      );
      
      if (cachedProduct.id == productId) {
        return cachedProduct;
      }

      // Fetch from Firestore
      return await _productService.getProductById(productId);
    } catch (e) {
      return null;
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Apply search and category filters
  void _applyFilters() {
    List<Product> filtered = List.from(_products);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(queryLower) ||
            p.brand.toLowerCase().contains(queryLower) ||
            p.category.toLowerCase().contains(queryLower);
      }).toList();
    }

    _filteredProducts = filtered;
  }

  // Add product (Admin only) - IMAGE IS NOW OPTIONAL
  Future<bool> addProduct({
    required String name,
    required String brand,
    required double price,
    double? originalPrice,
    required String category,
    File? imageFile, // Made optional
    required String description,
    required int stock,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create product with temporary ID and empty imageUrl
      final tempProduct = Product(
        id: 'temp',
        name: name,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        category: category,
        imageUrl: '', // Start with empty imageUrl
        description: description,
        stock: stock,
        createdAt: DateTime.now(),
      );

      // Add to Firestore first
      final productId = await _productService.addProduct(tempProduct);

      String imageUrl = '';
      
      // Upload image only if provided
      if (imageFile != null) {
        imageUrl = await _storageService.uploadProductImage(imageFile, productId);
      }

      // Update product with image URL (or keep empty if no image)
      final finalProduct = tempProduct.copyWith(id: productId, imageUrl: imageUrl);
      await _productService.updateProduct(finalProduct);

      // Reload products
      await loadProducts();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update product (Admin only)
  Future<bool> updateProduct({
    required String productId,
    required String name,
    required String brand,
    required double price,
    double? originalPrice,
    required String category,
    File? imageFile,
    required String description,
    required int stock,
    String? existingImageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String imageUrl = existingImageUrl ?? '';

      // Upload new image if provided
      if (imageFile != null) {
        // Delete old image if exists
        if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
          await _storageService.deleteProductImage(existingImageUrl);
        }
        imageUrl = await _storageService.uploadProductImage(imageFile, productId);
      }

      // Update product
      final updatedProduct = Product(
        id: productId,
        name: name,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        category: category,
        imageUrl: imageUrl,
        description: description,
        stock: stock,
        createdAt: DateTime.now(),
      );

      await _productService.updateProduct(updatedProduct);

      // Reload products
      await loadProducts();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete product (Admin only)
  Future<bool> deleteProduct(String productId, String? imageUrl) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Delete image from storage
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await _storageService.deleteProductImage(imageUrl);
      }

      // Delete from Firestore
      await _productService.deleteProduct(productId);

      // Remove from local list
      _products.removeWhere((p) => p.id == productId);
      _applyFilters();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get unique categories
  List<String> getCategories() {
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
