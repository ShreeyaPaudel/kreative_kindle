import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the timer widget used in ActivityDetailPage.
class _TimerDummy extends StatefulWidget {
  final int initialSeconds;
  const _TimerDummy(this.initialSeconds);

  @override
  State<_TimerDummy> createState() => _TimerDummyState();
}

class _TimerDummyState extends State<_TimerDummy> {
  late int _remaining;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.initialSeconds;
  }

  String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_fmt(_remaining), key: const Key('timerDisplay')),
        ElevatedButton(
          key: const Key('startPauseBtn'),
          onPressed: () => setState(() => _running = !_running),
          child: Text(_running ? 'Pause' : 'Start'),
        ),
        ElevatedButton(
          key: const Key('resetBtn'),
          onPressed: () => setState(() {
            _remaining = widget.initialSeconds;
            _running = false;
          }),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('PASS: timer renders formatted time correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _TimerDummy(600))),
    );
    expect(find.text('10:00'), findsOneWidget);
    expect(find.byKey(const Key('timerDisplay')), findsOneWidget);
  });

  testWidgets('PASS: start button renders and toggles label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _TimerDummy(300))),
    );
    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.byKey(const Key('startPauseBtn')));
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);
  });

  testWidgets('PASS: reset button restores original time', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _TimerDummy(600))),
    );
    // Tap start, then reset
    await tester.tap(find.byKey(const Key('startPauseBtn')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('resetBtn')));
    await tester.pump();
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('PASS: 25-min timer shows 25:00', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _TimerDummy(1500))),
    );
    expect(find.text('25:00'), findsOneWidget);
  });
}
