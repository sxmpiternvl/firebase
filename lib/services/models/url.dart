import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Url {
  String url = '';
  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);
  Future urlPicker() async {
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        url = data['ProfileImage'];
        print(
          data['ProfileImage'],
        );
      },
    );
    return url;
  }
}
