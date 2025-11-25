// Payment methods screen
// FILE: lib/screens/profile/payment_methods_screen.dart
// PURPOSE: Manage payment methods (UI only - no real payment integration)

import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Mock payment methods (replace with actual implementation)
  final List<Map<String, dynamic>> _paymentMethods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: _paymentMethods.isEmpty
          ? EmptyState(
              icon: Icons.credit_card_outlined,
              title: 'No Payment Methods',
              message: 'Add a payment method for faster checkout',
              actionLabel: 'Add Payment Method',
              onAction: _showAddPaymentDialog,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return _buildPaymentCard(method, index);
              },
            ),
      floatingActionButton: _paymentMethods.isNotEmpty
          ? FloatingActionButton(
              onPressed: _showAddPaymentDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> method, int index) {
    final type = method['type'] as String;
    IconData icon;
    Color color;

    switch (type) {
      case 'card':
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'upi':
        icon = Icons.phone_android;
        color = Colors.purple;
        break;
      default:
        icon = Icons.payment;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(method['name'] ?? 'Payment Method'),
        subtitle: Text(method['details'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (method['isDefault'] ?? false)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'DEFAULT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => _deletePaymentMethod(index),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                Navigator.pop(context);
                _addPaymentMethod('card', 'Card ending in 1234');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text('UPI'),
              onTap: () {
                Navigator.pop(context);
                _addPaymentMethod('upi', 'user@upi');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addPaymentMethod(String type, String details) {
    setState(() {
      _paymentMethods.add({
        'type': type,
        'name': type == 'card' ? 'Credit Card' : 'UPI',
        'details': details,
        'isDefault': _paymentMethods.isEmpty,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method added'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deletePaymentMethod(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
