import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }
}

// Proper themes
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF8EC5FC),
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
    bodyMedium: TextStyle(color: Color(0xFF1A1A1A)),
    bodySmall: TextStyle(color: Color(0xFF555555)),
  ),
  cardColor: const Color(0xFFF5F7FF),
  dividerColor: const Color(0xFFE0E0E0),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF8EC5FC),
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF0F0F0)),
    bodyMedium: TextStyle(color: Color(0xFFF0F0F0)),
    bodySmall: TextStyle(color: Color(0xFFAAAAAA)),
  ),
  cardColor: const Color(0xFF1E1E1E),
  dividerColor: const Color(0xFF333333),
);
