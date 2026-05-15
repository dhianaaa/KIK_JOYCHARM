import 'package:flutter/material.dart';
import 'package:joycharm/models/product_model.dart';
import 'package:joycharm/services/cart_service.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final cart = CartService();

  bool useVoucher = false;

  int get discount => useVoucher ? 10000 : 0;

  int get finalTotal => cart.total - discount;

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}";
  }

  Map<String, List<ProductModel>> groupByCategory() {
    final Map<String, List<ProductModel>> grouped = {};

    cart.items.forEach((product, qty) {
      final key = product.category ?? 'Lainnya';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(product);
    });

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByCategory();

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),

      body: cart.items.isEmpty
          ? const Center(child: Text("Cart masih kosong 😢"))
          : ListView(
              children: grouped.entries.map((entry) {
                return _buildCategory(entry.key, entry.value);
              }).toList(),
            ),

      bottomSheet: _bottomBar(),
    );
  }

  Widget _buildCategory(String category, List<ProductModel> products) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.store, size: 18),
              const SizedBox(width: 6),
              Text(category,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          ...products.map((p) => _itemCard(p)).toList(),
        ],
      ),
    );
  }

  Widget _itemCard(ProductModel p) {
    final qty = cart.items[p] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.network(p.image ?? '', width: 60, height: 60),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name ?? ''),
                Text(formatRupiah((p.price ?? 0).toInt())),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    cart.decrease(p);
                  });
                },
              ),
              Text(qty.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    cart.increase(p);
                  });
                },
              ),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                cart.remove(p);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_number, color: Colors.orange),
              const SizedBox(width: 6),
              const Text("Voucher 10K"),
              const Spacer(),
              Switch(
                value: useVoucher,
                onChanged: (v) {
                  setState(() {
                    useVoucher = v;
                  });
                },
              ),
            ],
          ),

          const Divider(),

          Row(
            children: [
              Text(
                formatRupiah(finalTotal),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Checkout berhasil!")),
                  );
                },
                child: const Text("Checkout"),
              )
            ],
          )
        ],
      ),
    );
  }
}