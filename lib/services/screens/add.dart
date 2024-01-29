import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  String url = '';
  String text = '';
  File? image;
  final imagePicker = ImagePicker();

  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);

  String? downloadURL;
  Future imagePickerMethod() async {
    //pick image
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        image = File(pick.path);
      } else {
        //show snackbar?
        showSnackBar("No file selected", const Duration(microseconds: 400));
      }
    });
  }

  Future uploadImageMethod() async {
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser?.uid}/images")
        .child("post_$postId");
    await ref.putFile(image!);
    downloadURL = await ref.getDownloadURL();
    //upload url to firestore
    await firebaseFirestore
        .collection("User Posts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("images")
        .add({'downloadURL': downloadURL});
    var currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("User Posts").add({
      'UserEmail': currentUser?.email,
      'Message': text,
      'TimeStamp': Timestamp.now(),
      'Likes': [],
      'imageURL': downloadURL,
      'ProfileImage': url,
    });
  }

  Future postMessage() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("User Posts").add({
      'UserEmail': currentUser?.email,
      'Message': text,
      'TimeStamp': Timestamp.now(),
      'Likes': [],
      'imageURL': 'no',
      'images': downloadURL,
      'ProfileImage': url,
    });
  }

  //snackbar for error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        url = data['ProfileImage'];
        print(
          data['ProfileImage'],
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Отмена")),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              image != null
                  ?
                  // postMessage();
                  uploadImageMethod()
                  : postMessage();
              Navigator.pop(context);
            },
            child: const Text(
              'Опубликовать',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Form(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Что нового?",
                        hintStyle: TextStyle(color: Colors.white24)),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    }),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: image == null
                                ? const Center(child: Text(''))
                                : Image.file(image!))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: const FractionalOffset(0.1, 1.0),
        children: [
          Container(
            height: 40.0,
            color: Colors.white24,
          ),
          GestureDetector(
            onTap: () => imagePickerMethod(),
            child: const Icon(
              Icons.image,
              color: Colors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
