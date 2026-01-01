import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, bool>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<bool> {
  late SignupUseCase _signupUseCase;
  late LoginUseCase _loginUseCase;

  @override
  bool build() {
    final datasource = AuthLocalDatasource();
    final repository = AuthRepositoryImpl(datasource);

    _signupUseCase = SignupUseCase(repository);
    _loginUseCase = LoginUseCase(repository);

    return false; // initial login state
  }

  Future<void> signup(String email, String password) async {
    await _signupUseCase(email, password);
  }

  Future<bool> login(String email, String password) async {
    final success = await _loginUseCase(email, password);
    state = success;
    return success;
  }
}
