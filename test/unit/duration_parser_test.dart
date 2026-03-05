import 'package:flutter_test/flutter_test.dart';

/// Mirrors the _parseDurationSeconds logic in ActivityDetailPage.
int parseDurationSeconds(String duration) {
  final parts = duration.split(' ');
  return (int.tryParse(parts.first) ?? 10) * 60;
}

String formatTime(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

void main() {
  group('Duration parser', () {
    test('PASS: parses "10 mins" as 600 seconds', () {
      expect(parseDurationSeconds('10 mins'), 600);
    });

    test('PASS: parses "25 mins" as 1500 seconds', () {
      expect(parseDurationSeconds('25 mins'), 1500);
    });

    test('PASS: formatTime formats 600 seconds as "10:00"', () {
      expect(formatTime(600), '10:00');
    });

    test('PASS: formatTime formats 65 seconds as "01:05"', () {
      expect(formatTime(65), '01:05');
    });
  });
}
