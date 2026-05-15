import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';
import 'on_boarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _mascotController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _mascotScale;
  late Animation<double> _mascotOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _mascotController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _mascotScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );
    _mascotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _mascotController.forward();

    // Navigate to onboarding after splash
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFF0F7),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JoyCharmColors.primaryPastel.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.1,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JoyCharmColors.secondaryLight.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: 40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JoyCharmColors.primaryLight.withOpacity(0.3),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo area
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _buildLogo(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // App name text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (_, __) => Opacity(
                      opacity: _textOpacity.value,
                      child: SlideTransition(
                        position: _textSlide,
                        child: _buildAppName(),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Mascot bird at bottom
                  AnimatedBuilder(
                    animation: _mascotController,
                    builder: (_, __) => Opacity(
                      opacity: _mascotOpacity.value,
                      child: Transform.scale(
                        scale: _mascotScale.value,
                        child: _buildMascot(),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Loading indicator
                  _buildLoadingDots(),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: JoyCharmColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: JoyCharmColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(60, 60),
          painter: _JoyLogoIconPainter(),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'JOY',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: JoyCharmColors.primary,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                text: ' CHARM',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: JoyCharmColors.secondary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Craft. Create. Charm.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: JoyCharmColors.textMedium,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMascot() {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _BirdMascotPainter(),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return _AnimatedDots();
  }
}

// ─── Animated Loading Dots ────────────────────────────────────────────────────

class _AnimatedDots extends StatefulWidget {
  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: -8).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      for (int i = 0; i < 3; i++) {
        if (!mounted) return;
        _controllers[i].forward().then((_) => _controllers[i].reverse());
        await Future.delayed(const Duration(milliseconds: 150));
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == 1
                    ? JoyCharmColors.primary
                    : JoyCharmColors.primaryLight,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Custom Painters ─────────────────────────────────────────────────────────

class _JoyLogoIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // Draw "J" shape
    final jPath = Path();
    jPath.moveTo(size.width * 0.55, size.height * 0.15);
    jPath.lineTo(size.width * 0.7, size.height * 0.15);
    jPath.lineTo(size.width * 0.7, size.height * 0.72);
    jPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.9,
      size.width * 0.5, size.height * 0.9,
    );
    jPath.quadraticBezierTo(
      size.width * 0.3, size.height * 0.9,
      size.width * 0.3, size.height * 0.72,
    );
    jPath.lineTo(size.width * 0.3, size.height * 0.65);
    jPath.lineTo(size.width * 0.45, size.height * 0.65);
    jPath.lineTo(size.width * 0.45, size.height * 0.72);
    jPath.quadraticBezierTo(
      size.width * 0.45, size.height * 0.78,
      size.width * 0.5, size.height * 0.78,
    );
    jPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.78,
      size.width * 0.55, size.height * 0.72,
    );
    jPath.close();

    canvas.drawPath(jPath, paint);

    // Dot above J
    canvas.drawCircle(
      Offset(size.width * 0.625, size.height * 0.08),
      size.width * 0.08,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BirdMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body (pink rounded shape)
    final bodyPaint = Paint()..color = const Color(0xFFEF5DA8);
    final bodyPath = Path();
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.52),
      width: w * 0.72,
      height: h * 0.75,
    ));
    canvas.drawPath(bodyPath, bodyPaint);

    // Head (slightly lighter pink)
    final headPaint = Paint()..color = const Color(0xFFEF5DA8);
    canvas.drawCircle(Offset(w * 0.5, h * 0.28), w * 0.28, headPaint);

    // White belly
    final bellyPaint = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.58),
        width: w * 0.42,
        height: h * 0.44,
      ),
      bellyPaint,
    );

    // Eyes (white circles)
    final eyeWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.38, h * 0.26), w * 0.1, eyeWhitePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.26), w * 0.1, eyeWhitePaint);

    // Eye pupils (dark)
    final pupilPaint = Paint()..color = const Color(0xFF2D2D2D);
    canvas.drawCircle(Offset(w * 0.39, h * 0.265), w * 0.055, pupilPaint);
    canvas.drawCircle(Offset(w * 0.61, h * 0.265), w * 0.055, pupilPaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.405, h * 0.25), w * 0.022, shinePaint);
    canvas.drawCircle(Offset(w * 0.625, h * 0.25), w * 0.022, shinePaint);

    // Beak (teal/orange triangle)
    final beakPaint = Paint()..color = const Color(0xFF4DBFBF);
    final beakPath = Path();
    beakPath.moveTo(w * 0.5, h * 0.335);
    beakPath.lineTo(w * 0.42, h * 0.29);
    beakPath.lineTo(w * 0.58, h * 0.29);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Wings (darker pink on sides)
    final wingPaint = Paint()..color = const Color(0xFFD44E94);

    // Left wing
    final leftWing = Path();
    leftWing.moveTo(w * 0.14, h * 0.52);
    leftWing.quadraticBezierTo(w * 0.05, h * 0.4, w * 0.18, h * 0.35);
    leftWing.quadraticBezierTo(w * 0.24, h * 0.48, w * 0.22, h * 0.6);
    leftWing.close();
    canvas.drawPath(leftWing, wingPaint);

    // Right wing
    final rightWing = Path();
    rightWing.moveTo(w * 0.86, h * 0.52);
    rightWing.quadraticBezierTo(w * 0.95, h * 0.4, w * 0.82, h * 0.35);
    rightWing.quadraticBezierTo(w * 0.76, h * 0.48, w * 0.78, h * 0.6);
    rightWing.close();
    canvas.drawPath(rightWing, wingPaint);

    // Feet (teal)
    final feetPaint = Paint()
      ..color = const Color(0xFF4DBFBF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left foot
    canvas.drawLine(Offset(w * 0.38, h * 0.88), Offset(w * 0.3, h * 0.95), feetPaint);
    canvas.drawLine(Offset(w * 0.38, h * 0.88), Offset(w * 0.38, h * 0.96), feetPaint);
    canvas.drawLine(Offset(w * 0.38, h * 0.88), Offset(w * 0.46, h * 0.95), feetPaint);

    // Right foot
    canvas.drawLine(Offset(w * 0.62, h * 0.88), Offset(w * 0.54, h * 0.95), feetPaint);
    canvas.drawLine(Offset(w * 0.62, h * 0.88), Offset(w * 0.62, h * 0.96), feetPaint);
    canvas.drawLine(Offset(w * 0.62, h * 0.88), Offset(w * 0.7, h * 0.95), feetPaint);

    // Crown/hair tuft on head
    final tuftPaint = Paint()..color = const Color(0xFFD44E94);
    canvas.drawCircle(Offset(w * 0.5, h * 0.04), w * 0.055, tuftPaint);
    canvas.drawCircle(Offset(w * 0.41, h * 0.065), w * 0.04, tuftPaint);
    canvas.drawCircle(Offset(w * 0.59, h * 0.065), w * 0.04, tuftPaint);

    // Blush cheeks
    final blushPaint = Paint()
      ..color = const Color(0xFFFF9ECF).withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.3, h * 0.31), width: w * 0.12, height: h * 0.07),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.7, h * 0.31), width: w * 0.12, height: h * 0.07),
      blushPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}