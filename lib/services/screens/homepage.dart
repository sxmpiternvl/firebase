import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:x/services/screens/add.dart';
import 'package:x/services/screens/login_page.dart';
import 'package:x/services/screens/profile.dart';
import '../../global/command/toast.dart';
import '../../posts/wall_post.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: ,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Image.network(
              'https://media.sketchfab.com/models/8a66de89107f44e2a9524f38d9ed7110/thumbnails/3cdfc6de78e84022936d3af7127a4ecf/79590e616bd349f6b6ee0e19bda3f14e.jpeg',
              width: 100),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Add()));
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy("TimeStamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data?.docs[index];
                      // String url = snapshot.data?.docs[index]['downloadURL'];
                      return WallPost(
                        message: post?['Message'],
                        user: post?['UserEmail'],
                        postId: post!.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                        imageURL:
                            post['imageURL'] != 'no' ? post['imageURL'] : null,
                        ProfileImage: post['ProfileImage'],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.person)),
                  Text('${currentUser?.email}'),
                ],
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                showToast(message: "SingOut");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
