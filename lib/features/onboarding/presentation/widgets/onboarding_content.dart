import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(item.imagePath, height: 260),
        const SizedBox(height: 30),
        if (item.title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF444444),
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6F6F6F),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
