import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class CheckoutView extends StatefulWidget {
  final Map<ProductModel, int> products;

  const CheckoutView({super.key, required this.products});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  bool useVoucher = true;

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";
  }

  int get subtotal {
    int total = 0;

    widget.products.forEach((product, qty) {
      total += ((product.price ?? 0).toInt()) * qty;
    });

    return total;
  }

  int get shipping => 12000;

  int get discount => useVoucher ? 10000 : 0;

  int get total => subtotal + shipping - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          color: Color(0xffF6F6F6),

          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            /// ADDRESS
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.pink),

                      SizedBox(width: 8),

                      Text(
                        "Alamat Pengiriman",

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Bu Amal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Jl. Soekarno Hatta No. 12, Malang, Jawa Timur",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// PRODUCTS
            _sectionCard(
              child: Column(
                children: widget.products.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            product.image ?? '',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                product.name ?? '',

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "x$qty",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                formatRupiah((product.price ?? 0).toInt()),

                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            /// SHIPPING
            _sectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Metode Pengiriman",

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),

                      Text(
                        "Reguler",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Ongkir"),

                      const Spacer(),

                      Text(formatRupiah(shipping)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// PAYMENT
            _sectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.discount, color: Colors.orange),

                      const SizedBox(width: 8),

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

                  _priceRow("Subtotal", formatRupiah(subtotal)),

                  const SizedBox(height: 8),

                  _priceRow("Ongkir", formatRupiah(shipping)),

                  const SizedBox(height: 8),

                  _priceRow("Diskon", "- ${formatRupiah(discount)}"),

                  const Divider(height: 24),

                  _priceRow(
                    "Total Pembayaran",
                    formatRupiah(total),

                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(16),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text("Total", style: TextStyle(color: Colors.grey)),

                    Text(
                      formatRupiah(total),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: () {
                  final order = OrderModel(
                    products: widget.products,
                    total: total,
                    status: "dikemas",
                  );

                  OrderService().addOrder(order);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pesanan berhasil dibuat!")),
                  );
                },

                child: const Text(
                  "Buat Pesanan",

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),
      ),

      child: child,
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Row(
      children: [
        Text(
          title,

          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        const Spacer(),

        Text(
          value,

          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,

            color: isBold ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}