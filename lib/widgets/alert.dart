import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:joycharm/main.dart';

class AlertMessage {
  // ─── Snackbar Alert ───────────────────────────────────────────────────────

  void showAlert(BuildContext context, String message, bool status) {
    final Color borderColor = status
        ? const Color(0xFF4DBFBF)   // teal for success
        : const Color(0xFFEF5DA8);  // pink for error
    final IconData icon = status
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: borderColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: borderColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: JoyCharmColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Icon(
                      Icons.close_rounded,
                      color: JoyCharmColors.textLight,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Confirm Dialog ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> showAlertDialog(
    BuildContext context, {
    String title = 'Konfirmasi',
    String content = 'Yakin ingin menghapus data ini?',
    String cancelText = 'Batal',
    String confirmText = 'Hapus',
    Color confirmColor = JoyCharmColors.primary,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: JoyCharmColors.primaryPastel,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: JoyCharmColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: JoyCharmColors.textDark,
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: JoyCharmColors.textMedium,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop({'status': false}),
              style: TextButton.styleFrom(
                foregroundColor: JoyCharmColors.textMedium,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                cancelText,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop({'status': true}),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Loading Dialog ───────────────────────────────────────────────────────

  void showLoading(BuildContext context, {String message = 'Memuat...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: JoyCharmColors.primary,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: JoyCharmColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}