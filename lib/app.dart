import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kreative_kindle/features/splash/presentation/pages/splash_screen.dart';

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreative Kindle',
      theme: ThemeData(useMaterial3: true),
      home: SplashScreen(),
    );
  }
}
