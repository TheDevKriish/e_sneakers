// Address book screen
// FILE: lib/screens/checkout/address_book_screen.dart
// PURPOSE: Manage saved addresses

import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';
import '../../config/routes.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  // Mock addresses for demo (replace with Firestore in production)
  final List<Map<String, dynamic>> _addresses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addAddress(),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? EmptyState(
              icon: Icons.location_on_outlined,
              title: 'No Addresses Saved',
              message: 'Add a delivery address to continue',
              actionLabel: 'Add Address',
              onAction: _addAddress,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _buildAddressCard(address, index);
              },
            ),
      floatingActionButton: _addresses.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addAddress,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    address['name'] ?? 'Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address['isDefault'] ?? false)
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
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address['phone'] ?? 'Phone',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address['address'] ?? 'Address',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _selectAddress(address),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Select'),
                ),
                TextButton.icon(
                  onPressed: () => _editAddress(index),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteAddress(index),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addAddress() async {
    final result = await Navigator.pushNamed(context, AppRoutes.addressForm);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _addresses.add(result);
      });
    }
  }

  void _editAddress(int index) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addressForm,
      arguments: _addresses[index],
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _addresses[index] = result;
      });
    }
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeAt(index);
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

  void _selectAddress(Map<String, dynamic> address) {
    Navigator.pop(context, address['address']);
  }
}
