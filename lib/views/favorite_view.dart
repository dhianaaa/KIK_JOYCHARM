import 'package:flutter/material.dart';
import 'package:joycharm/main.dart';
import 'package:joycharm/models/product_model.dart';
import 'package:joycharm/services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<ProductModel> _favoriteProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await FavoriteService().getFavoriteProducts();

    print('Result from API: $result'); // Buat debugging

    if (mounted) {
      setState(() {
        if (result['status'] == true) {
          _favoriteProducts = List<ProductModel>.from(result['data']);
        } else {
          _errorMessage = result['message'] ?? 'Gagal memuat favorit';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(int productId) async {
  final previousProducts = List<ProductModel>.from(_favoriteProducts);

  setState(() {
    _favoriteProducts.removeWhere((p) => p.id == productId);
  });

  final result = await FavoriteService().removeFavorite(productId);

  if (!result['status'] && mounted) {
    setState(() {
      _favoriteProducts = previousProducts;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Gagal hapus favorit')),
    );
  }
}

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
                child: CircularProgressIndicator(color: JoyCharmColors.primary),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(child: _buildErrorWidget())
          else if (_favoriteProducts.isEmpty)
            SliverFillRemaining(child: _buildEmptyWidget())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildProductCard(_favoriteProducts[index]),
                  childCount: _favoriteProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4DBFBF), Color(0xFFFF6FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Favorit Saya',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _favoriteProducts.isEmpty && !_isLoading
                ? 'Belum ada produk favorit'
                : '${_favoriteProducts.length} produk tersimpan',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigasi ke detail produk
        print('Tap product: ${product.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: product.image != null && product.image!.isNotEmpty
                        ? Image.network(
                            product.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: JoyCharmColors.primaryPastel,
                              child: const Center(
                                child: Text('📿', style: TextStyle(fontSize: 40)),
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: JoyCharmColors.primaryPastel,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: JoyCharmColors.primaryPastel,
                            child: const Center(
                              child: Text('📿', style: TextStyle(fontSize: 40)),
                            ),
                          ),
                  ),
                  // Tombol hapus favorit (heart)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeFavorite(product.id!),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
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
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Badge stok habis
                  if ((product.stock ?? 0) == 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Habis',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Produk',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: JoyCharmColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Rp${_formatPrice(product.price ?? 0)}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: JoyCharmColors.primary,
                        ),
                      ),
                      const Spacer(),
                      if (product.rating != null) ...[
                        const Icon(Icons.star_rounded, color: Color(0xFFFFD166), size: 12),
                        const SizedBox(width: 2),
                        Text(
                          product.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: JoyCharmColors.textMedium,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 10, color: JoyCharmColors.textLight),
                      const SizedBox(width: 3),
                      Text(
                        '${product.sold ?? 0} terjual',
                        style: const TextStyle(
                          fontSize: 9,
                          color: JoyCharmColors.textLight,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DBFBF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart_rounded, size: 10, color: Color(0xFF4DBFBF)),
                            SizedBox(width: 2),
                            Text(
                              'Beli',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4DBFBF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FBFB),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('❤️', style: TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 24),
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
              color: JoyCharmColors.textLight,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: JoyCharmColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Jelajahi Produk',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.error_outline_rounded, color: Color(0xFFE53935), size: 36),
            ),
          ),
          const SizedBox(height: 20),
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
                fontSize: 13,
                color: JoyCharmColors.textLight,
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: _fetchFavorites,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: JoyCharmColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

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