import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:x/services/models/comments.dart';
import '../../posts/like_button.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String message;
  final String user;
  final String? imageURL;
  final Widget? ProfileImage;
  bool isLiked;
  int likes;

  PostScreen({
    super.key,
    required this.postId,
    required this.message,
    required this.user,
    this.imageURL,
    this.ProfileImage,
    required this.likes,
    required this.isLiked,
  });

  @override
  State<PostScreen> createState() =>
      _PostScreenState(postId, message, user, imageURL);
}

//

//

class _PostScreenState extends State<PostScreen> {
  final TextEditingController commentController = TextEditingController();
  //
  void toggleLike() {
    setState(() {
      widget.isLiked = !widget.isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (widget.isLiked) {
      postRef.update(
        {
          'Likes':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.email]),
        },
      );
    } else {
      postRef.update(
        {
          'Likes': FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser?.email],
          ),
        },
      );
    }
  }

  //
  final String? postId;
  final String? user;
  final String? message;
  final String? imageURL;
  String text = '';
  _PostScreenState(this.postId, this.user, this.message, this.imageURL);
  @override
  Widget build(BuildContext context) {
    String? url = '';
    imageURL != null
        ? url = imageURL
        : url =
            'https://media.sketchfab.com/models/8a66de89107f44e2a9524f38d9ed7110/thumbnails/3cdfc6de78e84022936d3af7127a4ecf/79590e616bd349f6b6ee0e19bda3f14e.jpeg';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Пост",
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black12,
                            child: widget.ProfileImage,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(widget.user,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                          Container(
                            child: imageURL != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        url!,
                                        width: 320,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 60, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: toggleLike,
                                      icon: const Icon(
                                        Icons.message,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.repeat,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    LikeButton(
                                      isLiked: widget.isLiked,
                                      onTap: toggleLike,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.query_stats),
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Комментарии',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Comments(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Comment",
                          hintStyle: TextStyle(color: Colors.white24)),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      }),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Ответить'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
