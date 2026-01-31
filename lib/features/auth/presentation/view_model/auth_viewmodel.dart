import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

import '../../data/models/auth_api_model.dart';
import '../../data/repositories/auth_api_repository.dart';

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

  AuthViewModel(this._repo) : super(const AuthState());

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

      state = state.copyWith(isLoading: false, error: null, token: token);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearAuth() {
    state = const AuthState();
  }
}
