import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SignupScreenDummy extends StatelessWidget {
  const SignupScreenDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(key: Key('signupEmail')),
        const TextField(key: Key('signupPassword')),
        ElevatedButton(
          key: const Key('signupBtn'),
          onPressed: () {},
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: signup screen renders fields + button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SignupScreenDummy())),
    );

    expect(find.byKey(const Key('signupEmail')), findsOneWidget);
    expect(find.byKey(const Key('signupPassword')), findsOneWidget);
    expect(find.byKey(const Key('signupBtn')), findsOneWidget);
  });

  testWidgets('PASS: typing email into signup email field updates its value',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SignupScreenDummy())),
    );
    await tester.enterText(
        find.byKey(const Key('signupEmail')), 'newparent@example.com');
    await tester.pump();
    expect(find.text('newparent@example.com'), findsOneWidget);
  });

  testWidgets('PASS: typing password into signup password field works',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SignupScreenDummy())),
    );
    await tester.enterText(
        find.byKey(const Key('signupPassword')), 'myPassword99');
    await tester.pump();
    expect(find.text('myPassword99'), findsOneWidget);
  });
}
