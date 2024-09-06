import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userdataprovider with ChangeNotifier {
  Future providertest() async {
    var currentUserid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserid)
        .get();
    var user = snap.data() as Map<String, dynamic>;
    notifyListeners();
    return user;
  }
}
