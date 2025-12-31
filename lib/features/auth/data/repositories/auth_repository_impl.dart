import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<void> signup(String email, String password) {
    return datasource.signup(email, password);
  }

  @override
  Future<bool> login(String email, String password) {
    return datasource.login(email, password);
  }
}
