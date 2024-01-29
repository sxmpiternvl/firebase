import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:x/posts/like_button.dart';
import 'package:x/services/screens/postscreen.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String? imageURL;
  final String? ProfileImage;

  WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    this.imageURL,
    this.ProfileImage,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  String url = '';
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update(
        {
          'Likes': FieldValue.arrayUnion([currentUser.email]),
        },
      );
    } else {
      postRef.update(
        {
          'Likes': FieldValue.arrayRemove(
            [currentUser.email],
          ),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget placeholder = const Center(
      child: Icon(Icons.person, size: 50), // Placeholder icon
    );

    late Widget avatar;

    if (widget.ProfileImage != null) {
      avatar = Image.network(
        widget.ProfileImage!,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder;
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          // print(exception);
          return const Icon(Icons.error); // Icon to display in case of an error
        },
      );
    } else {
      avatar = placeholder;
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  shape: BoxShape.rectangle,
                  color: Colors.grey[400],
                  border: Border.all(width: 10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: avatar,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostScreen(
                          user: widget.user,
                          message: widget.message,
                          postId: widget.postId,
                          imageURL: widget.imageURL,
                          ProfileImage: avatar,
                          likes: widget.likes.length,
                          isLiked: isLiked,
                        ),
                      ),
                    );
                  },
                  child: Column(
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
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        ),
                      ),
                      widget.imageURL != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  widget.imageURL!,
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 60, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white70,
                        )),
                    const Text(
                      '999',
                      style: TextStyle(color: Colors.white70),
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
                    const Text(
                      '999',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                Row(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      onTap: toggleLike,
                    ),
                    Text(
                      widget.likes.length.toString(),
                      style: const TextStyle(color: Colors.white),
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
                    const Text(
                      '999',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
