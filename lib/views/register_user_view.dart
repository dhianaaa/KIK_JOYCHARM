import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'login_view.dart';
import 'home_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  // Password strength
  int _passwordStrength = 0; // 0-3

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();

    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final val = _passwordController.text;
    int strength = 0;
    if (val.length >= 8) strength++;
    if (val.contains(RegExp(r'[A-Z]'))) strength++;
    if (val.contains(RegExp(r'[0-9]'))) strength++;
    if (val.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength++;
    // cap at 3 for display
    setState(() => _passwordStrength = strength.clamp(0, 3));
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Kamu harus setuju dengan syarat & ketentuan',
            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600),
          ),
          backgroundColor: JoyCharmColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);
    _navigateToHome();
  }

  Future<void> _handleSocialRegister(String provider) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: JoyCharmColors.primaryPastel,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: JoyCharmColors.primary,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Header
                  _buildHeader(),

                  const SizedBox(height: 28),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildUsernameField(),
                        const SizedBox(height: 16),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 8),
                        _buildPasswordStrengthBar(),
                        const SizedBox(height: 16),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 16),
                        _buildTermsRow(),
                        const SizedBox(height: 24),
                        _buildRegisterButton(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  _buildDivider(),

                  const SizedBox(height: 20),

                  // Social buttons
                  _buildSocialButtons(),

                  const SizedBox(height: 28),

                  // Login link
                  _buildLoginLink(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo row
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: JoyCharmColors.primaryPastel,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: JoyCharmColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: 11,
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'JOY ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: JoyCharmColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'CHARM',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: JoyCharmColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Buat Akun\nBarumu! 🎉',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: JoyCharmColors.textDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bergabung dan mulai craft journey kamu',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: JoyCharmColors.textMedium,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return _JCTextField(
      controller: _usernameController,
      label: 'Username',
      hint: 'joycharm_user',
      icon: Icons.person_outline_rounded,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Username tidak boleh kosong';
        if (value.length < 3) return 'Username minimal 3 karakter';
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
          return 'Username hanya boleh huruf, angka, dan underscore';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _JCTextField(
      controller: _emailController,
      label: 'Email',
      hint: 'emailkamu@gmail.com',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: JoyCharmColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Min. 8 karakter',
            hintStyle: const TextStyle(
              fontFamily: 'Nunito',
              color: JoyCharmColors.textLight,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: JoyCharmColors.primary,
              size: 20,
            ),
            suffixIcon: GestureDetector(
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: JoyCharmColors.textLight,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: JoyCharmColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 8) return 'Password minimal 8 karakter';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthBar() {
    final labels = ['', 'Lemah', 'Sedang', 'Kuat'];
    final colors = [
      Colors.grey.shade200,
      Colors.red.shade400,
      const Color(0xFFFFD166),
      const Color(0xFF4DBFBF),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (index) {
            final filled = index < _passwordStrength;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  color: filled
                      ? colors[_passwordStrength]
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Kekuatan: ${labels[_passwordStrength]}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: _passwordStrength > 0
                  ? colors[_passwordStrength]
                  : Colors.grey.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfirmasi Password',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: JoyCharmColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Ulangi password',
            hintStyle: const TextStyle(
              fontFamily: 'Nunito',
              color: JoyCharmColors.textLight,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: JoyCharmColors.primary,
              size: 20,
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
              child: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: JoyCharmColors.textLight,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: JoyCharmColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Konfirmasi password tidak boleh kosong';
            }
            if (value != _passwordController.text) {
              return 'Password tidak cocok';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsRow() {
    return GestureDetector(
      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _agreeToTerms ? JoyCharmColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _agreeToTerms
                    ? JoyCharmColors.primary
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: _agreeToTerms
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Saya setuju dengan ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' dan ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' Joy Charm',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: JoyCharmColors.textMedium,
                      fontWeight: FontWeight.w500,
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

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: JoyCharmColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBackgroundColor: JoyCharmColors.primaryLight,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Daftar Sekarang',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey.shade200, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'atau daftar dengan',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey.shade200, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Google',
            icon: _GoogleIcon(),
            onTap: () => _handleSocialRegister('Google'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SocialButton(
            label: 'Facebook',
            icon: _FacebookIcon(),
            onTap: () => _handleSocialRegister('Facebook'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SocialButton(
            label: 'X',
            icon: _TwitterXIcon(),
            onTap: () => _handleSocialRegister('Twitter'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: _goToLogin,
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Sudah punya akun? ',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: JoyCharmColors.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Log in',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: JoyCharmColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Text Field ──────────────────────────────────────────────────────

class _JCTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _JCTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: JoyCharmColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: JoyCharmColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Nunito',
              color: JoyCharmColors.textLight,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, color: JoyCharmColors.primary, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: JoyCharmColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

// ─── Social Button & Icons (shared, same as login) ───────────────────────────

class _SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 50,
        decoration: BoxDecoration(
          color: _pressed ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            const SizedBox(height: 2),
            Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: JoyCharmColors.textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final green = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r), -0.35, 1.3, false, red);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r), 0.95, 1.05, false, green);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r), 2.0, 1.05, false, yellow);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r), 3.05, 0.85, false, blue);

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5, size.height * 0.38, size.width * 0.46,
          size.height * 0.2),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _TwitterXIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: Text(
          '𝕏',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            height: 1,
          ),
        ),
      ),
    );
  }
}