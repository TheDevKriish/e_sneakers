// Cart provider
// FILE: lib/providers/favorites_provider.dart
// PURPOSE: Favorites/Wishlist state management

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../services/firebase_auth_service.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _favorites.isEmpty;
  int get count => _favorites.length;

  // Load favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) {
        _favorites = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .get();

      // Get product IDs
      final productIds = snapshot.docs
          .map((doc) => (doc.data())['productId'] as String)
          .toList();

      // Fetch full product details
      if (productIds.isNotEmpty) {
        final productsSnapshot = await _firestore
            .collection('products')
            .where(FieldPath.documentId, whereIn: productIds)
            .get();

        _favorites = productsSnapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList();
      } else {
        _favorites = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load favorites';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if product is favorite
  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  // Toggle favorite
  Future<void> toggleFavorite(Product product) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      _errorMessage = 'Please login to add favorites';
      notifyListeners();
      return;
    }

    try {
      if (isFavorite(product.id)) {
        // Remove from favorites
        await _removeFavorite(product.id);
        _favorites.removeWhere((p) => p.id == product.id);
      } else {
        // Add to favorites
        await _addFavorite(product);
        _favorites.insert(0, product);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update favorites';
      notifyListeners();
    }
  }

  // Add to favorites
  Future<void> _addFavorite(Product product) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .add({
      'productId': product.id,
      'name': product.name,
      'brand': product.brand,
      'price': product.price,
      'image': product.imageUrl,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove from favorites
  Future<void> _removeFavorite(String productId) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .where('productId', isEqualTo: productId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _favorites.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear favorites';
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
