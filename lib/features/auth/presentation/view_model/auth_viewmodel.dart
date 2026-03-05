import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/auth_api_model.dart';
import '../../data/repositories/auth_api_repository.dart';

const _tokenKey = 'auth_token';
const _storage = FlutterSecureStorage();

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final repo = ref.read(authApiRepositoryProvider);
  return AuthViewModel(repo);
});

class AuthState {
  final bool isLoading;
  final String? error;
  final String? token;

  const AuthState({this.isLoading = false, this.error, this.token});

  AuthState copyWith({bool? isLoading, String? error, String? token}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthApiRepository _repo;

  AuthViewModel(this._repo) : super(const AuthState()) {
    _loadToken();
  }

  // Load token on app start
  Future<void> _loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(token: token);
    }
  }

  Future<bool> signup({
    required String fullName,
    required String email,
    required String address,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final model = AuthApiModel(
        fullName: fullName,
        email: email,
        address: address,
        password: password,
        role: "parent",
      );
      await _repo.register(model);
      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repo.login(email, password);
      final token = res["token"]?.toString();

      if (token == null || token.isEmpty) {
        throw Exception("Token not found from backend");
      }

      await _storage.write(key: _tokenKey, value: token);

      // Persist user info for Profile page
      final prefs = await SharedPreferences.getInstance();
      if (res['userId'] != null) {
        await prefs.setString('user_id', res['userId'].toString());
      }
      if (res['email'] != null) {
        await prefs.setString('user_email', res['email'].toString());
      }

      state = state.copyWith(isLoading: false, error: null, token: token);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.forgotPassword(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.resetPassword(token: token, newPassword: newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final googleUser = await GoogleSignIn(
        serverClientId: '911031020815-cqe289klh2micbi09jrtae5tn049b8h8.apps.googleusercontent.com',
      ).signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        state = state.copyWith(isLoading: false);
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception("Google idToken not available");

      final res = await _repo.loginWithGoogle(idToken);
      final token = res['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception("Token not received from backend");
      }

      await _storage.write(key: _tokenKey, value: token);

      // Persist user info for Profile page
      if (res['userId'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', res['userId'].toString());
      }

      state = state.copyWith(isLoading: false, error: null, token: token);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.updateProfile(
        userId: userId,
        username: username,
        email: email,
        password: password,
      );
      // Update cached email if changed
      if (email != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    state = const AuthState();
  }
}
