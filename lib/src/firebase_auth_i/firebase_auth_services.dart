import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:x/services/screens/homepage.dart';

import '../../global/command/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // UserModel? _userFromFirebaseUser(User user) {
  //   return user != null ? UserModel(id: user.uid) : null;
  // }
  //
  // Stream<UserModel?> get user {
  //   return auth.authStateChanges().map((user) => _userFromFirebaseUser(user!));
  // }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user?.uid)
          .set({'email': email, 'ProfileImage': ''});

      // _userFromFirebaseUser(user as User);
      if (user != null) {
        await const Navigator(
          initialRoute: '/',
        );
        // navigatorKey.currentState?.pushNamed('/');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));
      // _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
  }
}
