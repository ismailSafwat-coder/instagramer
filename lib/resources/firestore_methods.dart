import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final currentuserid = FirebaseAuth.instance.currentUser!.uid;
  final _firebaseFirestore = FirebaseFirestore.instance;
  final postid = const Uuid().v1();
  final commentid = const Uuid().v1();

  Future uploadPost(
      String userphoto, String caption, String username, String posturl) async {
    await _firebaseFirestore.collection('posts').doc(postid).set(
      {
        "username": username,
        "userphoto": userphoto,
        "uid": currentuserid,
        "caption": caption,
        "date": DateTime.now(),
        "likes": [],
        'postphoto': posturl,
        'postid': postid,
        'saved': false
      },
    );
  }

  Future addcomment(
      String postid, String username, String userphoto, String caption) async {
    await _firebaseFirestore
        .collection('posts')
        .doc(postid)
        .collection('comments')
        .doc(commentid)
        .set({
      "username": username,
      "userphoto": userphoto,
      "uid": currentuserid,
      "caption": caption,
      "date": DateTime.now(),
      "likes": [],
      'commentid': commentid,
    });
  }

  Future likecomment(
      String postid, String commentid, String userid, List likes) async {
    if (likes.contains(userid)) {
      await _firebaseFirestore
          .collection('posts')
          .doc(postid)
          .collection('comments')
          .doc(commentid)
          .update({
        'likes': FieldValue.arrayRemove([userid])
      });
    } else {
      _firebaseFirestore
          .collection('posts')
          .doc(postid)
          .collection('comments')
          .doc(commentid)
          .update({
        'likes': FieldValue.arrayUnion([userid])
      });
    }
  }

  Future follow(String uid, String followingId) async {
    try {
      var doc = await _firebaseFirestore.collection('users').doc(uid).get();
      var userdata = doc.data()!;
      List following = userdata['following'];
      if (following.contains(uid)) {
        await _firebaseFirestore.collection('users').doc(followingId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followingId])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followingId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followingId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
