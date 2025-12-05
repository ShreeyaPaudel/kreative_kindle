import 'package:flutter/material.dart';
import 'onboarding3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen3()),
          );
        }
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 20,
                child: Image.asset(
                  "assets/illustrations/Onboarding/top_left.png",
                  height: 25,
                ),
              ),

              Positioned(
                top: 60,
                right: 20,
                child: Image.asset(
                  "assets/illustrations/Onboarding/top_right.png",
                  height: 60,
                ),
              ),

              Positioned(
                bottom: 60,
                left: 25,
                child: Image.asset(
                  "assets/illustrations/Onboarding/bottom_left.png",
                  height: 55,
                ),
              ),

              Positioned(
                bottom: 40,
                right: 25,
                child: Image.asset(
                  "assets/illustrations/Onboarding/bottom_right.png",
                  height: 55,
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/illustrations/Onboarding/middle.png",
                    height: 160,
                  ),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "KreativeKindle helps you discover age-appropriate, meaningful activities that spark imagination and support child development.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ⭐ NEW THEME-MATCHED DOTS ⭐
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Inactive dot
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0x667FD4F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Active dot (your blue gradient style)
                      Container(
                        width: 22,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF3EBBDB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Inactive dot
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0x667FD4F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
