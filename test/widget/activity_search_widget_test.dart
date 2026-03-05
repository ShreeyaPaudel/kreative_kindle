import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the search bar used in ActivitiesPage.
class _SearchBarDummy extends StatefulWidget {
  const _SearchBarDummy();

  @override
  State<_SearchBarDummy> createState() => _SearchBarDummyState();
}

class _SearchBarDummyState extends State<_SearchBarDummy> {
  String _query = '';
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key('activitySearch'),
          controller: _ctrl,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search activities...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    key: const Key('clearBtn'),
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
        Text(
          _query.isEmpty ? 'no-query' : _query,
          key: const Key('queryDisplay'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: search bar renders with hint text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _SearchBarDummy())),
    );
    expect(find.byKey(const Key('activitySearch')), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search activities...'), findsOneWidget);
  });

  testWidgets('PASS: typing updates query and shows clear button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _SearchBarDummy())),
    );
    await tester.enterText(find.byKey(const Key('activitySearch')), 'craft');
    await tester.pump();
    expect(find.byKey(const Key('clearBtn')), findsOneWidget);
    expect(find.text('craft'), findsAtLeastNWidgets(1));
  });

  testWidgets('PASS: tapping clear resets query', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _SearchBarDummy())),
    );
    await tester.enterText(find.byKey(const Key('activitySearch')), 'nature');
    await tester.pump();
    await tester.tap(find.byKey(const Key('clearBtn')));
    await tester.pump();
    expect(find.text('no-query'), findsOneWidget);
  });
}
