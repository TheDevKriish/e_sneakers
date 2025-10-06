import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});
  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final cards = <Map<String, String>>[
    {'brand': 'Visa', 'last4': '4242', 'name': 'Lucis Caminos'},
  ];

  void _addCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final name = TextEditingController();
        final number = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16, right: 16, top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Name on Card'), controller: name),
              TextField(decoration: const InputDecoration(labelText: 'Card Number'), controller: number, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (name.text.isNotEmpty && number.text.length >= 4) {
                    setState(() {
                      cards.add({'brand': 'Card', 'last4': number.text.substring(number.text.length - 4), 'name': name.text});
                    });
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text('Save'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final c = cards[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.black),
              title: Text('${c['brand']} •••• ${c['last4']}'),
              subtitle: Text(c['name'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () => setState(() => cards.removeAt(i)),
              ),
            ),
          );
        },
      ),
    );
  }
}
