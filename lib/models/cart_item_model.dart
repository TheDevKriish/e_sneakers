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
  final int size;
  final int quantity;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  // Create CartItem from Firestore document
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      cartItemId: doc.id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      size: data['size'] ?? 0,
      quantity: data['quantity'] ?? 1,
    );
  }

  // Create CartItem from Map
  factory CartItem.fromMap(Map<String, dynamic> data, String id) {
    return CartItem(
      cartItemId: id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      size: data['size'] ?? 0,
      quantity: data['quantity'] ?? 1,
    );
  }

  // Convert CartItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'brand': brand,
      'price': price,
      'imageUrl': imageUrl,
      'size': size,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  // Create a copy with modified fields
  CartItem copyWith({
    String? cartItemId,
    String? productId,
    String? name,
    String? brand,
    double? price,
    String? imageUrl,
    int? size,
    int? quantity,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}
