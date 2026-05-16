import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joycharm/main.dart'; // JoyCharmColors

// ─── Constants ────────────────────────────────────────────────────────────────
const _baseUrl = 'http://192.168.1.6:3001';

// ─── Model ────────────────────────────────────────────────────────────────────
class ProductModel {
  final int? id;
  final String? name;
  final double? price;
  final String? image;
  final int? stock;
  final double? rating;
  final int? sold;

  const ProductModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.stock,
    this.rating,
    this.sold,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        price: json['price'] != null
            ? double.tryParse(json['price'].toString())
            : null,
        image: json['image'],
        stock: json['stock'],
        rating: json['rating'] != null
            ? double.tryParse(json['rating'].toString())
            : null,
        sold: json['sold'],
      );
}

// ─── Service ──────────────────────────────────────────────────────────────────
class FavoriteService {
  Future<Map<String, dynamic>> getFavoriteProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/GetBarang'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

// karena API kamu langsung LIST
        if (decoded is List) {
          final list = decoded.map((e) => ProductModel.fromJson(e)).toList();

          return {
            'status': true,
            'data': list,
          };
        }

// fallback kalau bukan list
        return {
          'status': false,
          'message': 'Format data tidak sesuai',
          'data': [],
        };
      }

      return {
        'status': false,
        'message': 'Server error ${response.statusCode}',
        'data': [],
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Koneksi gagal: $e',
        'data': [],
      };
    }
  }

  Future<Map<String, dynamic>> removeFavorite(int productId) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/GetBarang/$productId'), headers: {
        'Content-Type': 'application/json'
      }).timeout(const Duration(seconds: 10));

      return response.statusCode == 200
          ? {'status': true}
          : {'status': false, 'message': 'Gagal menghapus favorit'};
    } catch (e) {
      return {'status': false, 'message': 'Koneksi gagal: $e'};
    }
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fetchFavorites();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final result = await FavoriteService().getFavoriteProducts();
    if (!mounted) return;
    setState(() {
      if (result['status'] == true) {
        _products = List<ProductModel>.from(result['data']);
        _animCtrl.forward(from: 0);
      } else {
        _errorMessage = result['message'] ?? 'Gagal memuat favorit';
      }
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(int productId) async {
    final prev = List<ProductModel>.from(_products);
    setState(() => _products.removeWhere((p) => p.id == productId));

    final result = await FavoriteService().removeFavorite(productId);
    if (!mounted) return;
    if (result['status'] != true) {
      setState(() => _products = prev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal hapus favorit'),
          backgroundColor: const Color(0xFFFF6FA8),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: JoyCharmColors.primary,
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(child: _buildErrorWidget())
          else if (_products.isEmpty)
            SliverFillRemaining(child: _buildEmptyWidget())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 22, 14, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _animatedCard(index),
                  childCount: _products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _animatedCard(int index) {
    final delay = (index * 0.07).clamp(0.0, 0.6);
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        final t = Curves.easeOut.transform(
          ((_animCtrl.value - delay) / (1 - delay)).clamp(0.0, 1.0),
        );
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - t)),
            child: child,
          ),
        );
      },
      child: _buildProductCard(_products[index]),
    );
  }

  // ── Header – wave + style sama dengan ProfileScreen ───────────────────────
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient wave – _WaveClipper sama persis dengan ProfileScreen
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4DBFBF), Color(0xFFFF6FA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles – sama seperti ProfileScreen
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: 10,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Top bar – icon button style sama dengan _iconButton di ProfileScreen
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _iconBtn(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Favorit Saya',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              _iconBtn(Icons.search_rounded),
              const SizedBox(width: 8),
              _iconBtn(Icons.tune_rounded),
            ],
          ),
        ),

        // Count chip melayang di atas wave
        Positioned(
          bottom: -14,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6FA8).withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded,
                    color: Color(0xFFFF6FA8), size: 14),
                const SizedBox(width: 6),
                Text(
                  _isLoading
                      ? 'Memuat...'
                      : _products.isEmpty
                          ? 'Belum ada produk'
                          : '${_products.length} produk tersimpan',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: JoyCharmColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Spacer
        SizedBox(height: MediaQuery.of(context).padding.top + 150 + 10),
      ],
    );
  }

  // Sama persis dengan _iconButton di ProfileScreen
  Widget _iconBtn(IconData icon) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      );

  // ── Product Card ──────────────────────────────────────────────────────────
  Widget _buildProductCard(ProductModel product) {
    final bool outOfStock = (product.stock ?? 0) == 0;
    final bool isPopular = (product.sold ?? 0) > 10;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to product detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _productImage(product),

                    if (outOfStock)
                      Container(color: Colors.black.withOpacity(0.38)),
                    if (outOfStock)
                      const Center(
                        child: Text(
                          'Habis',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                    // Badge laris
                    if (isPopular && !outOfStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6FA8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Laris',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Hapus favorit
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeFavorite(product.id!),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFFF6FA8),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name ?? 'Produk',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: JoyCharmColors.textDark,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      'Rp${_formatPrice(product.price ?? 0)}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: JoyCharmColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        if (product.rating != null) ...[
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFD166), size: 11),
                          const SizedBox(width: 2),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: JoyCharmColors.textMedium,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· ${product.sold ?? 0}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: JoyCharmColors.textLight,
                            ),
                          ),
                        ],
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // TODO: add to cart
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: JoyCharmColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 13,
                              color: JoyCharmColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(ProductModel product) {
    if (product.image != null && product.image!.isNotEmpty) {
      return Image.network(
        product.image!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF0FBFB),
            child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: JoyCharmColors.primary),
            ),
          );
        },
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFFFF0F5),
        child: const Center(
          child: Text('📿', style: TextStyle(fontSize: 36)),
        ),
      );

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0F7),
              shape: BoxShape.circle,
            ),
            child:
                const Center(child: Text('❤️', style: TextStyle(fontSize: 46))),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada favorit',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: JoyCharmColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai sukai produk favoritmu',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: JoyCharmColors.textLight),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: JoyCharmColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text('Jelajahi Produk',
                style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Error State ───────────────────────────────────────────────────────────
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0F0),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.error_outline_rounded,
                  color: Color(0xFFE53935), size: 36),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops! Ada masalah',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: JoyCharmColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage ?? 'Gagal memuat data',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: JoyCharmColors.textLight),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchFavorites,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label:
                const Text('Coba Lagi', style: TextStyle(fontFamily: 'Nunito')),
            style: ElevatedButton.styleFrom(
              backgroundColor: JoyCharmColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────
  String _formatPrice(double price) {
    final parts = price.toInt().toString().split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if ((parts.length - i) % 3 == 0 && i != 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }
}

// ─── Wave Clipper – sama persis dengan yang ada di profile_screen.dart ────────
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
