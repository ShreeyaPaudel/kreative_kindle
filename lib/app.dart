import 'package:flutter/material.dart';
import 'package:kreative_kindle/features/auth/presentation/pages/login_screen.dart';
// import 'screens/Parent_Instructor/Splash/splash_screen.dart';
import 'package:kreative_kindle/theme/theme_data.dart';

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KreativeKindle",
      theme: getApplicationTheme(),
      home: const LoginScreen(),
    );
  }
}
