import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:joycharm/views/catalog_view.dart';
import 'package:joycharm/views/favorite_view.dart';
import 'package:joycharm/views/home_view.dart';
import 'package:joycharm/views/profile_view.dart';
import 'package:joycharm/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomePage(),
        '/': (context) => const SplashScreen(),
        '/catalog': (context) => const CatalogView(),
        '/profile': (context) => const ProfilePage(),
        '/favorite': (context) => const FavoriteScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: JoyCharmColors.primary,
          primary: JoyCharmColors.primary,
          secondary: JoyCharmColors.secondary,
        ),
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class JoyCharmColors {
  static const Color primary = Color(0xFFEF5DA8);
  static const Color primaryLight = Color(0xFFFFA8D3);
  static const Color primaryPastel = Color(0xFFFFE4F1);
  static const Color secondary = Color(0xFF4DBFBF);
  static const Color secondaryLight = Color(0xFFB2EBEB);
  static const Color accent = Color(0xFFFFD166);

  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMedium = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFAAAAAA);

  static const Color cardBg = Color(0xFFFFF0F7);

  static const Color white = Colors.white;

  JoyCharmColors._();
}
