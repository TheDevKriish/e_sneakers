// FILE: lib/providers/cart_provider.dart
// PURPOSE: Shopping cart state management

import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _cartItems.isEmpty;
  
  int get itemCount {
    return _cartItems.fold<int>(0, (previousValue, item) => previousValue + item.quantity);
  }
  
  double get totalAmount {
    return _cartItems.fold<double>(0.0, (previousValue, item) => previousValue + item.subtotal);
  }

  // Load cart from Firestore
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _cartService.getCartItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load cart';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart
  Future<void> addToCart({
    required String productId,
    required String name,
    required String brand,
    required double price,
    required String imageUrl,
    required int size,
  }) async {
    try {
      // Check if product already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) => item.productId == productId && item.size == size,
      );

      if (existingIndex != -1) {
        // Increment quantity
        await incrementQuantity(_cartItems[existingIndex].cartItemId);
      } else {
        // Add new item
        final cartItem = await _cartService.addToCart(
          productId: productId,
          name: name,
          brand: brand,
          price: price,
          imageUrl: imageUrl,
          size: size,
        );
        _cartItems.add(cartItem);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to add to cart';
      notifyListeners();
    }
  }

  // Increment quantity
  Future<void> incrementQuantity(String cartItemId) async {
    try {
      final index = _cartItems.indexWhere((item) => item.cartItemId == cartItemId);
      if (index != -1) {
        final newQuantity = _cartItems[index].quantity + 1;
        await _cartService.updateQuantity(cartItemId, newQuantity);
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update quantity';
      notifyListeners();
    }
  }

  // Decrement quantity
  Future<void> decrementQuantity(String cartItemId) async {
    try {
      final index = _cartItems.indexWhere((item) => item.cartItemId == cartItemId);
      if (index != -1) {
        if (_cartItems[index].quantity > 1) {
          final newQuantity = _cartItems[index].quantity - 1;
          await _cartService.updateQuantity(cartItemId, newQuantity);
          _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
          notifyListeners();
        } else {
          await removeFromCart(cartItemId);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to update quantity';
      notifyListeners();
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      _cartItems.removeWhere((item) => item.cartItemId == cartItemId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove item';
      notifyListeners();
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear cart';
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
