import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/navbar.dart';

// ─── Profile Page (standalone, wraps with navbar if needed) ───────────────────

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: const ProfileScreen(),
      bottomNavigationBar: JCBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// ─── Profile Screen (public so HomePage can use it directly) ──────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeroHeader(context)),
        SliverToBoxAdapter(child: _buildOrderSection()),
        SliverToBoxAdapter(child: _buildWalletSection()),
        SliverToBoxAdapter(child: _buildActivitySection()),
        SliverToBoxAdapter(child: _buildSupportSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // ── Hero Header ──────────────────────────────────────────────────────────

  Widget _buildHeroHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background gradient + wavy bottom
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4DBFBF), Color(0xFFFF6FA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -30, top: -30,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -20, bottom: 20,
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Top bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 20, right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Toko saya  >',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          _iconButton(Icons.checkroom_outlined),
                          const SizedBox(width: 8),
                          _iconButton(Icons.shopping_cart_outlined),
                          const SizedBox(width: 8),
                          _iconButton(Icons.chat_bubble_outline_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Profile card floating
        Positioned(
          top: MediaQuery.of(context).padding.top + 56,
          left: 20, right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6FA8).withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar with ring
                Stack(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4DBFBF), Color(0xFFFF6FA8)],
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6FA8).withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🌸', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DBFBF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bu Amal',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: JoyCharmColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _statChip('5', 'Followers'),
                          const SizedBox(width: 12),
                          _statChip('7', 'Following'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4DBFBF), Color(0xFF38B2B2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Spacer for card
        SizedBox(height: MediaQuery.of(context).padding.top + 56 + 104 + 24),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _statChip(String value, String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$value ',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: JoyCharmColors.primary,
            ),
          ),
          TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: JoyCharmColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ── Order Section ────────────────────────────────────────────────────────

  Widget _buildOrderSection() {
    return _sectionCard(
      title: 'Pesanan saya',
      trailing: const Text(
        'Lihat semua  >',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: JoyCharmColors.primary,
        ),
      ),
      child: Column(
        children: [
          // Order status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _orderStatusItem(Icons.payment_outlined, 'Belum\nbayar', badge: 0),
              _divider(),
              _orderStatusItem(Icons.inventory_2_outlined, 'Dikemas', badge: 0),
              _divider(),
              _orderStatusItem(Icons.local_shipping_outlined, 'Dikirim', badge: 2),
              _divider(),
              _orderStatusItem(Icons.star_outline_rounded, 'Beri nilai', badge: 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderStatusItem(IconData icon, String label, {required int badge}) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FBFB),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFB2EBEB), width: 1.5),
                ),
                child: Icon(icon, color: JoyCharmColors.primary, size: 24),
              ),
              if (badge > 0)
                Positioned(
                  top: -4, right: -4,
                  child: Container(
                    width: 18, height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6FA8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: JoyCharmColors.textDark,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: const Color(0xFFEEEEEE));
  }

  // ── Wallet Section ───────────────────────────────────────────────────────

  Widget _buildWalletSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _walletCard(
              emoji: '🪙',
              label: 'Koin saya',
              value: '120',
              color: const Color(0xFFFFF8E7),
              borderColor: const Color(0xFFFFE0A0),
              valueColor: const Color(0xFFE8A000),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _walletCard(
              emoji: '🎟️',
              label: 'Voucher saya',
              value: '3',
              color: const Color(0xFFFFF0F7),
              borderColor: const Color(0xFFFFD6EC),
              valueColor: JoyCharmColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletCard({
    required String emoji,
    required String label,
    required String value,
    required Color color,
    required Color borderColor,
    required Color valueColor,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: JoyCharmColors.textMedium,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Activity Section ─────────────────────────────────────────────────────

  Widget _buildActivitySection() {
    return _sectionCard(
      title: 'Aktivitas saya',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _activityButton(
                  emoji: '🔁',
                  label: 'Beli lagi',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _activityButton(
                  emoji: '❤️',
                  label: 'Favorit saya',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _activityButton(
            emoji: '👁️',
            label: 'Terakhir dilihat',
            onTap: () {},
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _activityButton({
    required String emoji,
    required String label,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: fullWidth
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: JoyCharmColors.textDark,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: JoyCharmColors.textLight),
          ],
        ),
      ),
    );
  }

  // ── Support Section ──────────────────────────────────────────────────────

  Widget _buildSupportSection() {
    final items = [
      _SupportItem(emoji: '🎧', label: 'Pusat bantuan'),
      _SupportItem(emoji: '💬', label: 'Customer service'),
      _SupportItem(emoji: '⚙️', label: 'Pengaturan akun'),
      _SupportItem(emoji: '🔒', label: 'Privasi & keamanan'),
      _SupportItem(emoji: '🚪', label: 'Keluar', isDestructive: true),
    ];

    return _sectionCard(
      title: 'Lainnya',
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: item.isDestructive
                              ? const Color(0xFFFFF0F0)
                              : const Color(0xFFF0FBFB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(item.emoji,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: item.isDestructive
                                ? const Color(0xFFE53935)
                                : JoyCharmColors.textDark,
                          ),
                        ),
                      ),
                      if (!item.isDestructive)
                        const Icon(Icons.chevron_right_rounded,
                            size: 18, color: JoyCharmColors.textLight),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(height: 1, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Shared Section Card ───────────────────────────────────────────────────

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4, height: 18,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4DBFBF), Color(0xFFFF6FA8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: JoyCharmColors.textDark,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─── Wave Clipper ──────────────────────────────────────────────────────────────

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 40,
      size.width, size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ─── Support Item Data ─────────────────────────────────────────────────────────

class _SupportItem {
  final String emoji, label;
  final bool isDestructive;
  const _SupportItem({
    required this.emoji,
    required this.label,
    this.isDestructive = false,
  });
}