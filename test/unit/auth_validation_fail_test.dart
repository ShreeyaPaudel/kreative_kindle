import 'package:flutter_test/flutter_test.dart';

bool validateLogin(String email, String password) {
  if (!email.contains('@')) return false;
  if (password.length < 6) return false;
  return true;
}

void main() {
  test('FAIL: login should reject weak password', () {
    // Intentionally expecting wrong behaviour
    expect(validateLogin('test@gmail.com', '123'), true);
  });
}
