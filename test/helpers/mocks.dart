import 'package:mocktail/mocktail.dart';

/// Replace these with your real abstractions if you have them.
/// If you don't, keep these as test-only interfaces.

abstract class AuthRepository {
  Future<String> login({
    required String email,
    required String password,
  }); // token
  Future<void> register({required String email, required String password});
}

abstract class TokenService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenService extends Mock implements TokenService {}
