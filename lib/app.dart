import 'package:flutter/material.dart';
import 'package:kreative_kindle/screens/Parent/Dashboard/parent_dashboard.dart';
import 'screens/Parent_Instructor/Splash/splash_screen.dart';
import 'package:kreative_kindle/theme/theme_data.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'OpenSans Regular',

  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8EC5FC)),

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

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KreativeKindle",
      theme: appTheme,
      home: const ParentDashboard(),
    );
  }
}
