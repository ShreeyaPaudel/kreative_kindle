import 'package:flutter/material.dart';
import 'screens/Parent_Instructor/Splash/splash_screen.dart';

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KreativeKindle",
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const SplashScreen(),
    );
  }
}
