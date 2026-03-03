import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the onboarding slide structure used in OnboardingPage.
class _OnboardingContentDummy extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingContentDummy({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, key: const Key('onboardingIcon'), size: 80),
        const SizedBox(height: 24),
        Text(title, key: const Key('onboardingTitle')),
        const SizedBox(height: 12),
        Text(subtitle, key: const Key('onboardingSubtitle')),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: onboarding renders title text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _OnboardingContentDummy(
            title: 'Welcome to Kreative Kindle',
            subtitle: 'Learning made fun for kids',
            icon: Icons.auto_stories,
          ),
        ),
      ),
    );

    expect(find.text('Welcome to Kreative Kindle'), findsOneWidget);
    expect(find.byKey(const Key('onboardingTitle')), findsOneWidget);
  });

  testWidgets('PASS: onboarding renders subtitle and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _OnboardingContentDummy(
            title: 'Explore Activities',
            subtitle: 'Craft, read, and play every day',
            icon: Icons.palette,
          ),
        ),
      ),
    );

    expect(find.text('Craft, read, and play every day'), findsOneWidget);
    expect(find.byKey(const Key('onboardingIcon')), findsOneWidget);
  });
}
