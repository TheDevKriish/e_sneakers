import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}
class _ProductScreenState extends State<ProductScreen> {
  int selectedSize = 8;
  int selectedColor = 0;
  final List<int> sizes = [7, 7.5.toInt(), 8, 8.5.toInt(), 9, 9.5.toInt(), 10, 10.5.toInt()];
  final List<Color> colors = [Colors.black, Colors.grey, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)
            ),
            child: Center(child: Image.asset("assets/sample_sneaker.png", height: 120)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text("Air Max 270", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
              ),
              const Text("\$159", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
              const SizedBox(width: 14),
              Text("\$189", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 5),
          const Text("Nike", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
          Row(
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 20),
              Text(" 4.2 (128 reviews)", style: TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 15),
          const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10, runSpacing: 8,
            children: sizes.map((sz) => ChoiceChip(
              label: Text(sz.toString()),
              selected: selectedSize == sz,
              onSelected: (_) => setState(() => selectedSize = sz),
            )).toList(),
          ),
          const SizedBox(height: 15),
          const Text("Color", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: List.generate(colors.length, (i) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => selectedColor = i),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: colors[i],
                  child: selectedColor == i ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ),
            )),
          ),
          const SizedBox(height: 18),
          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
              "The Nike Air Max 270 delivers visible comfort and modern style. The design draws inspiration from the original Air Max 180 and 93, featuring Nike’s largest heel Air unit yet for a super-soft ride.",
              style: TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))
              ),
              child: const Text("Add to Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
