import 'package:chat_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<dynamic> createUserDocument(
      String uid, Map<String, dynamic> userMap) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userMap);
    } catch (error) {
      return error;
    }
  }

  googleSignup() async {
    UserCredential userResult;
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    dynamic userDocument;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userResult = await FirebaseAuth.instance.signInWithCredential(credential);

      userDocument =
          await UserService().fetchCurrentUserData(userResult.user.email);

      await AuthService().createUserDocument(userResult.user.uid, {
        'email': userDocument['email'],
        'profileImage': userDocument['profileImage'],
        'userName': userDocument['userName'],
        'age': userDocument['age'],
      });
    } catch (err) {
      await AuthService().createUserDocument(userResult.user.uid, {
        'userName': _googleSignIn.currentUser.displayName,
        'email': _googleSignIn.currentUser.email,
        'profileImage': _googleSignIn.currentUser.photoUrl,
        'age': '0'
      });
    }
  }
}
