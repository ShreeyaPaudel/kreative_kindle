import 'package:riverpod/legacy.dart';

import '../../data/models/auth_api_model.dart';
import '../../data/repositories/auth_api_repository.dart';
import '../../../../core/services/user_role.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final repo = ref.read(authApiRepositoryProvider);
  return AuthViewModel(repo);
});

class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, error: error);
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
        role: UserRole.role,
      );

      await _repo.register(model);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repo.login(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
