import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginScreenDummy extends StatelessWidget {
  const LoginScreenDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(key: Key('emailField')),
        const TextField(key: Key('passwordField')),
        ElevatedButton(
          key: const Key('loginBtn'),
          onPressed: () {},
          child: const Text('Login'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: login screen renders fields + button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginScreenDummy())),
    );

    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('loginBtn')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('PASS: typing email into email field updates its value',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginScreenDummy())),
    );
    await tester.enterText(
        find.byKey(const Key('emailField')), 'parent@test.com');
    await tester.pump();
    expect(find.text('parent@test.com'), findsOneWidget);
  });

  testWidgets('PASS: typing password into password field updates its value',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginScreenDummy())),
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret123');
    await tester.pump();
    expect(find.text('secret123'), findsOneWidget);
  });
}
