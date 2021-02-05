import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static GoogleAuthCredential getGoolgeCredential({accessToken, idToken}) =>
      GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

  static Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      await FirebaseAuth.instance.signInWithCredential(
        getGoolgeCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken),
      );
      return '';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  static Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return '';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
