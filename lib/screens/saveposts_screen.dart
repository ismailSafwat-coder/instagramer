import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagramer/providers/like_provider.dart';
import 'package:instagramer/providers/save_provider.dart';

import 'package:provider/provider.dart';

class SavedPageScrean extends StatefulWidget {
  const SavedPageScrean({super.key});

  @override
  State<SavedPageScrean> createState() => _SavedPageScreanState();
}

class _SavedPageScreanState extends State<SavedPageScrean> {
  final bool isliked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('saved', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              String uid = post['uid'];
              String username = post['username'];
              String userphoto = post['userphoto'];
              List<dynamic> likes = post['likes'];
              String postid = post['postid'];
              bool isliked = likes.contains(uid);
              bool saved = post['saved'];

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(userphoto),
                              ),
                            ),
                            Text(username),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.91,
                              padding: const EdgeInsets.only(
                                  left: 25, top: 6, right: 6),
                              child: Text(
                                post['caption'],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                              child: Image(
                            fit: BoxFit.contain,
                            image: NetworkImage(post['postphoto']),
                          )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            colum(
                              likes.length,
                              isliked ? Icons.favorite : Icons.favorite_border,
                              () async {
                                await Provider.of<LikeProvider>(context,
                                        listen: false)
                                    .likepost(uid, postid, likes);
                              },
                            ),
                            colum(0, Icons.flutter_dash, () {}),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await Provider.of<SaveProvider>(context,
                                            listen: false)
                                        .savepost(saved, postid);
                                  },
                                  icon: saved
                                      ? const Icon(Icons.bookmark)
                                      : const Icon(Icons.bookmark_border),
                                ),
                                const Text(
                                  '',
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
              );
            },
          );
        },
      ),
    );
  }

  Widget colum(int number, IconData icon, Function()? onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 30,
          ),
        ),
        const SizedBox(
          height: 0,
        ),
        Text(number.toString(), textScaler: const TextScaler.linear(1))
      ],
    );
  }
}
