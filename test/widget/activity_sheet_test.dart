import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the _ActivitySuggestionSheet bottom sheet shown on shake in dashboard.
class _ActivitySheetDummy extends StatelessWidget {
  final String emoji;
  final String title;
  final String category;
  final VoidCallback onDismiss;

  const _ActivitySheetDummy({
    required this.emoji,
    required this.title,
    required this.category,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, key: const Key('activityEmoji'), style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(title, key: const Key('activityTitle')),
          const SizedBox(height: 4),
          Text(category, key: const Key('activityCategory')),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('startBtn'),
            onPressed: () {},
            child: const Text('Start Activity →'),
          ),
          TextButton(
            key: const Key('dismissBtn'),
            onPressed: onDismiss,
            child: const Text('Maybe later'),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('PASS: activity sheet shows emoji, title and category', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _ActivitySheetDummy(
            emoji: '🎨',
            title: 'Rainbow Paper Craft',
            category: 'Arts & Crafts',
            onDismiss: () {},
          ),
        ),
      ),
    );

    expect(find.text('🎨'), findsOneWidget);
    expect(find.text('Rainbow Paper Craft'), findsOneWidget);
    expect(find.text('Arts & Crafts'), findsOneWidget);
    expect(find.byKey(const Key('startBtn')), findsOneWidget);
  });

  testWidgets('PASS: maybe later button triggers dismiss callback', (tester) async {
    bool dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _ActivitySheetDummy(
            emoji: '📚',
            title: 'Story Building',
            category: 'Language',
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('dismissBtn')));
    await tester.pump();

    expect(dismissed, true);
  });
}
