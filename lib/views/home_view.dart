import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widgets/navbar.dart';
import 'profile_view.dart';
import '../services/app_config.dart' as url;

// ─── Entry point ──────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeScreen(),
    _CatalogPlaceholder(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: JCBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// ─── Home Screen ──────────────────────────────────────────────────────────────

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  int _activeBanner = 0;
  late PageController _bannerController;

  final String _userName = 'Joy';

  // ── State produk dari API ─────────────────────────────────────────────────
  List<_ProductData> _newProducts = [];
  List<_ProductData> _recommendProducts = [];
  bool _isLoadingProduk = true;
  String? _errorProduk;

  final List<_BannerData> _banners = [
    _BannerData(
      title: 'Create Your\nOwn Joy',
      subtitle: 'Diskon s/d 50% untuk DIY Kit',
      bgGradient: [Color(0xFFFFB6D9), Color(0xFFFFD6A5)],
      tag: 'XTRA PROMO',
      emoji: '🎀',
    ),
    _BannerData(
      title: 'Craft Journey\nBaru Hadir! ✨',
      subtitle: 'Selesaikan & dapatkan 100 koin',
      bgGradient: [Color(0xFF4DBFBF), Color(0xFF80DADA)],
      tag: 'NEW',
      emoji: '🎨',
    ),
    _BannerData(
      title: 'Koleksi Manik\nAesthetic! 🌸',
      subtitle: 'Ratusan pilihan warna & ukuran',
      bgGradient: [Color(0xFFEF5DA8), Color(0xFFFF9ECF)],
      tag: 'HOT',
      emoji: '📿',
    ),
  ];

  final List<_ShortcutData> _shortcuts = [
    _ShortcutData(emoji: '🛍️', label: 'Catalog',       color: Color(0xFFFFF0F7), borderColor: Color(0xFFFFD6EC)),
    _ShortcutData(emoji: '🎨', label: 'Craft Journey', color: Color(0xFFEDFAFA), borderColor: Color(0xFFB2EBEB)),
    _ShortcutData(emoji: '🎥', label: 'Tutorial',      color: Color(0xFFFFF8E7), borderColor: Color(0xFFFFE0A0)),
  ];

  final List<_TutorialData> _tutorials = [
    _TutorialData(
      title: 'How to make a Lip Holder Keychain / Bag Charm Parfum Holder Keychain by yofuldemoda',
      duration: '12 min',
      level: 'Pemula',
      emoji: '🔑',
      color: Color(0xFFFFF0F7),
    ),
    _TutorialData(
      title: 'Ingin membuat something aesthetic? Ikuti langkah-langkah...',
      duration: '18 min',
      level: 'Pemula',
      emoji: '✨',
      color: Color(0xFFEDFAFA),
    ),
  ];

  // Warna background produk bergantian
  final List<Color> _productColors = [
    Color(0xFFFFF0F7),
    Color(0xFFEDFAFA),
    Color(0xFFFFF8E7),
    Color(0xFFF0F8FF),
    Color(0xFFF5F0FF),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 1.0);
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
    _fetchBarang(); // ← ambil data produk dari API
  }

  // ── Fetch dari API ────────────────────────────────────────────────────────

  Future<void> _fetchBarang() async {
    try {
      // Ganti dengan IP sesuai device:
      // - Emulator Android : http://10.0.2.2:3001
      // - Device fisik     : http://192.168.x.x:3001
      // - iOS Simulator    : http://localhost:3001
      final uri = Uri.parse('${url.BaseUrl}/Get Barang');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body);

        final allProducts = decoded.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return _ProductData(
            name: item['name'] ?? '',
            price: _formatRupiah(item['price']),
            rating: (item['rating'] ?? 0).toString(),
            imageUrl: item['image'] ?? '',
            isPromo: false,
            color: _productColors[i % _productColors.length],
          );
        }).toList();

        if (mounted) {
          setState(() {
            // "New" = category == 'New', sisanya "Rekomendasi"
            _newProducts = decoded.asMap().entries
                .where((e) => e.value['category'] == 'New')
                .map((e) => _ProductData(
                      name: e.value['name'] ?? '',
                      price: _formatRupiah(e.value['price']),
                      rating: (e.value['rating'] ?? 0).toString(),
                      imageUrl: e.value['image'] ?? '',
                      isPromo: false,
                      color: _productColors[e.key % _productColors.length],
                    ))
                .toList();

            _recommendProducts = decoded.asMap().entries
                .where((e) => e.value['category'] != 'New')
                .map((e) => _ProductData(
                      name: e.value['name'] ?? '',
                      price: _formatRupiah(e.value['price']),
                      rating: (e.value['rating'] ?? 0).toString(),
                      imageUrl: e.value['image'] ?? '',
                      isPromo: false,
                      color: _productColors[e.key % _productColors.length],
                    ))
                .toList();

            // Kalau semua category == 'New', tampilkan semua di rekomendasi juga
            if (_recommendProducts.isEmpty) _recommendProducts = allProducts;

            _isLoadingProduk = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorProduk = 'Gagal memuat produk (${response.statusCode})';
            _isLoadingProduk = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorProduk = 'Tidak dapat terhubung ke server';
          _isLoadingProduk = false;
        });
      }
    }
  }

  String _formatRupiah(dynamic price) {
    if (price == null) return 'Rp 0';
    final number = int.tryParse(price.toString()) ?? 0;
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  void _autoScrollBanner() {
    if (!mounted) return;
    final next = (_activeBanner + 1) % _banners.length;
    _bannerController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildBannerCarousel()),
        SliverToBoxAdapter(child: _buildShortcuts()),
        SliverToBoxAdapter(child: _buildSectionHeader('New', 'Lihat Semua', color: JoyCharmColors.primary)),
        SliverToBoxAdapter(child: _buildProductSection(_newProducts)),
        SliverToBoxAdapter(child: _buildSectionHeader('Rekomendasi', 'Lihat Semua', color: JoyCharmColors.primary)),
        SliverToBoxAdapter(child: _buildProductSection(_recommendProducts)),
        SliverToBoxAdapter(child: _buildSectionHeader('Tutorial DIY', 'Semua', color: JoyCharmColors.primary)),
        SliverToBoxAdapter(child: _buildTutorialGrid()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20, right: 20, bottom: 18,
      ),
      color: const Color(0xFF4DBFBF),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: const Center(child: Text('😊', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hai, $_userName! ',
                    style: const TextStyle(
                      fontFamily: 'Nunito', fontSize: 16,
                      fontWeight: FontWeight.w900, color: Colors.white,
                    ),
                  ),
                  const TextSpan(text: '✨', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🎟️', style: TextStyle(fontSize: 18))),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner Carousel ───────────────────────────────────────────────────────

  Widget _buildBannerCarousel() {
    return Container(
      color: const Color(0xFF4DBFBF),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (i) => setState(() => _activeBanner = i),
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final b = _banners[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: b.bgGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: b.bgGradient[0].withOpacity(0.3),
                        blurRadius: 16, offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20, top: -20,
                        child: Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30, bottom: -30,
                        child: Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(b.tag,
                                      style: const TextStyle(
                                        fontFamily: 'Nunito', fontSize: 10,
                                        fontWeight: FontWeight.w800, color: Colors.white,
                                        letterSpacing: 0.5,
                                      )),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(b.title,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito', fontSize: 20,
                                      fontWeight: FontWeight.w900, color: Colors.white,
                                      height: 1.2,
                                    )),
                                  const SizedBox(height: 4),
                                  Text(b.subtitle,
                                    style: TextStyle(
                                      fontFamily: 'Nunito', fontSize: 11,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w500,
                                    )),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('Lihat Sekarang',
                                      style: TextStyle(
                                        fontFamily: 'Nunito', fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: b.bgGradient[0],
                                      )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(b.emoji, style: const TextStyle(fontSize: 64)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == _activeBanner ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == _activeBanner
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Shortcuts ─────────────────────────────────────────────────────────────

  Widget _buildShortcuts() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD6EC), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _shortcuts.map((s) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: s.borderColor, width: 1.5),
                  ),
                  child: Center(child: Text(s.emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 8),
                Text(s.label,
                  style: const TextStyle(
                    fontFamily: 'Nunito', fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: JoyCharmColors.textDark,
                  )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, String action, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 18,
              fontWeight: FontWeight.w900, color: color,
            )),
          GestureDetector(
            onTap: () {},
            child: Text(action,
              style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 13,
                fontWeight: FontWeight.w700,
                color: JoyCharmColors.textMedium,
              )),
          ),
        ],
      ),
    );
  }

  // ── Product Section (loading / error / data) ──────────────────────────────

  Widget _buildProductSection(List<_ProductData> products) {
    if (_isLoadingProduk) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(color: JoyCharmColors.primary),
        ),
      );
    }

    if (_errorProduk != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('😢', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(_errorProduk!,
                style: const TextStyle(
                  fontFamily: 'Nunito', fontSize: 13,
                  color: JoyCharmColors.textMedium,
                )),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoadingProduk = true;
                    _errorProduk = null;
                  });
                  _fetchBarang();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: JoyCharmColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Coba Lagi',
                    style: TextStyle(
                      fontFamily: 'Nunito', fontSize: 12,
                      fontWeight: FontWeight.w700, color: Colors.white,
                    )),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text('Belum ada produk 🛍️',
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 13,
              color: JoyCharmColors.textMedium,
            )),
        ),
      );
    }

    return _buildProductRow(products);
  }

  // ── Product Row ───────────────────────────────────────────────────────────

  Widget _buildProductRow(List<_ProductData> products) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10, offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar dari URL atau fallback warna
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Stack(
                      children: [
                        // Tampilkan gambar dari URL
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: p.imageUrl.isNotEmpty
                              ? Image.network(
                                  p.imageUrl,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text('🛍️', style: TextStyle(fontSize: 44)),
                                  ),
                                  loadingBuilder: (_, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: JoyCharmColors.primary,
                                      ),
                                    );
                                  },
                                )
                              : const Center(child: Text('🛍️', style: TextStyle(fontSize: 44))),
                        ),
                        if (p.isPromo)
                          Positioned(
                            top: 8, left: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _promoBadge('PROMO'),
                                const SizedBox(height: 2),
                                _promoBadge('XTRA'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Nunito', fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: JoyCharmColors.textDark, height: 1.3,
                            )),
                          const Spacer(),
                          Row(
                            children: [
                              Text(p.price,
                                style: const TextStyle(
                                  fontFamily: 'Nunito', fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: JoyCharmColors.primary,
                                )),
                              const Spacer(),
                              const Icon(Icons.star_rounded, color: Color(0xFFFFD166), size: 11),
                              Text(' ${p.rating}',
                                style: const TextStyle(
                                  fontFamily: 'Nunito', fontSize: 10,
                                  color: JoyCharmColors.textMedium,
                                )),
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
        },
      ),
    );
  }

  Widget _promoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: JoyCharmColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
        style: const TextStyle(
          fontFamily: 'Nunito', fontSize: 8,
          fontWeight: FontWeight.w900, color: Colors.white,
        )),
    );
  }

  // ── Tutorial Grid ─────────────────────────────────────────────────────────

  Widget _buildTutorialGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _tutorials.length,
        itemBuilder: (context, index) {
          final t = _tutorials[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: t.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8, offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Center(child: Text(t.emoji, style: const TextStyle(fontSize: 40))),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Nunito', fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: JoyCharmColors.textDark, height: 1.3,
                            )),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.play_circle_outline_rounded,
                                  size: 13, color: JoyCharmColors.primary),
                              const SizedBox(width: 3),
                              Text(t.duration,
                                style: const TextStyle(
                                  fontFamily: 'Nunito', fontSize: 10,
                                  color: JoyCharmColors.textMedium,
                                  fontWeight: FontWeight.w600,
                                )),
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
        },
      ),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _BannerData {
  final String title, subtitle, tag, emoji;
  final List<Color> bgGradient;
  const _BannerData({
    required this.title, required this.subtitle,
    required this.tag, required this.emoji,
    required this.bgGradient,
  });
}

class _ShortcutData {
  final String emoji, label;
  final Color color, borderColor;
  const _ShortcutData({
    required this.emoji, required this.label,
    required this.color, required this.borderColor,
  });
}

class _ProductData {
  final String name, price, rating, imageUrl; // ← imageUrl ganti emoji
  final bool isPromo;
  final Color color;
  const _ProductData({
    required this.name, required this.price,
    required this.rating, required this.imageUrl,
    required this.isPromo, required this.color,
  });
}

class _TutorialData {
  final String title, duration, level, emoji;
  final Color color;
  const _TutorialData({
    required this.title, required this.duration,
    required this.level, required this.emoji, required this.color,
  });
}

// ─── Placeholder screens ──────────────────────────────────────────────────────

class _CatalogPlaceholder extends StatelessWidget {
  const _CatalogPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('🛍️\nCatalog',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito', fontSize: 20,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textMedium,
          )),
      ),
    );
  }
}