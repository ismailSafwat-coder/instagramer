import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final currentuserid = FirebaseAuth.instance.currentUser!.uid;
  final imageid = const Uuid().v1();
  final _storage = FirebaseStorage.instance.ref();
  Future uploadimage<String>(File? image) async {
    final uploadimage = await _storage
        .child('posts')
        .child(currentuserid)
        .child(imageid)
        .putFile(image!);

    final imageUrl = await _storage
        .child('posts')
        .child(currentuserid)
        .child(imageid)
        .getDownloadURL();

    return imageUrl;
  }
}
