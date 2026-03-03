import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors a settings row (label + switch) like those in the Settings page.
class _SettingsRowDummy extends StatefulWidget {
  final String label;
  final bool initialValue;

  const _SettingsRowDummy({required this.label, required this.initialValue});

  @override
  State<_SettingsRowDummy> createState() => _SettingsRowDummyState();
}

class _SettingsRowDummyState extends State<_SettingsRowDummy> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('settingsRow'),
      title: Text(widget.label, key: const Key('settingsLabel')),
      trailing: Switch(
        key: const Key('settingsSwitch'),
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      ),
    );
  }
}

void main() {
  testWidgets('PASS: settings row renders label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _SettingsRowDummy(label: 'Dark Mode', initialValue: false),
        ),
      ),
    );

    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.byKey(const Key('settingsLabel')), findsOneWidget);
  });

  testWidgets('PASS: settings row shows switch widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _SettingsRowDummy(label: 'Notifications', initialValue: true),
        ),
      ),
    );

    expect(find.byKey(const Key('settingsSwitch')), findsOneWidget);
    final sw = tester.widget<Switch>(find.byKey(const Key('settingsSwitch')));
    expect(sw.value, true);
  });

  testWidgets('PASS: tapping switch toggles its state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _SettingsRowDummy(label: 'Sound Effects', initialValue: false),
        ),
      ),
    );

    // Starts off
    Switch sw = tester.widget<Switch>(find.byKey(const Key('settingsSwitch')));
    expect(sw.value, false);

    // Tap the switch
    await tester.tap(find.byKey(const Key('settingsSwitch')));
    await tester.pump();

    // Now on
    sw = tester.widget<Switch>(find.byKey(const Key('settingsSwitch')));
    expect(sw.value, true);
  });
}
