import 'package:flutter/material.dart';
import '../main.dart';
import 'login_view.dart';
import 'register_user_view.dart';

// ─── Onboarding Data Model ────────────────────────────────────────────────────

class _OnboardingData {
  final String title;
  final String subtitle;
  final Widget illustration;
  final Color bgColor;
  final Color accentColor;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.bgColor,
    required this.accentColor,
  });
}

// ─── Onboarding Page ──────────────────────────────────────────────────────────

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _contentController;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: "Let's get\nyou sorted!",
      subtitle:
          "Temukan berbagai macam charm, manik-manik, dan perlengkapan DIY favoritmu di satu tempat.",
      illustration: _OnboardingIllustration1(),
      bgColor: Colors.white,
      accentColor: JoyCharmColors.primary,
    ),
    _OnboardingData(
      title: "Ready to\ntake breaks?",
      subtitle:
          "Ikuti tutorial seru dan selesaikan craft journey untuk mendapatkan koin eksklusif Joy Charm!",
      illustration: _OnboardingIllustration2(),
      bgColor: const Color(0xFFF0FBFB),
      accentColor: JoyCharmColors.secondary,
    ),
    _OnboardingData(
      title: "Craft &\nCreate!",
      subtitle:
          "Tukarkan koin hasil craft journey kamu untuk diskon belanja di Joy Charm. Seru banget, kan?",
      illustration: _OnboardingIllustration3(),
      bgColor: const Color(0xFFFFF0F7),
      accentColor: JoyCharmColors.primary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _contentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _contentController.reset();
    _contentController.forward();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RegisterPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _pages[_currentPage];
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(color: currentData.bgColor),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button at top right
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo small
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: JoyCharmColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'J',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'JOY ',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: JoyCharmColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: 'CHARM',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: JoyCharmColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!isLastPage)
                      TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _pages.length - 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Lewati',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: JoyCharmColors.textMedium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Page view (illustration area)
              Expanded(
                flex: 5,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index].illustration;
                  },
                ),
              ),

              // Bottom content card
              _buildBottomCard(currentData, isLastPage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard(_OnboardingData data, bool isLastPage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _contentController,
        builder: (_, __) => Opacity(
          opacity: _contentOpacity.value,
          child: SlideTransition(
            position: _contentSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Page indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      width: index == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? JoyCharmColors.primary
                            : JoyCharmColors.primaryLight.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: JoyCharmColors.textDark,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: JoyCharmColors.textMedium,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                // Buttons
                if (isLastPage) ...[
                  // Login + Sign in buttons (last page)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: JoyCharmColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _navigateToRegister,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: JoyCharmColors.primary,
                        side: const BorderSide(
                          color: JoyCharmColors.primary,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Onboarding Illustrations ─────────────────────────────────────────────────

/// Page 1 - Shopping/marketplace illustration
class _OnboardingIllustration1 extends StatefulWidget {
  @override
  State<_OnboardingIllustration1> createState() =>
      _OnboardingIllustration1State();
}

class _OnboardingIllustration1State extends State<_OnboardingIllustration1>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _Illustration1Painter(),
          ),
        ),
      ),
    );
  }
}

class _Illustration1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Big phone mockup
    final phonePaint = Paint()..color = const Color(0xFFF8F8F8);
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.48),
        width: w * 0.62,
        height: h * 0.72,
      ),
      const Radius.circular(24),
    );
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawRRect(
      phoneRect.shift(const Offset(0, 8)),
      shadowPaint,
    );
    canvas.drawRRect(phoneRect, phonePaint);

    // Phone border
    final borderPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(phoneRect, borderPaint);

    // Pink top header bar on phone
    final headerPaint = Paint()..color = const Color(0xFFEF5DA8);
    final headerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.19,
        h * 0.12,
        w * 0.62,
        h * 0.12,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(headerRect, headerPaint);

    // Grid of product cards
    final cardPaint = Paint()..color = const Color(0xFFFFF0F7);
    final pinkAccent = Paint()..color = const Color(0xFFFFD6EC);

    final cardPositions = [
      [0.21, 0.26, 0.27, 0.22],
      [0.52, 0.26, 0.27, 0.22],
      [0.21, 0.51, 0.27, 0.22],
      [0.52, 0.51, 0.27, 0.22],
    ];

    for (final pos in cardPositions) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * pos[0], h * pos[1], w * pos[2], h * pos[3]),
        const Radius.circular(10),
      );
      canvas.drawRRect(rect, cardPaint);

      // Price tag
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * pos[0] + 4, h * (pos[1] + pos[3]) - h * 0.04,
              w * 0.14, h * 0.03),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFEF5DA8),
      );

      // Image placeholder circle
      canvas.drawCircle(
        Offset(w * (pos[0] + pos[2] / 2), h * (pos[1] + pos[3] * 0.38)),
        w * 0.07,
        pinkAccent,
      );
    }

    // Decorative beads
    final beadColors = [
      const Color(0xFFFFD166),
      const Color(0xFF4DBFBF),
      const Color(0xFFEF5DA8),
      const Color(0xFFFF9ECF),
    ];

    final beadPositions = [
      [0.08, 0.15, 12.0],
      [0.88, 0.2, 10.0],
      [0.12, 0.7, 8.0],
      [0.86, 0.65, 14.0],
      [0.05, 0.45, 10.0],
      [0.93, 0.42, 8.0],
    ];

    for (int i = 0; i < beadPositions.length; i++) {
      canvas.drawCircle(
        Offset(w * beadPositions[i][0], h * beadPositions[i][1]),
        beadPositions[i][2],
        Paint()..color = beadColors[i % beadColors.length],
      );
      // Shine
      canvas.drawCircle(
        Offset(
          w * beadPositions[i][0] - beadPositions[i][2] * 0.25,
          h * beadPositions[i][1] - beadPositions[i][2] * 0.3,
        ),
        beadPositions[i][2] * 0.28,
        Paint()..color = Colors.white.withOpacity(0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Page 2 - Craft journey / tutorial illustration
class _OnboardingIllustration2 extends StatefulWidget {
  @override
  State<_OnboardingIllustration2> createState() =>
      _OnboardingIllustration2State();
}

class _OnboardingIllustration2State extends State<_OnboardingIllustration2>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _floatController;
  late Animation<double> _spinAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _spinAnim = Tween<double>(begin: 0, end: 1).animate(_spinController);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_spinAnim, _floatAnim]),
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _Illustration2Painter(spin: _spinAnim.value),
          ),
        ),
      ),
    );
  }
}

class _Illustration2Painter extends CustomPainter {
  final double spin;
  const _Illustration2Painter({required this.spin});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Central craft star/badge
    final center = Offset(w * 0.5, h * 0.45);
    final radius = w * 0.3;

    // Outer glow
    canvas.drawCircle(
      center,
      radius + 12,
      Paint()
        ..color = const Color(0xFF4DBFBF).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Teal circle
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF4DBFBF));

    // Inner white circle
    canvas.drawCircle(center, radius * 0.72, Paint()..color = Colors.white);

    // Star shape (rotating)
    final starPaint = Paint()
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(spin * 2 * 3.14159);
    _drawStar(canvas, Offset.zero, radius * 0.5, starPaint);
    canvas.restore();

    // Coin icon in center
    canvas.drawCircle(center, radius * 0.28,
        Paint()..color = const Color(0xFFFFD166));
    // Coin shine
    canvas.drawCircle(
      center.translate(-radius * 0.07, -radius * 0.07),
      radius * 0.1,
      Paint()..color = Colors.white.withOpacity(0.5),
    );

    // Step bubbles around
    final stepColors = [
      const Color(0xFFEF5DA8),
      const Color(0xFF4DBFBF),
      const Color(0xFFFFD166),
    ];
    final stepPositions = [
      Offset(w * 0.12, h * 0.25),
      Offset(w * 0.82, h * 0.28),
      Offset(w * 0.5, h * 0.8),
    ];

    for (int i = 0; i < 3; i++) {
      final pos = stepPositions[i];
      canvas.drawCircle(
          pos,
          26,
          Paint()
            ..color = stepColors[i]
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(pos, 24, Paint()..color = stepColors[i]);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos.translate(-textPainter.width / 2, -textPainter.height / 2),
      );

      // Dotted line from step to center (simplified)
      final linePaint = Paint()
        ..color = stepColors[i].withOpacity(0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(pos, center, linePaint);
    }

    // Decorative sparkles
    _drawSparkle(canvas, Offset(w * 0.08, h * 0.55), 8, const Color(0xFFEF5DA8));
    _drawSparkle(canvas, Offset(w * 0.9, h * 0.5), 10, const Color(0xFFFFD166));
    _drawSparkle(canvas, Offset(w * 0.2, h * 0.75), 7, const Color(0xFF4DBFBF));
    _drawSparkle(canvas, Offset(w * 0.8, h * 0.7), 9, const Color(0xFFEF5DA8));
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 5;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159 / points) - 3.14159 / 2;
      final r = i.isEven ? radius : radius * 0.45;
      final x = center.dx + r * _cos(angle);
      final y = center.dy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    canvas.drawLine(
      center.translate(-size, 0),
      center.translate(size, 0),
      paint..strokeWidth = 2,
    );
    canvas.drawLine(
      center.translate(0, -size),
      center.translate(0, size),
      paint..strokeWidth = 2,
    );
    canvas.drawLine(
      center.translate(-size * 0.6, -size * 0.6),
      center.translate(size * 0.6, size * 0.6),
      paint..strokeWidth = 1.5,
    );
    canvas.drawLine(
      center.translate(size * 0.6, -size * 0.6),
      center.translate(-size * 0.6, size * 0.6),
      paint..strokeWidth = 1.5,
    );
  }

  double _cos(double angle) => _sinCos(angle, true);
  double _sin(double angle) => _sinCos(angle, false);

  double _sinCos(double angle, bool isCos) {
    // Simple cos/sin approximation using dart:math would be ideal
    // but we approximate for the painter
    const tau = 6.283185307;
    angle = angle % tau;
    if (angle < 0) angle += tau;
    // Use Taylor series approximation
    if (isCos) {
      final x = angle - 3.14159265;
      return -(1 - x * x / 2 + x * x * x * x / 24);
    } else {
      return angle < 3.14159265
          ? _sinApprox(angle)
          : -_sinApprox(angle - 3.14159265);
    }
  }

  double _sinApprox(double x) {
    return x - x * x * x / 6 + x * x * x * x * x / 120;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Page 3 - Coins/rewards illustration
class _OnboardingIllustration3 extends StatefulWidget {
  @override
  State<_OnboardingIllustration3> createState() =>
      _OnboardingIllustration3State();
}

class _OnboardingIllustration3State extends State<_OnboardingIllustration3>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _Illustration3Painter(),
          ),
        ),
      ),
    );
  }
}

class _Illustration3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gift box
    final boxPaint = Paint()..color = const Color(0xFFEF5DA8);
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.52),
        width: w * 0.55,
        height: h * 0.42,
      ),
      const Radius.circular(16),
    );
    // Shadow
    canvas.drawRRect(
      boxRect.shift(const Offset(0, 6)),
      Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawRRect(boxRect, boxPaint);

    // Lid
    final lidPaint = Paint()..color = const Color(0xFFD44E94);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.32),
          width: w * 0.58,
          height: h * 0.09,
        ),
        const Radius.circular(10),
      ),
      lidPaint,
    );

    // Ribbon vertical
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.52),
        width: w * 0.065,
        height: h * 0.42,
      ),
      Paint()..color = const Color(0xFFFFD166),
    );
    // Ribbon horizontal
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.32),
        width: w * 0.58,
        height: h * 0.05,
      ),
      Paint()..color = const Color(0xFFFFD166),
    );

    // Bow
    final bowPaint = Paint()..color = const Color(0xFFFFD166);
    // Left bow loop
    final leftBow = Path();
    leftBow.moveTo(w * 0.5, h * 0.26);
    leftBow.quadraticBezierTo(w * 0.32, h * 0.18, w * 0.32, h * 0.26);
    leftBow.quadraticBezierTo(w * 0.38, h * 0.3, w * 0.5, h * 0.3);
    leftBow.close();
    canvas.drawPath(leftBow, bowPaint);

    // Right bow loop
    final rightBow = Path();
    rightBow.moveTo(w * 0.5, h * 0.26);
    rightBow.quadraticBezierTo(w * 0.68, h * 0.18, w * 0.68, h * 0.26);
    rightBow.quadraticBezierTo(w * 0.62, h * 0.3, w * 0.5, h * 0.3);
    rightBow.close();
    canvas.drawPath(rightBow, bowPaint);

    // Coins floating around
    final coinPositions = [
      [0.12, 0.18, 22.0],
      [0.82, 0.15, 18.0],
      [0.08, 0.62, 16.0],
      [0.88, 0.58, 20.0],
      [0.2, 0.82, 14.0],
      [0.78, 0.78, 16.0],
    ];

    for (final pos in coinPositions) {
      final center = Offset(w * pos[0], h * pos[1]);
      final r = pos[2];

      // Coin shadow
      canvas.drawCircle(
        center.translate(2, 3),
        r,
        Paint()
          ..color = Colors.black.withOpacity(0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      // Coin body
      canvas.drawCircle(center, r, Paint()..color = const Color(0xFFFFD166));
      // Coin inner circle
      canvas.drawCircle(center, r * 0.72,
          Paint()..color = const Color(0xFFF5C518));
      // Coin shine
      canvas.drawCircle(
        center.translate(-r * 0.25, -r * 0.3),
        r * 0.22,
        Paint()..color = Colors.white.withOpacity(0.55),
      );

      // Star on coin
      final starPaint = Paint()..color = const Color(0xFFE8A000);
      // Simple star as text
      final tp = TextPainter(
        text: const TextSpan(
          text: '★',
          style: TextStyle(fontSize: 12, color: Color(0xFFE8A000)),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, center.translate(-tp.width / 2, -tp.height / 2));
    }

    // Percentage badge top right of box
    final badgePaint = Paint()..color = const Color(0xFF4DBFBF);
    canvas.drawCircle(Offset(w * 0.7, h * 0.38), 22, badgePaint);
    final discTp = TextPainter(
      text: const TextSpan(
        text: '%',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    discTp.layout();
    discTp.paint(
      canvas,
      Offset(w * 0.7 - discTp.width / 2, h * 0.38 - discTp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}