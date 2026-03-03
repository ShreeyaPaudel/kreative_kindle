import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the progress display widgets found in the Progress page.
class _ProgressBarDummy extends StatelessWidget {
  final String label;
  final double value; // 0.0 – 1.0

  const _ProgressBarDummy({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, key: const Key('progressLabel')),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          key: const Key('progressBar'),
          value: value,
        ),
        const SizedBox(height: 4),
        Text('${(value * 100).round()}%', key: const Key('progressPercent')),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: progress bar renders with label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _ProgressBarDummy(label: 'Craft Activities', value: 0.6),
        ),
      ),
    );

    expect(find.byKey(const Key('progressBar')), findsOneWidget);
    expect(find.text('Craft Activities'), findsOneWidget);
  });

  testWidgets('PASS: progress bar shows correct percentage text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _ProgressBarDummy(label: 'Reading', value: 0.75),
        ),
      ),
    );

    expect(find.text('75%'), findsOneWidget);
    expect(find.byKey(const Key('progressPercent')), findsOneWidget);
  });
}
