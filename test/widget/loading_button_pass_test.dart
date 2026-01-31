import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoadingButtonDummy extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoadingButtonDummy({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loadingBtn'),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Submit'),
    );
  }
}

void main() {
  testWidgets('PASS: shows loader when loading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingButtonDummy(isLoading: true, onPressed: _noop),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Submit'), findsNothing);
  });

  testWidgets('PASS: shows text when not loading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingButtonDummy(isLoading: false, onPressed: _noop),
        ),
      ),
    );

    expect(find.text('Submit'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

void _noop() {}
