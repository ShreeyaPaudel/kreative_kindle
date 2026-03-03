import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'OpenSans Regular',

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8EC5FC),
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8EC5FC),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontFamily: 'OpenSans Bold',
        color: Colors.white,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF8EC5FC),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

ThemeData getDarkApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'OpenSans Regular',

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8EC5FC),
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF0D1117),

    cardColor: const Color(0xFF161B22),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161B22),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontFamily: 'OpenSans Bold',
        color: Colors.white,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF161B22),
      selectedItemColor: Color(0xFF8EC5FC),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
