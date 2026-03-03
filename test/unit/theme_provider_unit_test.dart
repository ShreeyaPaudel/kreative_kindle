import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kreative_kindle/core/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeNotifier', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is false (light mode) before async load', () {
      final notifier = ThemeNotifier();
      // super(false) sets the default synchronously
      expect(notifier.state, false);
    });

    test('setTheme(true) switches state to dark mode', () async {
      final notifier = ThemeNotifier();
      await notifier.setTheme(true);

      expect(notifier.state, true);
    });

    test('setTheme with same value is a no-op', () async {
      final notifier = ThemeNotifier();
      // state starts as false; calling setTheme(false) should leave it unchanged
      await notifier.setTheme(false);

      expect(notifier.state, false);
    });
  });
}
