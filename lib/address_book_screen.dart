import 'package:flutter/material.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});
  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final addresses = <Map<String, String>>[
    {'label': 'Home', 'line': 'Building 12, Main Street, Springfield', 'phone': '+91 98765 43210'},
  ];

  void _add() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final label = TextEditingController();
        final line = TextEditingController();
        final phone = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Add Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Label'), controller: label),
            TextField(decoration: const InputDecoration(labelText: 'Address Line'), controller: line),
            TextField(decoration: const InputDecoration(labelText: 'Phone'), controller: phone),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (label.text.isNotEmpty && line.text.isNotEmpty) {
                  setState(() => addresses.add({'label': label.text, 'line': line.text, 'phone': phone.text}));
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
            const SizedBox(height: 12),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Book')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _add,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final a = addresses[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('${a['label']} • ${a['phone'] ?? ''}'),
              subtitle: Text(a['line'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () => setState(() => addresses.removeAt(i)),
              ),
            ),
          );
        },
      ),
    );
  }
}
