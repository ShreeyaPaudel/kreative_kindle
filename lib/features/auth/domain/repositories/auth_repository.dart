abstract class AuthRepository {
  Future<void> signup(String email, String password);
  Future<bool> login(String email, String password);
}
