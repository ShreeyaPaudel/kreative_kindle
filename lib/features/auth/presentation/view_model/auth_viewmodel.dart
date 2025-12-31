import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

/// PROVIDER
final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  final datasource = AuthLocalDatasource();
  final repository = AuthRepositoryImpl(datasource);

  final signupUseCase = SignupUseCase(repository);
  final loginUseCase = LoginUseCase(repository);

  return AuthViewModel(
    signupUseCase: signupUseCase,
    loginUseCase: loginUseCase,
  );
});

/// VIEWMODEL
class AuthViewModel extends StateNotifier<bool> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;

  AuthViewModel({required this.signupUseCase, required this.loginUseCase})
    : super(false);

  Future<void> signup(String email, String password) async {
    await signupUseCase(email, password);
  }

  Future<bool> login(String email, String password) async {
    final success = await loginUseCase(email, password);
    state = success;
    return success;
  }
}
