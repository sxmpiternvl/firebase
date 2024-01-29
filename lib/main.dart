import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:x/services/screens/add.dart';
import 'package:x/services/screens/homepage.dart';
import 'package:x/services/screens/login_page.dart';
import 'package:x/services/screens/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              initialRoute: '/',
              routes: {
                '/': (context) => const HomePage(),
                'reg': (context) => const SignUpPage(),
                'add': (context) => const Add(),
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
      color: Colors.black,
    );
  }
}
