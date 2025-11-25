// Product data model
// FILE: lib/models/product_model.dart
// PURPOSE: Product data model with JSON serialization

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.imageUrl,
    this.rating = 4.0,
    this.reviews = 0,
    required this.description,
    this.stock = 0,
    required this.createdAt,
  });

  // Calculate discount percentage
  double? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return null;
  }

  // Check if product is in stock
  bool get isInStock => stock > 0;

  // Check if product has discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  // Create from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice'] != null 
          ? (data['originalPrice'] as num).toDouble() 
          : null,
      category: data['category'] ?? 'Sneakers',
      imageUrl: data['image'] ?? '',
      rating: (data['rating'] ?? 4.0).toDouble(),
      reviews: data['reviews'] ?? 0,
      description: data['description'] ?? '',
      stock: data['stock'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create from Map
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: map['originalPrice'] != null 
          ? (map['originalPrice'] as num).toDouble() 
          : null,
      category: map['category'] ?? 'Sneakers',
      imageUrl: map['image'] ?? '',
      rating: (map['rating'] ?? 4.0).toDouble(),
      reviews: map['reviews'] ?? 0,
      description: map['description'] ?? '',
      stock: map['stock'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'image': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'stock': stock,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for updates
  Product copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? originalPrice,
    String? category,
    String? imageUrl,
    double? rating,
    int? reviews,
    String? description,
    int? stock,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
