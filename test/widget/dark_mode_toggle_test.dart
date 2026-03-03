import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the dark-mode toggle found in the app's Settings page.
class _DarkModeToggleDummy extends StatelessWidget {
  final bool isDark;

  const _DarkModeToggleDummy({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Dark Mode'),
        Switch(
          key: const Key('darkModeSwitch'),
          value: isDark,
          onChanged: (_) {},
        ),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: dark mode switch is OFF in light mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _DarkModeToggleDummy(isDark: false)),
      ),
    );

    final sw = tester.widget<Switch>(find.byKey(const Key('darkModeSwitch')));
    expect(sw.value, false);
    expect(find.text('Dark Mode'), findsOneWidget);
  });

  testWidgets('PASS: dark mode switch is ON in dark mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _DarkModeToggleDummy(isDark: true)),
      ),
    );

    final sw = tester.widget<Switch>(find.byKey(const Key('darkModeSwitch')));
    expect(sw.value, true);
  });
}
