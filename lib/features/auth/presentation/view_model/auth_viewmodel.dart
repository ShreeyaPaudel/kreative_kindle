// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  final datasource = AuthLocalDatasource();
  final repository = AuthRepositoryImpl(datasource);

  final loginUseCase = LoginUseCase(repository);
  final signupUseCase = SignupUseCase(repository);

  return AuthViewModel(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
  );
});

class AuthViewModel extends StateNotifier<bool> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthViewModel({required this.loginUseCase, required this.signupUseCase})
    : super(false);

  Future<bool> login(String email, String password) async {
    final success = await loginUseCase(email, password);
    state = success;
    return success;
  }

  Future<void> signup(String email, String password) async {
    await signupUseCase(email, password);
  }
}
