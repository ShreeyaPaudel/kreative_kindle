import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDarkMode')) {
      // Respect user's saved preference
      state = prefs.getBool('isDarkMode')!;
    } else {
      // First launch: sync with device system theme
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      state = brightness == Brightness.dark;
      await prefs.setBool('isDarkMode', state);
    }
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }

  /// Called by the platform-brightness observer to sync theme automatically.
  Future<void> setTheme(bool isDark) async {
    if (state == isDark) return;
    state = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }
}
