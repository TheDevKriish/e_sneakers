// Firebase product service
// FILE: lib/services/firebase_product_service.dart
// PURPOSE: Product CRUD operations with Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
// import '../config/constants.dart';

class FirebaseProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Future<List<Product>> getProducts({int? limit}) async {
    try {
      Query query = _firestore.collection('products').orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();

      if (doc.exists) {
        return Product.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  // Search products by name or brand
  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return [];

      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .get();

      final products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

      // Filter locally (Firestore doesn't support complex text search without extensions)
      return products.where((product) {
        final searchLower = query.toLowerCase();
        return product.name.toLowerCase().contains(searchLower) ||
            product.brand.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Add new product (Admin only)
  Future<String> addProduct(Product product) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('products')
          .add(product.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update product (Admin only)
  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product (Admin only)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Get product count
  Future<int> getProductCount() async {
    try {
      AggregateQuerySnapshot snapshot = await _firestore
          .collection('products')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
