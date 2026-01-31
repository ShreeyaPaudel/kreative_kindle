import 'package:flutter_test/flutter_test.dart';

/// If you already have ApiEndpoints in your app, replace this with your real import.
class ApiEndpoints {
  static String get baseUrl => 'http://localhost:3000/api/v1';
}

void main() {
  test('ApiEndpoints.baseUrl is not empty', () {
    expect(ApiEndpoints.baseUrl.isNotEmpty, true);
  });

  test('ApiEndpoints.baseUrl contains /api/v1', () {
    expect(ApiEndpoints.baseUrl.contains('/api/v1'), true);
  });
}
