// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:x/services/models/posts.dart';
//
// class ListPosts extends StatefulWidget {
//   const ListPosts({super.key});
//
//   @override
//   State<ListPosts> createState() => _ListPostsState();
// }
//
// class _ListPostsState extends State<ListPosts> {
//   @override
//   Widget build(BuildContext context) {
//     final posts = Provider.of<List<PostModel>>(context) ?? [];
//     return ListView.builder(
//       itemCount: posts.length,
//       itemBuilder: (context, index) {
//         final post = posts[index];
//         return ListTile(
//           title: Text(post.creator),
//           subtitle: Text(post.text),
//         );
//       },
//     );
//   }
// }
