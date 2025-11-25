import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProductRepository {
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    try {
      DocumentReference docRef = await _firestore.collection('products').add({
        'name': product['name'] ?? '',
        'brand': product['brand'] ?? '',
        'price': product['price'] ?? 0,
        'originalPrice': product['originalPrice'],
        'category': product['category'] ?? 'Sneakers',
        'image': product['image'] ?? '',
        'rating': product['rating'] ?? 4.0,
        'reviews': product['reviews'] ?? 0,
        'description': product['description'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {'success': true, 'productId': docRef.id};
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('products').doc(productId).update(updates);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<String?> uploadProductImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('products/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return [];
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('cart').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['cartItemId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> product) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return {'success': false, 'message': 'Please login'};
      String productId = product['id'].toString();
      QuerySnapshot existing = await _firestore.collection('users').doc(userId).collection('cart').where('productId', isEqualTo: productId).get();
      if (existing.docs.isNotEmpty) {
        Map<String, dynamic> data = existing.docs.first.data() as Map<String, dynamic>;
        await existing.docs.first.reference.update({'quantity': (data['quantity'] ?? 1) + 1});
      } else {
        await _firestore.collection('users').doc(userId).collection('cart').add({
          'productId': productId,
          'name': product['name'],
          'brand': product['brand'],
          'price': product['price'],
          'image': product['image'] ?? '',
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<void> updateCartQuantity(String cartItemId, int quantity) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;
      if (quantity <= 0) {
        await removeFromCart(cartItemId);
      } else {
        await _firestore.collection('users').doc(userId).collection('cart').doc(cartItemId).update({'quantity': quantity});
      }
    } catch (e) {}
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;
      await _firestore.collection('users').doc(userId).collection('cart').doc(cartItemId).delete();
    } catch (e) {}
  }

  Future<void> clearCart() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('cart').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return [];
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('favorites').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['favoriteId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isFavorite(String productId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return false;
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('favorites').where('productId', isEqualTo: productId).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> addToFavorites(Map<String, dynamic> product) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;
      String productId = product['id'].toString();
      if (await isFavorite(productId)) return;
      await _firestore.collection('users').doc(userId).collection('favorites').add({
        'productId': productId,
        'name': product['name'],
        'brand': product['brand'],
        'price': product['price'],
        'image': product['image'] ?? '',
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {}
  }

  Future<void> removeFromFavorites(String productId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('favorites').where('productId', isEqualTo: productId).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> placeOrder(List<Map<String, dynamic>> cartItems, double totalAmount) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return {'success': false, 'message': 'Please login'};
      DocumentReference orderRef = await _firestore.collection('orders').add({
        'userId': userId,
        'items': cartItems,
        'totalAmount': totalAmount,
        'status': 'pending',
        'orderDate': FieldValue.serverTimestamp(),
      });
      await clearCart();
      return {'success': true, 'orderId': orderRef.id};
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return [];
      QuerySnapshot snapshot = await _firestore.collection('orders').where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({'status': status});
    } catch (e) {}
  }
}
