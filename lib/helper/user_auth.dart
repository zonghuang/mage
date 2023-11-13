import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 注册 (邮箱)
void register(String emailAddress, String password) async {
  /// todo 邮箱检验
  /// ...

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    if (credential.user != null) {
      print("User registered successfully!");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

/// 登录（邮箱）
void signIn(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    if (credential.user != null) {
      print("User registered successfully!");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

/// 退出登录
void signOut() async {
  await FirebaseAuth.instance.signOut();
}

/// 删除用户（邮箱）
void deleteUser(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    if (credential.user != null) {
      final user = credential.user;
      await user?.delete();
      print("User deleted successfully!");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

/// Apple login
// Future<UserCredential> signInWithApple() async {
//   final appleProvider = AppleAuthProvider();
//   if (kIsWeb) {
//     await FirebaseAuth.instance.signInWithPopup(appleProvider);
//   } else {
//     await FirebaseAuth.instance.signInWithProvider(appleProvider);
//   }
// }

/// Google login
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  ).signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  print('googleAuth: $googleAuth');
  print('credential: $credential');

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

/// 匿名进行 Firebase 身份验证
Future signInWithAnonymously() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");

    // 存储用户 uid 和 refreshToken
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userCredential.user?.uid ?? '');
    await prefs.setString(
        'refreshToken', userCredential.user?.refreshToken ?? '');
    // 生成token
    DateTime now = DateTime.now();
    Duration fiveDays = const Duration(days: 5);
    DateTime fiveDaysLater = now.add(fiveDays);
    int timestampInSeconds = fiveDaysLater.millisecondsSinceEpoch ~/ 1000;
    await prefs.setInt('expiration', timestampInSeconds);
    await prefs.setString(
        'token', '${userCredential.user?.uid}_$timestampInSeconds');
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
}

/// convert an anonymous account to a permanent account
/// 将匿名帐号转成永久帐号
Future anonymousTopermanent() async {
  /// 1. 为新的身份验证提供方获取 Credential 对象
  ///
  /// credential 获取方法参考上面
  /// 这里举例 google
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  var idToken = googleAuth?.idToken;

  // Google Sign-in
  final credential = GoogleAuthProvider.credential(idToken: idToken);

  // Email and password sign-in
  // final credential =
  //     EmailAuthProvider.credential(email: emailAddress, password: password);

  // Etc.

  /// 2. 将 Credential 对象传递给登录用户的 linkWithCredential() 方法
  try {
    final userCredential =
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "provider-already-linked":
        print("The provider has already been linked to the user.");
        break;
      case "invalid-credential":
        print("The provider's credential is not valid.");
        break;
      case "credential-already-in-use":
        print("The account corresponding to the credential already exists, "
            "or is already linked to a Firebase User.");
        break;
      // See the API reference for the full list of error codes.
      default:
        print("Unknown error.");
    }
  }
}
