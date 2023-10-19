import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {

  bool process = false;

  String? email;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 20),
        child:Column(
          children: [
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_reset_outlined),
                border:  OutlineInputBorder()
              ),
            ),
            ElevatedButton(onPressed: () => forget(),
                child: process? const Center(child: CircularProgressIndicator(color: Colors.white,)) : const Text("Reset Password"))
          ],
        )
      ),
    );
  }

  forget() async{
    setState(() {
      process = true;
    });
    if (email != null) {

        await mAuth.sendPasswordResetEmail(
            email: email ?? "Govindsharma97037@gmail.com").then(
            (value){
              setState(() {
                process = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password Reset Link Send To Your Email Id ")));
            }
        ).catchError((onError){
              setState(() {
                process =false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
              return;
        });

      }
    else{
      setState(() {
        process =false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter the Email First")));
    }
  }
}
