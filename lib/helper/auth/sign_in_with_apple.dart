import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signInWithApple([bool kIsWeb = false]) async {
  final appleProvider = AppleAuthProvider();
  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(appleProvider);
  } else {
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }
}
