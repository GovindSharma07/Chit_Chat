import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chit_chat/screens/forgot.dart';
import 'package:chit_chat/screens/user_detail.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuth();
}

class _UserAuth extends State<UserAuth> {
  //for showing any error during the login or sign up
  String errorString = "";
  bool isObscure = true;
  bool progress = false;

//for firebase authentication
  final FirebaseAuth mAuth = FirebaseAuth.instance;

//for extracting the text from the text fields
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  //storing user credentials after sign up or login
  UserCredential? cred;

  //for disposing controller variable after use to not make them change or affect the program
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mAuth.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserDetail()));
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
                "Login",
              )),
        ),
        body: Stack(
            children: [
        Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              errorString,
              style: const TextStyle(color: Colors.red, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: "Your Email Id",
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  obscureText: isObscure,
                  obscuringCharacter: "*",
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 3),
                    prefixIcon: const Icon(
                      Icons.key_outlined,
                      color: Colors.green,
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            isObscure = false;
                          });
                          Timer(const Duration(seconds: 3), () {
                            setState(() {
                              isObscure = true;
                            });
                          });
                        }),
                    border: const OutlineInputBorder(),
                  )),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const forgot()));
                  },
                  child: const Text(
                    "Password Reset?",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => signUP(),
                    child: const Text(
                      "Register",
                    )),
                ElevatedButton(
                    onPressed: () => login(),
                    child: const Text(
                      "Log In",
                    ))
              ],
            )
          ],
        ),
        ),
              if (progress)
                Positioned.fill(

                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),],
    )
    ,
    );
  }

  login() async {
    setState(() {
      progress = true;
    });
    String email = _email.text.toString();
    String password = _password.text.toString();
    if (email.isEmpty) {
      errorString = "Email is Empty";
      setState(() {
        removeErrorMessage();
      });
    } else if (password.isEmpty) {
      errorString = "Password is  Empty";
      setState(() {
        removeErrorMessage();
      });
    } else {
      try {
        cred = await mAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          errorString = "User Not Found";
          setState(() {
            removeErrorMessage();
          });
        } else if (e.code == "wrong-password") {
          errorString = "You have enter the wrong password or wrong user name";
          setState(() {
            removeErrorMessage();
          });
        }
      } catch (e) {
        errorString = e.toString();
        setState(() {
          removeErrorMessage();
        });
        throw e;
      }
    }
  }

  signUP() async {
    progress = true;
    String email = _email.text.toString();
    String password = _password.text.toString();
    if (email.isEmpty) {
      errorString = "Email is Empty";
      setState(() {
        removeErrorMessage();
      });
    } else if (password.isEmpty) {
      errorString = "Password is  Empty";
      setState(() {
        removeErrorMessage();
      });
    } else {
      try {
        cred = await mAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          errorString = "User Already Exist";
          setState(() {});
          setState(() {
            removeErrorMessage();
          });
        } else if (e.code == "weak-password") {
          errorString = "Enter  password is too weak";
          setState(() {});
          setState(() {
            removeErrorMessage();
          });
        }
      } catch (e) {
        errorString = e.toString();
        setState(() {
          removeErrorMessage();
        });
      }
    }
  }

//for removing error message after some duration
  void removeErrorMessage() {
    setState(() {
      progress = false;
    });
    Timer(const Duration(seconds: 3), () {
      errorString = "";
      setState(() {});
    });
  }
}
