import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  // 1️⃣ datasource
  final datasource = AuthLocalDatasource();

  // 2️⃣ repository
  final repository = AuthRepositoryImpl(datasource);

  // 3️⃣ usecases
  final signupUseCase = SignupUseCase(repository);
  final loginUseCase = LoginUseCase(repository);

  // 4️⃣ viewmodel
  return AuthViewModel(signupUseCase, loginUseCase);
});

class AuthViewModel extends StateNotifier<bool> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;

  AuthViewModel(this.signupUseCase, this.loginUseCase) : super(false);

  Future<void> signup(String email, String password) async {
    await signupUseCase(email, password);
  }

  Future<bool> login(String email, String password) async {
    final success = await loginUseCase(email, password);
    state = success;
    return success;
  }
}
