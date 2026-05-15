import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joycharm/views/catalog_view.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const JoyCharmApp());
}

class JoyCharmApp extends StatelessWidget {
  const JoyCharmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joy Charm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: JoyCharmColors.primary,
          primary: JoyCharmColors.primary,
          secondary: JoyCharmColors.secondary,
        ),
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: JoyCharmColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            textStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: JoyCharmColors.primary,
            side: const BorderSide(color: JoyCharmColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            textStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: JoyCharmColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const CatalogView(),
    );
  }
}

/// Global color palette for Joy Charm
class JoyCharmColors {
  static const Color primary = Color(0xFFEF5DA8);      // Hot pink
  static const Color primaryLight = Color(0xFFFFA8D3); // Light pink
  static const Color primaryPastel = Color(0xFFFFE4F1); // Pastel pink bg
  static const Color secondary = Color(0xFF4DBFBF);    // Teal/mint
  static const Color secondaryLight = Color(0xFFB2EBEB); // Light teal
  static const Color accent = Color(0xFFFFD166);       // Yellow accent
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMedium = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFAAAAAA);
  static const Color cardBg = Color(0xFFFFF0F7);
  static const Color white = Colors.white;

  JoyCharmColors._();
}

/// Global text styles for Joy Charm
class JoyCharmTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: JoyCharmColors.textDark,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: JoyCharmColors.textDark,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: JoyCharmColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: JoyCharmColors.textMedium,
    height: 1.5,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: JoyCharmColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: JoyCharmColors.textLight,
  );

  JoyCharmTextStyles._();
}