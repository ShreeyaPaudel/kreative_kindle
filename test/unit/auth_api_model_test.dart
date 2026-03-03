import 'package:flutter_test/flutter_test.dart';
import 'package:kreative_kindle/features/auth/data/models/auth_api_model.dart';

void main() {
  group('AuthApiModel', () {
    test('toLoginJson contains email and password keys only', () {
      final model = AuthApiModel(email: 'user@test.com', password: 'secret123');
      final json = model.toLoginJson();

      expect(json['email'], 'user@test.com');
      expect(json['password'], 'secret123');
      expect(json.containsKey('username'), false);
    });

    test('toRegisterJson maps fullName to username key', () {
      final model = AuthApiModel(
        fullName: 'Alice Smith',
        email: 'alice@test.com',
        password: 'pass1234',
        address: '10 Main St',
      );
      final json = model.toRegisterJson();

      expect(json['username'], 'Alice Smith');
      expect(json['email'], 'alice@test.com');
      expect(json['address'], '10 Main St');
    });

    test('fromJson parses token and email from response', () {
      final json = {
        'email': 'bob@test.com',
        'token': 'jwt_token_xyz',
      };
      final model = AuthApiModel.fromJson(json);

      expect(model.token, 'jwt_token_xyz');
      expect(model.email, 'bob@test.com');
    });

    test('fromJson sets password to empty string for security', () {
      final json = {
        'email': 'carol@test.com',
        'password': 'shouldBeIgnored',
        'token': 'tok123',
      };
      final model = AuthApiModel.fromJson(json);

      // Password must never be stored from a server response
      expect(model.password, '');
    });
  });
}
