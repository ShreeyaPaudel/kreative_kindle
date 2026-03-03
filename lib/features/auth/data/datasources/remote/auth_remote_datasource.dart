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

  // ✅ REGISTER
  Future<void> register(AuthApiModel model) async {
    await _dio.post(
      ApiEndpoints.register,
      data: {
        "fullName": model.fullName,
        "email": model.email,
        "address": model.address,
        "password": model.password,
        "role": model.role,
      },
    );
  }

  // ✅ FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  // ✅ RESET PASSWORD
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _dio.post(
      ApiEndpoints.resetPassword,
      data: {'token': token, 'newPassword': newPassword},
    );
  }

  // ✅ GOOGLE SIGN-IN — sends Google idToken to backend, gets JWT back
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await _dio.post(
      ApiEndpoints.googleAuth,
      data: {'idToken': idToken},
    );
    final data = response.data;
    final token = (data is Map) ? data['token']?.toString() : null;
    final role  = (data is Map) ? data['role']?.toString() : null;
    return <String, dynamic>{'token': token, 'role': role};
  }

  // ✅ LOGIN -> returns Map {role, token, email}
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );

    final data = response.data;

    // DEBUG (keep for now)
    // ignore: avoid_print
    print("LOGIN RESPONSE => $data");

    // Supports:
    // 1) { user: {...}, token: "..." }
    // 2) { data: { user: {...} }, token: "..." }
    // 3) { data: {...}, user: {...} } (extra safe)

    Map user = {};

    if (data is Map) {
      if (data["user"] is Map) {
        user = data["user"] as Map;
      } else if (data["data"] is Map && (data["data"] as Map)["user"] is Map) {
        user = (data["data"] as Map)["user"] as Map;
      }
    }

    final token = (data is Map) ? data["token"]?.toString() : null;
    final role = user["role"]?.toString();
    final userEmail = user["email"]?.toString();

    return <String, dynamic>{"email": userEmail, "role": role, "token": token};
  }
}
