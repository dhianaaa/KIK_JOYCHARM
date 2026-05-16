import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class PesananSayaView extends StatefulWidget {
  const PesananSayaView({super.key});

  @override
  State<PesananSayaView> createState() =>
      _PesananSayaViewState();
}

class _PesananSayaViewState
    extends State<PesananSayaView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    "Semua",
    "Dikemas",
    "Dikirim",
    "Selesai",
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}";
  }

  List<OrderModel> getOrders(
    String status,
  ) {
    final orders = OrderService().orders;

    if (status == "Semua") {
      return orders;
    }

    return orders.where((order) {
      return order.status.toLowerCase() ==
          status.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xffEF5DA8,
      ),

      appBar: AppBar(
        backgroundColor:
            const Color(0xffEF5DA8),

        foregroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Pesanan Saya",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        bottom: TabBar(
          controller: _tabController,

          indicatorColor:
              const Color(0xff7BE0DB),

          labelColor: Colors.white,

          unselectedLabelColor:
              Colors.white70,

          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),

          tabs: tabs.map((e) {
            return Tab(text: e);
          }).toList(),
        ),
      ),

      body: Container(
        width: double.infinity,

        clipBehavior: Clip.antiAlias,

        decoration: const BoxDecoration(
          color: Color(0xffF5F5F5),

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: TabBarView(
          controller: _tabController,

          children: tabs.map((tab) {
            final orders = getOrders(tab);

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada pesanan",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding:
                  const EdgeInsets.all(12),

              itemCount: orders.length,

              itemBuilder: (context, index) {
                final order = orders[index];

                return _orderCard(order);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _orderCard(OrderModel order) {
    final firstProduct =
        order.products.entries.first;

    final ProductModel product =
        firstProduct.key;

    final int qty = firstProduct.value;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          /// HEADER
          Row(
            children: [
              const Icon(
                Icons.store,
                size: 15,
              ),

              const SizedBox(width: 5),

              const Text(
                "Joy Charm Official",

                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const Spacer(),

              Text(
                order.status,

                style: TextStyle(
                  fontSize: 12,
                  color:
                      _statusColor(
                          order.status),

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// PRODUCT
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                        8),

                child: Image.network(
                  product.image ?? '',
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      product.name ?? '',

                      maxLines: 1,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                        height: 4),

                    Text(
                      "$qty barang",

                      style: TextStyle(
                        fontSize: 12,
                        color: Colors
                            .grey
                            .shade600,
                      ),
                    ),

                    const SizedBox(
                        height: 5),

                    Text(
                      formatRupiah(
                        order.total,
                      ),

                      style:
                          const TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// BUTTON
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,

            children: [
              SizedBox(
                height: 32,

                child: OutlinedButton(
                  style:
                      OutlinedButton
                          .styleFrom(
                    side: const BorderSide(
                      color:
                          Color(0xffEF5DA8),
                    ),

                    foregroundColor:
                        const Color(
                      0xffEF5DA8,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Lihat Detail",

                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                height: 32,

                child: ElevatedButton(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                      0xffEF5DA8,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Beli Lagi",

                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "dikemas":
        return Colors.orange;

      case "dikirim":
        return Colors.teal;

      case "selesai":
        return Colors.pink;

      default:
        return Colors.grey;
    }
  }
}