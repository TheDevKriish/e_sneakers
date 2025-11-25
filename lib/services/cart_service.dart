// Cart management service
// FILE: lib/services/cart_service.dart
// PURPOSE: Cart management with Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'firebase_auth_service.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Get user's cart
  Future<List<CartItem>> getCart() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .orderBy('addedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  // Add product to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('Please login to add items to cart');

      final cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart');

      // Check if product already in cart
      QuerySnapshot existing = await cartRef
          .where('productId', isEqualTo: product.id)
          .get();

      if (existing.docs.isNotEmpty) {
        // Update quantity
        final doc = existing.docs.first;
        final currentQty = (doc.data() as Map<String, dynamic>)['quantity'] ?? 1;
        await doc.reference.update({'quantity': currentQty + quantity});
      } else {
        // Add new item
        final cartItem = CartItem(
          cartItemId: '',
          productId: product.id,
          name: product.name,
          brand: product.brand,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: quantity,
          addedAt: DateTime.now(),
        );

        await cartRef.add(cartItem.toMap());
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return;

      if (quantity <= 0) {
        await removeFromCart(cartItemId);
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(cartItemId)
            .update({'quantity': quantity});
      }
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Calculate cart total
  double calculateTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  // Get cart item count
  Future<int> getCartCount() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return 0;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return snapshot.docs.fold<int>(0, (int sum, doc) {
        final data = doc.data();
        final quantity = (data['quantity'] ?? 1) as int;
        return sum + quantity;
      });
    } catch (e) {
      return 0;
    }
  }
}
