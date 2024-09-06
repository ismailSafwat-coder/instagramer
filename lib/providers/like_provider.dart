import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class LikeProvider with ChangeNotifier {
  Future likepost(String userid, String postid, List likes) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    if (likes.contains(userid)) {
      await firebaseFirestore.collection('posts').doc(postid).update({
        "likes": FieldValue.arrayRemove([userid])
      });
    } else {
      await firebaseFirestore.collection('posts').doc(postid).update({
        "likes": FieldValue.arrayUnion([userid])
      });
    }
  }
}
