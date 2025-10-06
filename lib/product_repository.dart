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
      
      final productsData = prefs.getString('products');
      if (productsData != null && productsData.isNotEmpty) {
        _products = List<Map<String, dynamic>>.from(jsonDecode(productsData));
      } else {
        _products = _getDefaultProducts();
        await saveProducts();
      }

      final cartData = prefs.getString('cart');
      if (cartData != null && cartData.isNotEmpty) {
        _cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
      }

      final favoritesData = prefs.getString('favorites');
      if (favoritesData != null && favoritesData.isNotEmpty) {
        _favorites = List<Map<String, dynamic>>.from(jsonDecode(favoritesData));
      }
    } catch (_) {
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
        'category': 'Sneakers',
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
    final complete = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': product['name']?.toString() ?? 'Unknown Product',
      'brand': product['brand']?.toString() ?? 'Unknown Brand',
      'price': _toInt(product['price'], 0),
      'originalPrice': product['originalPrice'] != null ? _toInt(product['originalPrice'], null) : null,
      'category': product['category']?.toString() ?? 'Sneakers',
      'image': product['image']?.toString() ?? 'assets/sample1.png',
      'rating': _toDouble(product['rating'], 4.0),
      'reviews': _toInt(product['reviews'], 0),
      'description': product['description']?.toString() ?? 'No description available.',
    };
    _products.add(complete);
    await saveProducts();
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final id = _toInt(product['id'], 0);
    final existing = _cart.indexWhere((e) => _toInt(e['id'], -1) == id);
    if (existing >= 0) {
      _cart[existing]['quantity'] = _toInt(_cart[existing]['quantity'], 0) + 1;
    } else {
      final item = Map<String, dynamic>.from(product);
      item['quantity'] = 1;
      item['size'] = 8;
      item['color'] = 'Black';
      _cart.add(item);
    }
    await saveCart();
  }

  Future<void> updateCartQuantity(int productId, int qty) async {
    final i = _cart.indexWhere((e) => _toInt(e['id'], -1) == productId);
    if (i >= 0) {
      if (qty > 0) {
        _cart[i]['quantity'] = qty;
      } else {
        _cart.removeAt(i);
      }
      await saveCart();
    }
  }

  Future<void> clearCart() async {
    _cart.clear();
    await saveCart();
  }

  Future<void> removeFromCart(int productId) async {
    _cart.removeWhere((e) => _toInt(e['id'], -1) == productId);
    await saveCart();
  }

  Future<void> addToFavorites(Map<String, dynamic> product) async {
    final id = _toInt(product['id'], 0);
    if (!_favorites.any((e) => _toInt(e['id'], -1) == id)) {
      _favorites.add(product);
      await saveFavorites();
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    _favorites.removeWhere((e) => _toInt(e['id'], -1) == productId);
    await saveFavorites();
  }

  bool isFavorite(int productId) => _favorites.any((e) => _toInt(e['id'], -1) == productId);

  Future<void> saveProducts() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('products', jsonEncode(_products));
  }

  Future<void> saveCart() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('cart', jsonEncode(_cart));
  }

  Future<void> saveFavorites() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('favorites', jsonEncode(_favorites));
  }

  int _toInt(dynamic v, int? d) {
    if (v == null) return d ?? 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? (d ?? 0);
    return d ?? 0;
  }

  double _toDouble(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }
}
