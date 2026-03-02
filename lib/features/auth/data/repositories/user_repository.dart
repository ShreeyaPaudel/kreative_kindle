import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) return null;
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded;
    } catch (e) {
      return null;
    }
  }
}
