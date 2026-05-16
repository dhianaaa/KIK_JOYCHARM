import 'package:flutter/material.dart';
import 'package:joycharm/views/home_view.dart';
import 'package:joycharm/views/profile_view.dart';
import '../main.dart';
import '../models/product_model.dart';
import '../services/produk.dart';
import '../widgets/navbar.dart';
import 'home_view.dart';
import 'profile_view.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  List<ProductModel> _allProducts = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'The collection', 'Materials'];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final result = await ProdukService().getProducts();

    print("RESULT: $result");

    if (mounted) {
      setState(() {
        _allProducts = result['status'] == true
            ? List<ProductModel>.from(result['data'])
            : [];

        _isLoading = false;
      });
    }
  }

  List<ProductModel> _getFiltered() {
    if (_selectedFilter == 'All') return _allProducts;
    return _allProducts
        .where((p) =>
            (p.category ?? '').toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  Map<String, List<ProductModel>> _groupByCategory(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> grouped = {};
    for (var p in products) {
      final cat = p.category ?? 'Lainnya';
      grouped.putIfAbsent(cat, () => []);
      grouped[cat]!.add(p);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFiltered();
    final grouped = _groupByCategory(filtered);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildFilterTabs()),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: JoyCharmColors.primary),
              ),
            )
          else if (filtered.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Belum ada produk',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: JoyCharmColors.textLight,
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = grouped.keys.elementAt(index);
                  final products = grouped[category]!;
                  return _buildCategorySection(category, products);
                },
                childCount: grouped.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Catalog',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: JoyCharmColors.textDark,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: JoyCharmColors.primaryPastel,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    color: JoyCharmColors.primary, size: 20),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: JoyCharmColors.primaryPastel,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: JoyCharmColors.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search bar
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded,
                    color: JoyCharmColors.textLight, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Cari produk...',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.textLight,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: JoyCharmColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: Colors.white, size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD6EC), Color(0xFFFFF0F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -10,
                    bottom: -20,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: JoyCharmColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Your',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: JoyCharmColors.primary,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'Own Joy ✨',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: JoyCharmColors.primary,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Temukan produk craft favoritmu',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: JoyCharmColors.textMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('🎀', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Filter Tabs ───────────────────────────────────────────────────────────

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isActive = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8, bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? JoyCharmColors.primary
                      : JoyCharmColors.primaryPastel,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : JoyCharmColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Category Section ──────────────────────────────────────────────────────

  Widget _buildCategorySection(String category, List<ProductModel> products) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              category,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: JoyCharmColors.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _buildProductCard(products[index]),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Product Card ──────────────────────────────────────────────────────────

  Widget _buildProductCard(ProductModel p) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: p.image != null
                        ? Image.network(
                            p.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: JoyCharmColors.primaryPastel,
                              child: const Center(
                                child:
                                    Text('📿', style: TextStyle(fontSize: 32)),
                              ),
                            ),
                          )
                        : Container(
                            color: JoyCharmColors.primaryPastel,
                            child: const Center(
                              child: Text('📿', style: TextStyle(fontSize: 32)),
                            ),
                          ),
                  ),
                  if ((p.stock ?? 0) == 0)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'Habis',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: JoyCharmColors.textDark,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Rp${_formatHarga(p.price)}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: JoyCharmColors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFD166), size: 10),
                        const SizedBox(width: 2),
                        Text(
                          p.rating?.toStringAsFixed(1) ?? '0',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 9,
                            color: JoyCharmColors.textMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${p.sold ?? 0} terjual',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 8,
                            color: JoyCharmColors.textLight,
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

  String _formatHarga(double? harga) {
    if (harga == null) return '0';
    final h = harga.toInt();
    final s = h.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if ((s.length - i) % 3 == 0 && i != 0) result.write('.');
      result.write(s[i]);
    }
    return result.toString();
  }
}
