// Order data model
// FILE: lib/models/order_model.dart
// PURPOSE: Order data model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String? address;
  final String? paymentMethod;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    this.address,
    this.paymentMethod,
    required this.orderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final itemsList = (data['items'] as List<dynamic>?)
            ?.map((item) => CartItem.fromMap(item as Map<String, dynamic>, ''))
            .toList() ??
        [];

    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      items: itemsList,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      address: data['address'],
      paymentMethod: data['paymentMethod'],
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'address': address,
      'paymentMethod': paymentMethod,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
