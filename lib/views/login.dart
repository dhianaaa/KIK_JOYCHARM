import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../main.dart';
import '../widgets/alert.dart';
import 'register.dart';
import '../views/home_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey     = GlobalKey<FormState>();
  final _emailCtrl   = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  final _alert = AlertMessage();

  late AnimationController _fadeController;
  late Animation<double>   _fadeAnim;

  late AnimationController _titleController;
  late Animation<Offset>   _titleSlideAnim;
  late Animation<double>   _titleFadeAnim;

  late AnimationController _formController;
  late Animation<Offset>   _formSlideAnim;
  late Animation<double>   _formFadeAnim;

  static const _teal = Color(0xFF4DBFBF);
  static const _pink = Color(0xFFEF5DA8);
  static const _white = Colors.white;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this,
    );
    _titleSlideAnim = Tween<Offset>(
      begin: const Offset(0, -0.3), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic));
    _titleFadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _titleController, curve: Curves.easeIn));

    _formController = AnimationController(
      duration: const Duration(milliseconds: 700), vsync: this,
    );
    _formSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));
    _formFadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeIn));

    Future.delayed(const Duration(milliseconds: 50), () {
      _fadeController.forward();
      _titleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    _formController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Login langsung tanpa validasi backend ─────────────────────────────────
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulasi loading sebentar
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() => _isLoading = false);

    // Langsung masuk ke HomePage
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  void _handleSocialLogin(String provider) {
    _alert.showAlert(context, 'Login dengan $provider belum tersedia 🚧', false);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: _teal),
      child: Scaffold(
        backgroundColor: _teal,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: _teal,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Stack(
              children: [
                // Dekorasi lingkaran
                Positioned(
                  top: -60, right: -60,
                  child: Container(
                    width: 220, height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  top: 100, left: -80,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200, right: -50,
                  child: Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SlideTransition(
                            position: _formSlideAnim,
                            child: FadeTransition(
                              opacity: _formFadeAnim,
                              child: Column(
                                children: [
                                  const SizedBox(height: 32),
                                  _buildForm(),
                                  const SizedBox(height: 10),
                                  _buildForgotPassword(),
                                  const SizedBox(height: 28),
                                  _buildLoginButton(),
                                  const SizedBox(height: 28),
                                  _buildDivider(),
                                  const SizedBox(height: 20),
                                  _buildSocialButtons(),
                                  const SizedBox(height: 28),
                                  _buildRegisterRedirect(),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _titleSlideAnim,
      child: FadeTransition(
        opacity: _titleFadeAnim,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: _LogoWidget(),
                ),
              ),
              const Text('Hey There,',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 34,
                  fontWeight: FontWeight.w900, color: _white, height: 1.1,
                )),
              const Text("You're Back!",
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 34,
                  fontWeight: FontWeight.w900, color: _white, height: 1.1,
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _emailCtrl,
              hint: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))
                  return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _passwordCtrl,
              hint: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white54, size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    const fieldColor = Color(0xFF5ECFCF);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Nunito', fontSize: 15,
        fontWeight: FontWeight.w600, color: _white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Nunito', fontSize: 15,
          fontWeight: FontWeight.w500, color: Colors.white70,
        ),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7DDDDD), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _white, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFCDD2), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Nunito', fontSize: 12, color: Color(0xFFFFCDD2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => _alert.showAlert(
              context, 'Fitur lupa password segera hadir 🔧', false),
          child: const Text('Lupa password?',
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 13,
              fontWeight: FontWeight.w700, color: _white,
            )),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity, height: 54,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: _pink,
            foregroundColor: _white,
            disabledBackgroundColor: _pink.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : const Text('Log in',
                  style: TextStyle(
                    fontFamily: 'Nunito', fontSize: 16,
                    fontWeight: FontWeight.w900, letterSpacing: 0.3,
                  )),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('atau masuk dengan',
              style: TextStyle(
                fontFamily: 'Nunito', fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              )),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialButton(
            icon: _GoogleIcon(),
            onTap: () => _handleSocialLogin('Google'),
          ),
          const SizedBox(width: 16),
          _socialButton(
            icon: const Icon(Icons.facebook_rounded,
                color: Color(0xFF1877F2), size: 26),
            onTap: () => _handleSocialLogin('Facebook'),
          ),
          const SizedBox(width: 16),
          _socialButton(
            icon: const Icon(Icons.alternate_email_rounded,
                color: Color(0xFF1DA1F2), size: 22),
            onTap: () => _handleSocialLogin('Twitter'),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({required Widget icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          color: _white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildRegisterRedirect() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have account?  ",
          style: TextStyle(
            fontFamily: 'Nunito', fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
          children: [
            TextSpan(
              text: 'Make One',
              style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 14,
                fontWeight: FontWeight.w900, color: _white,
                decoration: TextDecoration.underline,
                decorationColor: _white,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const RegisterPage(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ));
                },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logo Widget ──────────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 32, height: 32,
          child: CustomPaint(painter: _MiniBirdPainter()),
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'J',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 22,
                  fontWeight: FontWeight.w900, color: Color(0xFFEF5DA8),
                ),
              ),
              TextSpan(
                text: 'OY',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 22,
                  fontWeight: FontWeight.w900, color: Colors.white,
                ),
              ),
              TextSpan(
                text: '\nCHARM',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 10,
                  fontWeight: FontWeight.w700, color: Colors.white,
                  letterSpacing: 3, height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('G',
      style: TextStyle(
        fontFamily: 'Nunito', fontSize: 22,
        fontWeight: FontWeight.w900, color: Color(0xFFEA4335),
      ));
  }
}

class _MiniBirdPainter extends CustomPainter {
  const _MiniBirdPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.62), width: w * 0.72, height: h * 0.62),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(Offset(w * 0.5, h * 0.3), w * 0.28, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.38, h * 0.27), w * 0.07, Paint()..color = const Color(0xFF4DBFBF));
    canvas.drawCircle(Offset(w * 0.62, h * 0.27), w * 0.07, Paint()..color = const Color(0xFF4DBFBF));
    canvas.drawCircle(Offset(w * 0.39, h * 0.27), w * 0.035, Paint()..color = const Color(0xFF2D2D2D));
    canvas.drawCircle(Offset(w * 0.61, h * 0.27), w * 0.035, Paint()..color = const Color(0xFF2D2D2D));
    final beak = Path()
      ..moveTo(w * 0.5, h * 0.35)
      ..lineTo(w * 0.43, h * 0.3)
      ..lineTo(w * 0.57, h * 0.3)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFEF5DA8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}