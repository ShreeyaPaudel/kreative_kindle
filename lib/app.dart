import 'package:flutter/material.dart';
import 'package:kreative_kindle/screens/Parent/Dashboard/parent_dashboard.dart';
import 'package:kreative_kindle/screens/Parent_Instructor/Auth/login_screen.dart';
import 'screens/Parent_Instructor/Splash/splash_screen.dart';
import 'package:kreative_kindle/theme/theme_data.dart';

class KreativeKindleApp extends StatelessWidget {
  const KreativeKindleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KreativeKindle",
      theme: getApplicationTheme(),
      home: const ParentDashboard(),
    );
  }
}
