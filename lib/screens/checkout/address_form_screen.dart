// Address form screen
// FILE: lib/screens/checkout/address_form_screen.dart
// PURPOSE: Add/Edit address form

import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  bool _isDefault = false;
  Map<String, dynamic>? _existingAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _existingAddress = args;
      _populateFields();
    }
  }

  void _populateFields() {
    if (_existingAddress != null) {
      _nameController.text = _existingAddress!['name'] ?? '';
      _phoneController.text = _existingAddress!['phone'] ?? '';
      _addressLine1Controller.text = _existingAddress!['addressLine1'] ?? '';
      _addressLine2Controller.text = _existingAddress!['addressLine2'] ?? '';
      _cityController.text = _existingAddress!['city'] ?? '';
      _stateController.text = _existingAddress!['state'] ?? '';
      _zipCodeController.text = _existingAddress!['zipCode'] ?? '';
      _isDefault = _existingAddress!['isDefault'] ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final addressData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'addressLine1': _addressLine1Controller.text.trim(),
      'addressLine2': _addressLine2Controller.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'zipCode': _zipCodeController.text.trim(),
      'isDefault': _isDefault,
      'address': _buildFullAddress(),
    };

    Navigator.pop(context, addressData);
  }

  String _buildFullAddress() {
    final line2 = _addressLine2Controller.text.trim();
    return '${_nameController.text.trim()}\n'
        '${_addressLine1Controller.text.trim()}'
        '${line2.isNotEmpty ? '\n$line2' : ''}\n'
        '${_cityController.text.trim()}, ${_stateController.text.trim()} ${_zipCodeController.text.trim()}\n'
        'Phone: ${_phoneController.text.trim()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_existingAddress == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _addressLine1Controller,
              label: 'Address Line 1',
              prefixIcon: const Icon(Icons.location_on_outlined),
              validator: (value) => Validators.validateRequired(value, 'Address'),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _addressLine2Controller,
              label: 'Address Line 2 (Optional)',
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _cityController,
                    label: 'City',
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    validator: (value) => Validators.validateRequired(value, 'City'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _stateController,
                    label: 'State',
                    validator: (value) => Validators.validateRequired(value, 'State'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _zipCodeController,
              label: 'ZIP Code',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.pin_outlined),
              validator: Validators.validateZipCode,
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              title: const Text('Set as default address'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Save Address',
              onPressed: _saveAddress,
            ),
          ],
        ),
      ),
    );
  }
}
