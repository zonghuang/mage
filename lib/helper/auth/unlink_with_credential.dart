import 'package:firebase_auth/firebase_auth.dart';

/// 取消身份验证提供方与用户帐号的关联
/// providerId 可以从 User 对象的 providerData 属性中获取与用户相关联的身份验证提供方的 ID
Future<bool> unlinkWithCredential(String providerId) async {
  try {
    await FirebaseAuth.instance.currentUser?.unlink(providerId);
    return true;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "no-such-provider":
        print("The user isn't linked to the provider or the provider "
            "doesn't exist.");
        break;
      default:
        print("Unkown error.");
    }
    return false;
  }
}
