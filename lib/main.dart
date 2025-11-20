import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/gallery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/view_result_screen.dart';
import 'services/firebase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      // Do not log the key value, only that it's missing.
      // The app can still run, but Gemini-based features will fail fast.
      // You can surface a UI warning elsewhere if desired.
      // ignore: avoid_print
      print(
        'GEMINI_API_KEY is not set in .env; Gemini features will be disabled.',
      );
}
  } catch (error) {
    // ignore: avoid_print
    print('Failed to load .env file: $error');
  }

  await FirebaseInitializer.ensureInitialized();
  runApp(const ProviderScope(child: ProfilePicApp()));
}

class ProfilePicApp extends StatelessWidget {
  const ProfilePicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
    ).textTheme;

    return MaterialApp(
      title: 'AI Profile Picture Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: baseTextTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF1F2937),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(999),
          thickness: WidgetStateProperty.all(4),
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.dragged)
                ? const Color(0xFF7C89FF)
                : const Color(0xFF5E66F9),
          ),
          trackColor: WidgetStateProperty.all(const Color(0x26FFFFFF)),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF020617),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF020617),
          hintStyle: const TextStyle(color: Colors.white54),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0x26FFFFFF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0x26FFFFFF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.indigoAccent,
              width: 1.4,
            ),
          ),
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        GalleryScreen.routeName: (_) => const GalleryScreen(),
        ViewResultScreen.routeName: (_) => const ViewResultScreen(),
      },
    );
  }
}
