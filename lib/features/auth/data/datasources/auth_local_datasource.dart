import '../models/user_model.dart';
import 'hive_box_provider.dart';

class AuthLocalDatasource {
  // SIGNUP
  Future<void> signup(String email, String password) async {
    final box = await HiveBoxProvider.openUserBox();

    if (box.containsKey(email)) {
      throw Exception('User already exists');
    }

    final user = UserModel(email: email, password: password);
    await box.put(email, user);
  }

  // LOGIN
  Future<bool> login(String email, String password) async {
    final box = await HiveBoxProvider.openUserBox();

    if (!box.containsKey(email)) return false;

    final user = box.get(email);
    return user?.password == password;
  }
}
