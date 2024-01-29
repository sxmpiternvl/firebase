import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x/services/screens/edit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var photoURL = FirebaseAuth.instance.currentUser?.photoURL;
  String downloadURL = 'https://static.thenounproject.com/png/4851855-200.png';
  String text = '';
  File? image;
  final imagePicker = ImagePicker();
  final currentUser = FirebaseAuth.instance.currentUser;
  String url = '';

  final picker = ImagePicker();
  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc((FirebaseAuth.instance.currentUser?.uid));

  @override
  Widget build(BuildContext context) {
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      url = data['ProfileImage'];
      print(data['ProfileImage']);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${currentUser?.email}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 5, top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Edit()));
              },
              child: const CircleAvatar(
                radius: 29,
                child: Icon(Icons.person, color: Colors.black, size: 35),
                backgroundColor: Colors.white60,
                // : CircleAvatar(
                //     child: Icon(Icons.person),
                //   ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              '${currentUser?.email?.split('@')[0]}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "${currentUser!.email}",
              style: const TextStyle(color: Colors.white24),
            ),
          )
        ],
      ),
    );
  }
}
