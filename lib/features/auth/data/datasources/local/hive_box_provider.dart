import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveBoxProvider {
  static const String userBox = 'users';

  static Future<Box<UserModel>> openUserBox() async {
    if (!Hive.isBoxOpen(userBox)) {
      return await Hive.openBox<UserModel>(userBox);
    }
    return Hive.box<UserModel>(userBox);
  }
}
