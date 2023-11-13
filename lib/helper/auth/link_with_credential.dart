import 'package:firebase_auth/firebase_auth.dart';
import 'package:mage/helper/auth/create_user_with_email.dart';
import 'package:mage/helper/auth/sign_in_with_google.dart';

Future<bool> linkWithCredential(
    String provider, Map<String, dynamic> options) async {
  try {
    late AuthCredential credential;

    switch (provider) {
      case 'email':
        var email = options['email'];
        var password = options['password'];
        await createUserWithEmail(email, password);
        credential =
            EmailAuthProvider.credential(email: email, password: password);
        break;

      case 'google':
        final googleAuth = await getGoogleAuth();
        credential =
            GoogleAuthProvider.credential(idToken: googleAuth?.idToken);
        break;
      default:
    }

    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

    return true;
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
    return false;
  }
}
