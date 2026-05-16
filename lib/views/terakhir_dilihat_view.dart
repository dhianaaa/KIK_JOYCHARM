import 'package:flutter/material.dart';

class TerakhirDilihatView extends StatelessWidget {
  const TerakhirDilihatView({super.key});

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}";
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "name":
            "Gantungan Kunci Manik Lucu Handmade",
        "price": 2179,
        "image":
            "https://picsum.photos/300/400?1",
      },
      {
        "name":
            "Handmade Beads Bracelet Aesthetic",
        "price": 33500,
        "image":
            "https://picsum.photos/300/400?2",
      },
      {
        "name":
            "DIY Charm Keychain Pink Korean",
        "price": 2179,
        "image":
            "https://picsum.photos/300/400?3",
      },
      {
        "name":
            "Cute Pastel Bracelet Set",
        "price": 33500,
        "image":
            "https://picsum.photos/300/400?4",
      },
      {
        "name":
            "Handmade Ribbon Keychain",
        "price": 2179,
        "image":
            "https://picsum.photos/300/400?5",
      },
      {
        "name":
            "Korean Beads Accessories Kit",
        "price": 33500,
        "image":
            "https://picsum.photos/300/400?6",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(
        0xffF3F3F3,
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Colors.white,

        elevation: 0,

        toolbarHeight: 65,

        title: Row(
          children: [
            /// BACK BUTTON
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },

              child: Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: const Color(
                    0xffEF5DA8,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),

                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// TITLE
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: const Color(
                  0xffEF5DA8,
                ),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: const Text(
                "Terakhir dilihat",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            /// ICONS
            const Icon(
              Icons.notifications_none,
              color: Color(0xffEF5DA8),
              size: 23,
            ),

            const SizedBox(width: 12),

            Stack(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xffEF5DA8),
                  size: 22,
                ),

                Positioned(
                  right: 0,
                  top: 0,

                  child: Container(
                    width: 8,
                    height: 8,

                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),

        itemCount: products.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          childAspectRatio: 0.56,

          crossAxisSpacing: 10,

          mainAxisSpacing: 12,
        ),

        itemBuilder: (context, index) {
          final product = products[index];

          return _productCard(product);
        },
      ),
    );
  }

  Widget _productCard(
    Map<String, dynamic> product,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.03,
            ),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// IMAGE
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(14),
            ),

            child: Image.network(
              product["image"],

              width: double.infinity,

              height: 150,

              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                /// SHOP TAG
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange,

                    borderRadius:
                        BorderRadius.circular(
                      3,
                    ),
                  ),

                  child: const Text(
                    "SHOP",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                /// PRODUCT NAME
                Text(
                  product["name"],

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                /// PRICE
                Text(
                  formatRupiah(
                    product["price"],
                  ),

                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                /// STAR
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 13,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      "4.7",

                      style: TextStyle(
                        fontSize: 10,
                        color: Colors
                            .grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}