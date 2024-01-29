// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:x/services/models/posts.dart';
//
// class PostService {
//   List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return PostModel(
//         id: doc.id,
//         text: doc['text'] ?? '',
//         creator: doc['creator'] ?? '',
//         timestamp: doc['timestamp'] ?? 0,
//       );
//     }).toList();
//   }
//
//   Future savePost(text) async {
//     await FirebaseFirestore.instance.collection("posts").add({
//       'text': text,
//       'creator': FirebaseAuth.instance.currentUser?.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   Stream<List<PostModel>> getPostsByUser(uid) {
//     return FirebaseFirestore.instance
//         .collection("posts")
//         .where('creator', isEqualTo: uid)
//         .snapshots()
//         .map(_postListFromSnapshot);
//   }
// }
