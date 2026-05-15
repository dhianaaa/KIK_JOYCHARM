import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

// ─── Entry point: Main scaffold with bottom nav ───────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _navIndicatorController;

  final List<Widget> _screens = const [
    _HomeScreen(),
    _CatalogPlaceholder(),
    _ProfilePlaceholder(),
  ];

  @override
  void initState() {
    super.initState();
    _navIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _navIndicatorController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _navIndicatorController.reset();
    _navIndicatorController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _JCBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _JCBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _JCBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.grid_view_rounded, label: 'Catalog'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = index == currentIndex;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 18 : 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? JoyCharmColors.primaryPastel
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        color: isActive
                            ? JoyCharmColors.primary
                            : JoyCharmColors.textLight,
                        size: 22,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Text(
                          items[index].label,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: JoyCharmColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
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

  // Dummy data
  final String _userName = 'Joy';
  final int _userCoins = 14;
  final int _userVouchers = 3;

  final List<_BannerData> _banners = [
    _BannerData(
      title: 'Promo Spesial\nHari Ini! 🎉',
      subtitle: 'Diskon s/d 50% untuk DIY Kit',
      bgColor: JoyCharmColors.primary,
      accentColor: JoyCharmColors.primaryLight,
      tag: 'XTRA PROMO',
    ),
    _BannerData(
      title: 'Craft Journey\nBaru Hadir! ✨',
      subtitle: 'Selesaikan & dapatkan 100 koin',
      bgColor: JoyCharmColors.secondary,
      accentColor: JoyCharmColors.secondaryLight,
      tag: 'NEW',
    ),
    _BannerData(
      title: 'Koleksi Manik\nAesthetic! 🌸',
      subtitle: 'Ratusan pilihan warna & ukuran',
      bgColor: const Color(0xFFFF9ECF),
      accentColor: const Color(0xFFFFD6EC),
      tag: 'HOT',
    ),
  ];

  final List<_CategoryData> _categories = [
    _CategoryData(icon: '🪡', label: 'Benang'),
    _CategoryData(icon: '📿', label: 'Manik'),
    _CategoryData(icon: '🧸', label: 'DIY Kit'),
    _CategoryData(icon: '🔑', label: 'Keychain'),
    _CategoryData(icon: '💎', label: 'Gelang'),
    _CategoryData(icon: '✂️', label: 'Alat'),
    _CategoryData(icon: '🎨', label: 'Craft Set'),
    _CategoryData(icon: '🛍️', label: 'Lainnya'),
  ];

  final List<_ProductData> _products = [
    _ProductData(
      name: 'DIY Craft Kit Gelang Manik Manik Aesthetic',
      shop: 'Star+',
      price: 'Rp35.559',
      rating: '4.7',
      points: '+100',
      isPromo: true,
      emoji: '📿',
      color: const Color(0xFFFFF0F7),
    ),
    _ProductData(
      name: 'Benang Rajut 4 ply (25gr) 50 Warna',
      shop: 'Sevine Official',
      price: 'Rp18.700',
      rating: '4.9',
      points: '+50',
      isPromo: false,
      emoji: '🪡',
      color: const Color(0xFFEDFAFA),
    ),
    _ProductData(
      name: 'Gantungan Kunci Karakter Rajut Cute',
      shop: 'Star+',
      price: 'Rp18.450',
      rating: '4.9',
      points: '+75',
      isPromo: true,
      emoji: '🔑',
      color: const Color(0xFFFFF8E7),
    ),
    _ProductData(
      name: 'Gelang Manik Manik Aesthetic Korea',
      shop: 'coolcoloi',
      price: 'Rp11.840',
      rating: '4.9',
      points: '+50',
      isPromo: true,
      emoji: '💎',
      color: const Color(0xFFF0F8FF),
    ),
  ];

  final List<_TutorialData> _tutorials = [
    _TutorialData(
      title: 'How to Make an Aesthetic Acrylic Keychain ✨',
      duration: '12 min',
      level: 'Pemula',
      emoji: '🔑',
      color: JoyCharmColors.primaryPastel,
    ),
    _TutorialData(
      title: 'Create Your Own Cute Bag Charm',
      duration: '18 min',
      level: 'Pemula',
      emoji: '👜',
      color: const Color(0xFFEDFAFA),
    ),
    _TutorialData(
      title: 'How to Make a Jellyfish Phone Charm ✨',
      duration: '25 min',
      level: 'Menengah',
      emoji: '🪼',
      color: const Color(0xFFFFF8E7),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 1.0);

    // Auto-scroll banner
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
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
        // Header
        SliverToBoxAdapter(child: _buildHeader()),

        // Koin & Voucher card
        SliverToBoxAdapter(child: _buildCoinVoucherCard()),

        // Banner carousel
        SliverToBoxAdapter(child: _buildBannerCarousel()),

        // Kategori
        SliverToBoxAdapter(child: _buildSectionHeader('Kategori', null)),
        SliverToBoxAdapter(child: _buildCategoryGrid()),

        // Craft Journey shortcut
        SliverToBoxAdapter(child: _buildCraftJourneyShortcut()),

        // Rekomendasi produk
        SliverToBoxAdapter(
            child: _buildSectionHeader('Rekomendasi Untukmu', 'Lihat Semua')),
        SliverToBoxAdapter(child: _buildProductGrid()),

        // Tutorial terbaru
        SliverToBoxAdapter(
            child: _buildSectionHeader('Tutorial DIY Terbaru 🎥', 'Semua')),
        SliverToBoxAdapter(child: _buildTutorialList()),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [JoyCharmColors.primary, Color(0xFFFF7FC2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Row 1: Logo + greeting + icons
          Row(
            children: [
              // Logo
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hai, ',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          TextSpan(
                            text: 'Joy! ✨',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Mau craft apa hari ini?',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Cart icon
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: JoyCharmColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Notif icon
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Search bar
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search_rounded,
                      color: JoyCharmColors.textLight, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Cari charm, manik, DIY kit...',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: JoyCharmColors.textLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: JoyCharmColors.primaryPastel,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: JoyCharmColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Koin & Voucher ───────────────────────────────────────────────────────────

  Widget _buildCoinVoucherCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F7), Color(0xFFEDFAFA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: JoyCharmColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Koin
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('⭐', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_userCoins Koin',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: JoyCharmColors.textDark,
                        ),
                      ),
                      const Text(
                        'Koin saya',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: JoyCharmColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 36,
            color: Colors.grey.shade200,
          ),

          const SizedBox(width: 16),

          // Voucher
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: JoyCharmColors.secondary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🎟️', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_userVouchers Voucher',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: JoyCharmColors.textDark,
                        ),
                      ),
                      const Text(
                        'Voucher saya',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: JoyCharmColors.textLight,
                          fontWeight: FontWeight.w500,
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
    );
  }

  // ── Banner Carousel ──────────────────────────────────────────────────────────

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _activeBanner = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final b = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [b.bgColor, b.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: b.bgColor.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: -30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    b.tag,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  b.title,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  b.subtitle,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Lihat Sekarang',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: b.bgColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Illustration placeholder
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('🎀', style: TextStyle(fontSize: 36)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Dots indicator
        const SizedBox(height: 12),
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
                    ? JoyCharmColors.primary
                    : JoyCharmColors.primaryLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, String? action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: JoyCharmColors.textDark,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: () {},
              child: Text(
                action,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: JoyCharmColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Category Grid ────────────────────────────────────────────────────────────

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: JoyCharmColors.primaryPastel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: JoyCharmColors.primaryLight.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cat.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: JoyCharmColors.textDark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Craft Journey Shortcut ───────────────────────────────────────────────────

  Widget _buildCraftJourneyShortcut() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [JoyCharmColors.secondary, Color(0xFF3AAEAE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: JoyCharmColors.secondary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Left content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'CRAFT JOURNEY 🎨',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lanjutkan\nJourney-mu!',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Progress bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cincin Manik Manik • 36%',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.36,
                              backgroundColor: Colors.white.withOpacity(0.25),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Lanjutkan →',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: JoyCharmColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: coin badge + emoji
                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child:
                            Text('🎨', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD166),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('⭐',
                              style: TextStyle(fontSize: 10)),
                          SizedBox(width: 2),
                          Text(
                            '+100 Koin',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7A5800),
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
        ),
      ),
    );
  }

  // ── Product Grid ─────────────────────────────────────────────────────────────

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final p = _products[index];
          return _buildProductCard(p);
        },
      ),
    );
  }

  Widget _buildProductCard(_ProductData p) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: p.color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(p.emoji,
                        style: const TextStyle(fontSize: 44)),
                  ),
                  if (p.isPromo)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: JoyCharmColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PROMO',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.shop,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        color: JoyCharmColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: JoyCharmColors.textDark,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      p.price,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: JoyCharmColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFD166), size: 12),
                        const SizedBox(width: 2),
                        Text(
                          p.rating,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 10,
                            color: JoyCharmColors.textMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '⭐ ${p.points}',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B6914),
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

  // ── Tutorial List ────────────────────────────────────────────────────────────

  Widget _buildTutorialList() {
    return SizedBox(
      height: 148,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tutorials.length,
        itemBuilder: (context, index) {
          final t = _tutorials[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 230,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: t.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Emoji thumbnail
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(t.emoji,
                            style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: JoyCharmColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              t.level,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: JoyCharmColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t.title,
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
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.play_circle_outline_rounded,
                                  size: 14,
                                  color: JoyCharmColors.primary),
                              const SizedBox(width: 3),
                              Text(
                                t.duration,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  color: JoyCharmColors.textMedium,
                                  fontWeight: FontWeight.w600,
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
            ),
          );
        },
      ),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _BannerData {
  final String title, subtitle, tag;
  final Color bgColor, accentColor;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.bgColor,
    required this.accentColor,
  });
}

class _CategoryData {
  final String icon, label;
  const _CategoryData({required this.icon, required this.label});
}

class _ProductData {
  final String name, shop, price, rating, points, emoji;
  final bool isPromo;
  final Color color;
  const _ProductData({
    required this.name,
    required this.shop,
    required this.price,
    required this.rating,
    required this.points,
    required this.isPromo,
    required this.emoji,
    required this.color,
  });
}

class _TutorialData {
  final String title, duration, level, emoji;
  final Color color;
  const _TutorialData({
    required this.title,
    required this.duration,
    required this.level,
    required this.emoji,
    required this.color,
  });
}

// ─── Placeholder screens untuk tab lain ──────────────────────────────────────

class _CatalogPlaceholder extends StatelessWidget {
  const _CatalogPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          '🛍️\nCatalog',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textMedium,
          ),
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          '👤\nProfile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textMedium,
          ),
        ),
      ),
    );
  }
}