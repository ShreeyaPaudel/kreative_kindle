import 'package:hive/hive.dart';
import '../../models/user_model.dart';
import 'hive_box_provider.dart';

class AuthLocalDatasource {
  Future<void> signup(String email, String password) async {
    final box = await HiveBoxProvider.openUserBox();

    // already exists check
    if (box.containsKey(email)) {
      throw Exception("User already exists");
    }

    final user = UserModel(email: email, password: password);

    await box.put(email, user); // ✅ THIS WAS MISSING
  }

  Future<bool> login(String email, String password) async {
    final box = await HiveBoxProvider.openUserBox();

    if (!box.containsKey(email)) return false;

    final user = box.get(email) as UserModel;
    return user.password == password;
  }
}
