import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'loginscreen.dart';
import 'product_repository.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _searchCtrl = TextEditingController();
  String _category = 'All';
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _shown = [];

  String _s(dynamic v, [String d = '']) {
    if (v == null) return d;
    if (v is String) return v;
    return v.toString();
  }

  int _i(dynamic v, [int d = 0]) {
    if (v == null) return d;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? d;
    return d;
  }

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_apply);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await ProductRepository().loadData();
    setState(() {
      _all = ProductRepository().getProducts();
    });
    _apply();
  }

  void _apply() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _shown = _all.where((p) {
        final inCat = _category == 'All' || _s(p['category']) == _category;
        final inText = q.isEmpty ||
            _s(p['name']).toLowerCase().contains(q) ||
            _s(p['brand']).toLowerCase().contains(q);
        return inCat && inText;
      }).toList();
    });
  }

  Future<void> _onAdd() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (res != null) {
      await ProductRepository().addProduct(res as Map<String, dynamic>);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added')));
    }
  }

  Future<void> _onEdit(Map<String, dynamic> p) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProductScreen(product: p)),
    );
    if (res == true) {
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product updated')));
    }
  }

  Future<void> _onDelete(int id) async {
    // simple delete in memory: load current, remove, save
    final list = ProductRepository().getProducts();
    list.removeWhere((e) => _i(e['id'], -1) == id);
    await ProductRepository().saveProducts();
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>{'All'}..addAll(_all.map((e) => _s(e['category'], 'Sneakers')));
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAdd,
        backgroundColor: Colors.black,
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Filters row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search by name or brand',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _category = v);
                      _apply();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Products (${_shown.length})", style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            if (_shown.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No products found', style: TextStyle(color: Colors.black54)),
              )
            else
              ..._shown.map((p) {
                final id = _i(p['id'], 0);
                final name = _s(p['name'], 'Unknown');
                final brand = _s(p['brand'], 'Brand');
                final cat = _s(p['category'], 'Sneakers');
                final price = _i(p['price'], 0);
                final original = p['originalPrice'] != null ? _i(p['originalPrice']) : null;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$brand • $cat'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (original != null && original > price)
                          Text('\$$original', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black54)),
                      ],
                    ),
                    onTap: () => _onEdit(p),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete product?'),
                          content: Text(name),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _onDelete(id);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
