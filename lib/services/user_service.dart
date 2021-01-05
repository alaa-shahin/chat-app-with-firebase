import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<dynamic> updateUserData(
      String _newUserName,
      String _newAge,
      String currentUserName,
      String currentUserAge,
      String uid,
      String newProfileImage,
      String userEmail) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userName': (_newUserName == null) ? currentUserName : _newUserName,
        'age': (_newAge == null) ? currentUserAge : _newAge,
        'email': userEmail,
        'profileImage': newProfileImage,
      });
    } catch (e) {
      return e;
    }
  }

  fetchCurrentUserData(String currentUserEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs[0].data();
    }).catchError((onError) {
      print("Error getting documents: $onError");
      return onError;
    });
  }
}
