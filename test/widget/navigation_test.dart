import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginNavDummy extends StatelessWidget {
  const LoginNavDummy({super.key});

  @override
  Widget build(BuildContext context) {
    // No routes provided intentionally (common real bug)
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/home'),
          child: const Text('Go'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('FAIL: navigation throws when route not registered', (
    tester,
  ) async {
    await tester.pumpWidget(const LoginNavDummy());

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    // This expectation is intentionally wrong; route is missing => test fails.
    expect(find.text('HOME_SCREEN'), findsOneWidget);
  });
}
