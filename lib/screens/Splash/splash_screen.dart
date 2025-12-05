import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/splashimage.png", height: 140),

            const SizedBox(height: 20),

            const Text(
              "Where creativity meets early learning.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // bolder text
                color: Colors.black87, // stronger color
                letterSpacing: 0.5, // cleaner premium look
              ),
            ),
          ],
        ),
      ),
    );
  }
}
