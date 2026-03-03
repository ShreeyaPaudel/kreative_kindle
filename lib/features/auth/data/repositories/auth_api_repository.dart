import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kreative_kindle/core/services/connectivity/network_info.dart';
import 'package:kreative_kindle/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:kreative_kindle/features/auth/data/models/auth_api_model.dart';

final authApiRepositoryProvider = Provider<AuthApiRepository>((ref) {
  final remote = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthApiRepository(remote: remote, networkInfo: networkInfo);
});

class AuthApiRepository {
  final AuthRemoteDatasource remote;
  final NetworkInfo networkInfo;

  AuthApiRepository({required this.remote, required this.networkInfo});

  Future<bool> register(AuthApiModel model) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) throw Exception("No internet connection");

    try {
      await remote.register(model);
      return true;
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Registration failed";
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) throw Exception("No internet connection");

    try {
      return await remote.login(email: email, password: password);
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Login failed";
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) throw Exception("No internet connection");

    try {
      await remote.forgotPassword(email);
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Failed to send reset email";
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) throw Exception("No internet connection");

    try {
      await remote.resetPassword(token: token, newPassword: newPassword);
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Password reset failed";
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) throw Exception("No internet connection");

    try {
      return await remote.loginWithGoogle(idToken);
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Google sign-in failed";
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
