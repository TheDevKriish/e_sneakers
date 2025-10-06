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
    final prefs = await SharedPreferences.getInstance();
    
    // Load products
    final productsData = prefs.getString('products');
    if (productsData != null) {
      _products = List<Map<String, dynamic>>.from(jsonDecode(productsData));
    } else {
      _products = [
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
      await saveProducts();
    }

    // Load cart
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      _cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    }

    // Load favorites
    final favoritesData = prefs.getString('favorites');
    if (favoritesData != null) {
      _favorites = List<Map<String, dynamic>>.from(jsonDecode(favoritesData));
    }
  }

  List<Map<String, dynamic>> getProducts() => List.from(_products);
  List<Map<String, dynamic>> getCart() => List.from(_cart);
  List<Map<String, dynamic>> getFavorites() => List.from(_favorites);

  Future<void> addProduct(Map<String, dynamic> product) async {
    // Ensure all required fields are present
    final completeProduct = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': product['name'] ?? 'Unknown Product',
      'brand': product['brand'] ?? 'Unknown Brand',
      'price': product['price'] ?? 0,
      'originalPrice': product['originalPrice'],
      'category': product['category'] ?? 'General',
      'image': product['image'] ?? 'assets/sample1.png',
      'rating': product['rating'] ?? 4.0,
      'reviews': product['reviews'] ?? 0,
      'description': product['description'] ?? 'No description available.',
    };
    
    _products.add(completeProduct);
    await saveProducts();
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final existingIndex = _cart.indexWhere((item) => item['id'] == product['id']);
    if (existingIndex >= 0) {
      _cart[existingIndex]['quantity'] = (_cart[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      final cartItem = Map<String, dynamic>.from(product);
      cartItem['quantity'] = 1;
      cartItem['size'] = 8;
      cartItem['color'] = 'Black';
      _cart.add(cartItem);
    }
    await saveCart();
  }

  Future<void> removeFromCart(int productId) async {
    _cart.removeWhere((item) => item['id'] == productId);
    await saveCart();
  }

  Future<void> updateCartQuantity(int productId, int quantity) async {
    final index = _cart.indexWhere((item) => item['id'] == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _cart[index]['quantity'] = quantity;
      } else {
        _cart.removeAt(index);
      }
      await saveCart();
    }
  }

  Future<void> addToFavorites(Map<String, dynamic> product) async {
    if (!_favorites.any((item) => item['id'] == product['id'])) {
      _favorites.add(product);
      await saveFavorites();
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    _favorites.removeWhere((item) => item['id'] == productId);
    await saveFavorites();
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item['id'] == productId);
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('products', jsonEncode(_products));
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(_cart));
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_favorites));
  }

  Future<void> clearCart() async {
    _cart.clear();
    await saveCart();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _products.clear();
    _cart.clear();
    _favorites.clear();
  }
}
