import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveProvider with ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future savepost(bool save, String postid) async {
    if (save) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postid)
          .update({"saved": false});
    } else {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postid)
          .update({"saved": true});
    }
  }
}
