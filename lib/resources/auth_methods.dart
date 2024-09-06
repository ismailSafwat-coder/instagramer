import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:instagramer/models/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    String currentuser = _auth.currentUser!.uid;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser)
        .get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String username,
    required String bio,
  }) async {
    String res = 'Some errors occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User newUser = model.User(
          uid: cred.user!.uid,
          email: email,
          username: username,
          bio: bio,
          photoUrl:
              'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1114445501.jpg', // You can set a default profile image URL
          followers: [],
          following: [],
        );

        await _firebaseFirestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());

        return res = 'succeed';
      } else {
        res = 'Please fill in all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'Some errors occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'succeed';
      } else {
        res = 'Please fill in all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
