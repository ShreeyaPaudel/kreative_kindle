import 'package:flutter_test/flutter_test.dart';

class LoginDTO {
  final String email;
  final String password;

  LoginDTO({required this.email, required this.password});

  bool get isValid => email.contains('@') && password.length >= 6;
}

void main() {
  test('LoginDTO valid when email+password ok', () {
    final dto = LoginDTO(email: 'a@b.com', password: '123456');
    expect(dto.isValid, true);
  });

  test('LoginDTO invalid when password too short', () {
    final dto = LoginDTO(email: 'a@b.com', password: '123');
    expect(dto.isValid, false);
  });
}
