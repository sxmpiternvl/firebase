import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x/services/screens/homepage.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  String profileImage = '';
  var photoURL = FirebaseAuth.instance.currentUser?.photoURL;
  String downloadURL = 'https://static.thenounproject.com/png/4851855-200.png';
  String text = '';
  File? image;
  final imagePicker = ImagePicker();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future imagePickerMethod() async {
    //pick image
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        image = File(pick.path);
      }
    });
  }

  Future uploadProfileImageMethod() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser?.uid}/ProfileImage")
        .child("profileimage");
    await ref.putFile(image!);
    downloadURL = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .update({'ProfileImage': downloadURL});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            'https://media.sketchfab.com/models/8a66de89107f44e2a9524f38d9ed7110/thumbnails/3cdfc6de78e84022936d3af7127a4ecf/79590e616bd349f6b6ee0e19bda3f14e.jpeg',
            width: 100),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Text(
                "Выберите изображения профиля",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Text(
              "Загрузите свое лучшее селфи",
              style: TextStyle(color: Colors.white30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Center(
              child: GestureDetector(
                onTap: imagePickerMethod,
                child: image == null
                    ? CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 50,
                        child: Image.network(
                          'https://www.vhv.rs/dpng/f/408-4087347_user-login-man-human-body-mobile-person-comments.png',
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 50,
                          child: Image.file(image!),
                          backgroundColor: Colors.black12,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: TextButton(
        onPressed: uploadProfileImageMethod,
        child: const Text(
          "Далее",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
