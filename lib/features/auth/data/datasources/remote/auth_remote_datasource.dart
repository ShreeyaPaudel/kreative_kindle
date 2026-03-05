import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth_api_model.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDatasource(apiClient.dio);
});

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  // REGISTER — backend expects { username, email, password }
  Future<void> register(AuthApiModel model) async {
    await _dio.post(
      ApiEndpoints.register,
      data: {
        'username': model.fullName ?? '',
        'email': model.email,
        'password': model.password,
      },
    );
  }

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data;
    Map user = {};
    if (data is Map && data['user'] is Map) {
      user = data['user'] as Map;
    }

    final token     = (data is Map) ? data['token']?.toString() : null;
    final role      = user['role']?.toString();
    final userEmail = user['email']?.toString();
    final userId    = (user['id'] ?? user['_id'])?.toString();

    return <String, dynamic>{
      'email': userEmail,
      'role': role,
      'token': token,
      'userId': userId,
    };
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  // RESET PASSWORD — backend expects { token, password }
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _dio.post(
      ApiEndpoints.resetPassword,
      data: {'token': token, 'password': newPassword},
    );
  }

  // GOOGLE SIGN-IN (mobile) — sends idToken to POST /api/auth/google/token
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await _dio.post(
      ApiEndpoints.googleMobileAuth,
      data: {'idToken': idToken},
    );
    final data   = response.data;
    final token  = (data is Map) ? data['token']?.toString() : null;
    final u      = (data is Map && data['user'] is Map) ? data['user'] as Map : <dynamic, dynamic>{};
    final role   = u['role']?.toString();
    final userId = (u['id'] ?? u['_id'])?.toString();
    return <String, dynamic>{'token': token, 'role': role, 'userId': userId};
  }

  // UPDATE PROFILE — PUT /api/auth/:id
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? password,
  }) async {
    final response = await _dio.put(
      '${ApiEndpoints.updateProfile}/$userId',
      data: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
      },
    );
    final data = response.data;
    return (data is Map) ? Map<String, dynamic>.from(data) : {};
  }
}
