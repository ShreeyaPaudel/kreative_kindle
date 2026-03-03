import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the FeatureTile widget used in the dashboard home grid.
class _FeatureTileDummy extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FeatureTileDummy({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('featureTile'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, key: const Key('tileIcon')),
            const SizedBox(height: 6),
            Text(label, key: const Key('tileLabel')),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('PASS: feature tile renders icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _FeatureTileDummy(
            icon: Icons.brush,
            label: 'Craft Corner',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('tileIcon')), findsOneWidget);
  });

  testWidgets('PASS: feature tile renders label text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _FeatureTileDummy(
            icon: Icons.menu_book,
            label: 'Story Time',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Story Time'), findsOneWidget);
    expect(find.byKey(const Key('tileLabel')), findsOneWidget);
  });

  testWidgets('PASS: feature tile tap triggers callback', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _FeatureTileDummy(
            icon: Icons.calculate,
            label: 'Numbers & Logic',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('featureTile')));
    await tester.pump();

    expect(tapped, true);
  });
}
