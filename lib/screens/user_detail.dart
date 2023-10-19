import "dart:io";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/fuctions.dart';
import 'package:chit_chat/model/user.dart';
import 'package:chit_chat/screens/home_page.dart';
import 'package:chit_chat/screens/user_auth.dart';
import 'package:chit_chat/utilits/SharedPrefs.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  PlatformFile? pickedFile;
  File? file;
  String? name;
  String? error;
  String? imgUrl;
  bool progress = false;
  final SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  Widget build(BuildContext context) {
    mAuth.authStateChanges().listen((event) {
      if (event == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const UserAuth()));
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Enter Your Detail"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () => pickFile(),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: (pickedFile == null)
                              ? const AssetImage("assets/images/user.png")
                              : FileImage(file!) as ImageProvider<Object>,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: const InputDecoration(
                          hintText: "Your Name", border: OutlineInputBorder()),
                    ),
                    Text(error ?? "",
                        style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                        onPressed: () => uploadDetails(),
                        child: const Text("Save"))
                  ],
                ),
              ),
            ),
          ),
          if(progress)
            Positioned.fill(child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ))

        ]),
      ),
    );
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
        file = File(pickedFile!.path!);
      });
    }
  }

  uploadDetails() async {
    setState(() {
      progress = true;
    });
    try {
      if (name != null) {
        await mAuth.currentUser?.updateDisplayName(name);
        try {
          final userStorageRef =
          storage.ref().child("users_img/${mAuth.currentUser?.uid}");
          await userStorageRef
              .putFile(file ?? await getImgFileFromAssets("images/user.png"));
          imgUrl = await userStorageRef.getDownloadURL();
        } catch (e) {
          error = e.toString();
          setState(() {
            progress = false;
            error = e.toString();
          });
          throw e;
        }
        Users user = Users(
            name: mAuth.currentUser!.displayName!,
            uid: mAuth.currentUser!.uid,
            imgUrl: imgUrl!,
            email: mAuth.currentUser!.email!,
            lastActive: DateTime.now());
        await db
            .collection("users")
            .doc(mAuth.currentUser?.uid)
            .set(user.toJson());

        await _sharedPrefs
            .setUserName(mAuth.currentUser?.displayName ?? "User Name");
        await _sharedPrefs.setImgUrl(imgUrl ??
            "https://firebasestorage.googleapis.com/v0/b/my-chat-fa34b.appspot.com/o/users_img%2FA3zdG848iydlZjZULkL6miaQAD03?alt=media&token=7cd722e7-3120-4aa8-aeb0-ff374273505e&_gl=1*1uc3uz2*_ga*MTgzMTcyMjU5Mi4xNjgwNTI2MzQ2*_ga_CW55HF8NVT*MTY5Njc1MjA3NC40MC4xLjE2OTY3NTIxMTAuMjQuMC4w");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        progress = false;
      });
      throw e;
    };
  }
}
