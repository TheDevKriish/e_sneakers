import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductRepository {
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cart = [];
  List<Map<String, dynamic>> _favorites = [];

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load products
      final productsData = prefs.getString('products');
      if (productsData != null && productsData.isNotEmpty) {
        final decodedProducts = jsonDecode(productsData);
        _products = List<Map<String, dynamic>>.from(decodedProducts);
      } else {
        _products = _getDefaultProducts();
        await saveProducts();
      }

      // Load cart
      final cartData = prefs.getString('cart');
      if (cartData != null && cartData.isNotEmpty) {
        final decodedCart = jsonDecode(cartData);
        _cart = List<Map<String, dynamic>>.from(decodedCart);
      }

      // Load favorites
      final favoritesData = prefs.getString('favorites');
      if (favoritesData != null && favoritesData.isNotEmpty) {
        final decodedFavorites = jsonDecode(favoritesData);
        _favorites = List<Map<String, dynamic>>.from(decodedFavorites);
      }
    } catch (e) {
      print('Error loading data: $e');
      _products = _getDefaultProducts();
      _cart = [];
      _favorites = [];
    }
  }

  List<Map<String, dynamic>> _getDefaultProducts() {
    return [
      {
        'id': 1,
        'name': 'Air Max 270',
        'brand': 'Nike',
        'price': 159,
        'originalPrice': 189,
        'category': 'Running',
        'image': 'assets/sample1.png',
        'rating': 4.5,
        'reviews': 128,
        'description': 'Premium Nike Air Max with superior comfort and style.',
      },
      {
        'id': 2,
        'name': 'Classic Black',
        'brand': 'Adidas',
        'price': 129,
        'originalPrice': 149,
        'category': 'Casual',
        'image': 'assets/sample2.png',
        'rating': 4.2,
        'reviews': 95,
        'description': 'Classic black sneakers perfect for everyday wear.',
      },
      {
        'id': 3,
        'name': 'Canvas White',
        'brand': 'Converse',
        'price': 89,
        'originalPrice': 110,
        'category': 'Lifestyle',
        'image': 'assets/sample1.png',
        'rating': 4.0,
        'reviews': 67,
        'description': 'Timeless white canvas sneakers with vintage appeal.',
      },
    ];
  }

  List<Map<String, dynamic>> getProducts() => List.from(_products);
  List<Map<String, dynamic>> getCart() => List.from(_cart);
  List<Map<String, dynamic>> getFavorites() => List.from(_favorites);

  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      // Ensure all required fields are present with safe defaults
      final completeProduct = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': product['name']?.toString() ?? 'Unknown Product',
        'brand': product['brand']?.toString() ?? 'Unknown Brand',
        'price': _safeParseInt(product['price'], 0),
        'originalPrice': product['originalPrice'] != null ? _safeParseInt(product['originalPrice'], 0) : null,
        'category': product['category']?.toString() ?? 'General',
        'image': product['image']?.toString() ?? 'assets/sample1.png',
        'rating': _safeParseDouble(product['rating'], 4.0),
        'reviews': _safeParseInt(product['reviews'], 0),
        'description': product['description']?.toString() ?? 'No description available.',
      };
      
      _products.add(completeProduct);
      await saveProducts();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      final productId = _safeParseInt(product['id'], 0);
      final existingIndex = _cart.indexWhere((item) => _safeParseInt(item['id'], -1) == productId);
      
      if (existingIndex >= 0) {
        _cart[existingIndex]['quantity'] = _safeParseInt(_cart[existingIndex]['quantity'], 0) + 1;
      } else {
        final cartItem = Map<String, dynamic>.from(product);
        cartItem['quantity'] = 1;
        cartItem['size'] = 8;
        cartItem['color'] = 'Black';
        _cart.add(cartItem);
      }
      await saveCart();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      _cart.removeWhere((item) => _safeParseInt(item['id'], -1) == productId);
      await saveCart();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> updateCartQuantity(int productId, int quantity) async {
    try {
      final index = _cart.indexWhere((item) => _safeParseInt(item['id'], -1) == productId);
      if (index >= 0) {
        if (quantity > 0) {
          _cart[index]['quantity'] = quantity;
        } else {
          _cart.removeAt(index);
        }
        await saveCart();
      }
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }

  Future<void> addToFavorites(Map<String, dynamic> product) async {
    try {
      final productId = _safeParseInt(product['id'], 0);
      if (!_favorites.any((item) => _safeParseInt(item['id'], -1) == productId)) {
        _favorites.add(product);
        await saveFavorites();
      }
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      _favorites.removeWhere((item) => _safeParseInt(item['id'], -1) == productId);
      await saveFavorites();
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  bool isFavorite(int productId) {
    try {
      return _favorites.any((item) => _safeParseInt(item['id'], -1) == productId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  Future<void> saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('products', jsonEncode(_products));
    } catch (e) {
      print('Error saving products: $e');
    }
  }

  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart', jsonEncode(_cart));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<void> saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorites', jsonEncode(_favorites));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      _cart.clear();
      await saveCart();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _products = _getDefaultProducts();
      _cart = [];
      _favorites = [];
      await saveProducts();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Helper methods for safe parsing
  int _safeParseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double _safeParseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}
