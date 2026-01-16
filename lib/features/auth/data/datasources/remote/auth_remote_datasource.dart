import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kreative_kindle/core/api/api_client.dart';
import 'package:kreative_kindle/core/api/api_endpoints.dart';
import 'package:kreative_kindle/core/services/user_role.dart';
import 'package:kreative_kindle/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDatasource(apiClient: apiClient);
});

class AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasource({required this.apiClient});

  Future<AuthApiModel> register(AuthApiModel model) async {
    final role = UserRole.role;

    final response = await apiClient.post(
      ApiEndpoints.register,
      data: AuthApiModel(
        fullName: model.fullName,
        email: model.email,
        address: model.address,
        password: model.password,
        role: role,
      ).toRegisterJson(), // ✅ sends username
    );

    return AuthApiModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthApiModel> login({
    required String email,
    required String password,
  }) async {
    final role = UserRole.role;

    final response = await apiClient.post(
      ApiEndpoints.login,
      data: AuthApiModel(
        email: email,
        password: password,
        role: role,
      ).toLoginJson(),
    );

    return AuthApiModel.fromJson(response.data as Map<String, dynamic>);
  }
}
