import 'package:firebase_auth/firebase_auth.dart';

/// 注册 (邮箱)
Future<UserCredential?> createUserWithEmail(
    String emailAddress, String password) async {
  /// todo 邮箱检验
  /// ...

  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    if (userCredential.user != null) {
      print("User registered successfully!");
    }
    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
