import 'package:firebase_auth/firebase_auth.dart';

/// 删除用户（邮箱）
Future<bool> deleteUser(UserCredential userCredential) async {
  if (userCredential.user != null) {
    await userCredential.user?.delete();
    print("User deleted successfully!");
    return true;
  }
  return false;
}
