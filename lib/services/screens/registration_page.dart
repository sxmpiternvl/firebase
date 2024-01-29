import 'package:flutter/material.dart';
import 'package:x/services/screens/homepage.dart';
import 'package:x/services/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x/src/firebase_auth_i/firebase_auth_services.dart';
import 'package:x/src/widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://media.sketchfab.com/models/8a66de89107f44e2a9524f38d9ed7110/thumbnails/3cdfc6de78e84022936d3af7127a4ecf/79590e616bd349f6b6ee0e19bda3f14e.jpeg',
            width: 100),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Text("Создайте учетную запись"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: FormContainerWidget(
                    controller: _emailController,
                    hintText: "Email",
                    isPasswordField: false,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: FormContainerWidget(
                    controller: _password1Controller,
                    hintText: "Repeat password",
                    isPasswordField: true,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      if (_passwordController.text ==
                          _password1Controller.text) {
                        _auth.signUpWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const HomePage(),
                        //   ),
                        // );
                      } else {}
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "SignIn",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    Navigator.pop(context);

    User? us = await _auth.signInWithEmailAndPassword(email, password);
    // Future<dynamic> userCredential =
    //     (await _auth.signUpWithEmailAndPassword(email, password));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
