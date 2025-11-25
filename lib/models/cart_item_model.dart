// Cart item data model
// FILE: lib/models/cart_item_model.dart
// PURPOSE: Cart item data model

import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String cartItemId;
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.addedAt,
  });

  double get subtotal => price * quantity;

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      cartItemId: doc.id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['image'] ?? '',
      quantity: data['quantity'] ?? 1,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String cartItemId) {
    return CartItem(
      cartItemId: cartItemId,
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['image'] ?? '',
      quantity: map['quantity'] ?? 1,
      addedAt: (map['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'brand': brand,
      'price': price,
      'image': imageUrl,
      'quantity': quantity,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
