import 'package:firebase_auth/firebase_auth.dart';

/// 创建匿名账号（匿名进行 Firebase 身份验证）
Future<UserCredential> signInWithAnonymously() async {
  final userCredential = await FirebaseAuth.instance.signInAnonymously();
  print("Signed in with temporary account.");
  return userCredential;
}
