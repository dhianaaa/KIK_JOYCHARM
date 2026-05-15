import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../main.dart';
import '../widgets/alert.dart';
import 'login.dart';

const _kPink  = Color(0xFFEF5DA8);
const _kTeal  = Color(0xFF4DBFBF);
const _kWhite = Colors.white;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey       = GlobalKey<FormState>();
  final _usernameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _isLoading       = false;

  final _alert = AlertMessage();

  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 650), vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Register langsung tanpa validasi backend ──────────────────────────────
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulasi loading sebentar
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() => _isLoading = false);

    // Tampilkan pesan sukses lalu ke halaman login
    _alert.showAlert(context, 'Registrasi berhasil! Silakan login.', true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LoginPage(),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  void _handleSocialLogin(String provider) {
    _alert.showAlert(context, 'Login dengan $provider belum tersedia 🚧', false);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: _kPink),
      child: Scaffold(
        backgroundColor: _kPink,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: _kPink,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildLogo(),
                      const SizedBox(height: 40),
                      _buildHeading(),
                      const SizedBox(height: 32),
                      _buildForm(),
                      const SizedBox(height: 28),
                      _buildSocialButtons(),
                      const SizedBox(height: 18),
                      _buildLoginRedirect(),
                      const SizedBox(height: 28),
                      _buildRegisterButton(),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48, height: 28,
          child: CustomPaint(painter: _MascotTopPainter()),
        ),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'J',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 20,
                  fontWeight: FontWeight.w900, color: _kTeal, letterSpacing: 1,
                ),
              ),
              TextSpan(
                text: 'OY',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 20,
                  fontWeight: FontWeight.w900, color: _kWhite, letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const Text('CHARM',
          style: TextStyle(
            fontFamily: 'Nunito', fontSize: 13,
            fontWeight: FontWeight.w900, color: _kWhite,
            letterSpacing: 5, height: 0.9,
          )),
      ],
    );
  }

  Widget _buildHeading() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ready to',
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 34,
              fontWeight: FontWeight.w900, color: _kWhite, height: 1.1,
            )),
          Text('take breaks?',
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 34,
              fontWeight: FontWeight.w900, color: _kWhite, height: 1.1,
            )),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildField(
            controller: _usernameCtrl,
            hint: 'Your Name',
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Username wajib diisi';
              if (v.trim().length < 3) return 'Username minimal 3 karakter';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _emailCtrl,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))
                return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _passwordCtrl,
            hint: 'Password',
            obscureText: _obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white60, size: 20,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password wajib diisi';
              if (v.length < 8) return 'Password minimal 8 karakter';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _confirmCtrl,
            hint: 'Konfirmasi Password',
            obscureText: _obscureConfirm,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              child: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white60, size: 20,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
              if (v != _passwordCtrl.text) return 'Password tidak cocok';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    const fieldColor = Color(0xFFF472B9);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Nunito', fontSize: 15,
        fontWeight: FontWeight.w600, color: _kWhite,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Nunito', fontSize: 15,
          fontWeight: FontWeight.w500, color: Colors.white70,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(padding: const EdgeInsets.only(right: 14), child: suffixIcon)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF9A8D4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kWhite, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFFCDD2), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Nunito', fontSize: 12, color: Color(0xFFFFE0E0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialBtn(child: const _GIcon(), onTap: () => _handleSocialLogin('Google')),
        const SizedBox(width: 20),
        _socialBtn(
          child: const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2), size: 26),
          onTap: () => _handleSocialLogin('Facebook'),
        ),
        const SizedBox(width: 20),
        _socialBtn(
          child: const Icon(Icons.close_rounded, color: Colors.black87, size: 20),
          onTap: () => _handleSocialLogin('Twitter'),
        ),
      ],
    );
  }

  Widget _socialBtn({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return RichText(
      text: TextSpan(
        text: 'Already have an account?  ',
        style: const TextStyle(
          fontFamily: 'Nunito', fontSize: 13, color: Colors.white70,
        ),
        children: [
          TextSpan(
            text: 'Log In',
            style: const TextStyle(
              fontFamily: 'Nunito', fontSize: 13,
              fontWeight: FontWeight.w900, color: _kWhite,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginPage(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ));
              },
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kTeal,
          foregroundColor: _kWhite,
          disabledBackgroundColor: _kTeal.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Text('Sign in',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w900,
                )),
      ),
    );
  }
}

// ─── Mascot painter ───────────────────────────────────────────────────────────

class _MascotTopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawCircle(Offset(w * 0.5, h * 0.9), w * 0.38, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.5, h * 0.9), w * 0.30, Paint()..color = _kPink);
    canvas.drawCircle(Offset(w * 0.36, h * 0.55), w * 0.085, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.64, h * 0.55), w * 0.085, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.37, h * 0.57), w * 0.045, Paint()..color = const Color(0xFF2D2D2D));
    canvas.drawCircle(Offset(w * 0.63, h * 0.57), w * 0.045, Paint()..color = const Color(0xFF2D2D2D));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Google "G" icon ──────────────────────────────────────────────────────────

class _GIcon extends StatelessWidget {
  const _GIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24, height: 24,
      child: CustomPaint(painter: _GPainter()),
    );
  }
}

class _GPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.46;
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];
    final starts = [0.0, 90.0, 180.0, 270.0];
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        starts[i] * 3.14159 / 180,
        90 * 3.14159 / 180,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.14,
      );
    }
    canvas.drawLine(
      Offset(cx, cy), Offset(cx + r, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.width * 0.14
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}