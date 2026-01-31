import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SnackbarDemoDummy extends StatelessWidget {
  const SnackbarDemoDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('showError'),
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      },
      child: const Text('Try'),
    );
  }
}

void main() {
  testWidgets('PASS: shows snackbar on tap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SnackbarDemoDummy())),
    );

    await tester.tap(find.byKey(const Key('showError')));
    await tester.pump(); // show snackbar

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
