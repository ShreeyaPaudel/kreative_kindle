import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  final r = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return r.hasMatch(email.trim());
}

bool isValidPassword(String password) {
  return password.trim().length >= 6;
}

void main() {
  group('Validators', () {
    test('Valid email passes', () {
      expect(isValidEmail('test@gmail.com'), true);
    });

    test('Invalid email fails', () {
      expect(isValidEmail('testgmail.com'), false);
    });

    test('Password length < 6 fails', () {
      expect(isValidPassword('12345'), false);
    });

    test('Password length >= 6 passes', () {
      expect(isValidPassword('123456'), true);
    });
  });
}
