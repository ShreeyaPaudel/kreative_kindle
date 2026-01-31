import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginNavDemoDummy extends StatelessWidget {
  const LoginNavDemoDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          key: const Key('goHome'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('HOME_SCREEN')),
              ),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('PASS: navigates to home screen', (tester) async {
    await tester.pumpWidget(const LoginNavDemoDummy());

    await tester.tap(find.byKey(const Key('goHome')));
    await tester.pumpAndSettle();

    expect(find.text('HOME_SCREEN'), findsOneWidget);
  });
}
