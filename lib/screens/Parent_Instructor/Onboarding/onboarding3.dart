import 'package:flutter/material.dart';
import '../../Role/select_role.dart';
import 'onboarding2.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
        if (details.primaryVelocity! < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/illustrations/Onboarding/page3.png",
                height: 260,
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  "Engaging hands-on learning experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF444444),
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Dive into interactive lessons enriched with educational games and various creative activities.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6F6F6F),
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(66, 127, 212, 240),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(66, 127, 212, 240),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 62, 187, 219),
                      borderRadius: BorderRadius.circular(4),
                    ),
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
