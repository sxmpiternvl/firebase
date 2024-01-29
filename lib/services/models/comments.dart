import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

Future postMessage() async {
  String text = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection("User Posts").add({
    'UserEmail': currentUser?.email,
    'Message': text,
    'TimeStamp': Timestamp.now(),
  });
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            'qwe',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
