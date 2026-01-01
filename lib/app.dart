import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_screen.dart';

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreative Kindle',
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(), // or LoginScreen
    );
  }
}
