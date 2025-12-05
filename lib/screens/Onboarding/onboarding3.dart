import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context); // swipe RIGHT → go back to page 2
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Text(
              "This is Onboarding Page 3",
              style: TextStyle(fontSize: 18, color: Color(0xFF7A7A7A)),
            ),
          ),
        ),
      ),
    );
  }
}
