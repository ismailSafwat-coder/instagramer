import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramer/resources/firestore_methods.dart';

class ProfileScrean extends StatefulWidget {
  final uid;
  const ProfileScrean({super.key, required this.uid});

  @override
  State<ProfileScrean> createState() => _ProfileScreanState();
}

class _ProfileScreanState extends State<ProfileScrean> {
  var userinformation;
  bool isloadinguserinformation = false;
  int numberofposts = 0;
  bool isfollowed = false;
  List followers = [];
  List following = [];
  loaduserdata() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var docposts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      setState(() {
        if (docposts.size == 0) {
          numberofposts = 0;
        }
        numberofposts = docposts.size;
        userinformation = doc;
        isfollowed = (userinformation['followers'] as List)
            .contains(FirebaseAuth.instance.currentUser!.uid);

        List followers = (userinformation['followers']);
        List following = (userinformation['following']);

        isloadinguserinformation = true;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isloadinguserinformation = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('username'),
      ),
      body: userinformation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(isloadinguserinformation
                            ? userinformation['photoUrl']
                            : 'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                profileColumn(numberofposts, 'posts'),
                                profileColumn(followers.length, 'followers'),
                                profileColumn(following.length, 'following'),
                              ],
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('edit profiel'))
                                : isfollowed
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          await FirestoreMethods().follow(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.uid);
                                          await loaduserdata();
                                          setState(() {
                                            isfollowed = false;
                                          });
                                        },
                                        child: const Text('unfollow'),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await FirestoreMethods().follow(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.uid);
                                          await loaduserdata();
                                          setState(() {
                                            isfollowed = true;
                                          });
                                        },
                                        child: const Text('follow'),
                                      )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('no posts'),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: GridView.builder(
                        // shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var userposts = snapshot.data!.docs[index];

                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  userposts['postphoto'],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }

  Widget profileColumn(int count, String text) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 17),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 22,
          ),
        )
      ],
    );
  }
}
