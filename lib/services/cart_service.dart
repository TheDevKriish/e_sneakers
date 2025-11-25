// FILE: lib/services/cart_service.dart
// PURPOSE: Cart operations with Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import 'firebase_auth_service.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Get cart items for current user
  Future<List<CartItem>> getCartItems() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return snapshot.docs
          .map((doc) => CartItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  // Add item to cart
  Future<CartItem> addToCart({
    required String productId,
    required String name,
    required String brand,
    required double price,
    required String imageUrl,
    required int size,
  }) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('User not logged in');

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .add({
        'productId': productId,
        'name': name,
        'brand': brand,
        'price': price,
        'imageUrl': imageUrl,
        'size': size,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });

      final doc = await docRef.get();
      return CartItem.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Update quantity
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('User not logged in');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': quantity});
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('User not logged in');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('User not logged in');

      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
