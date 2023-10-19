import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/model/user.dart';


class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  List<Users> chatUsers = [];


  void getChatUsers() {
    FirebaseFirestore.instance
        .collection(mAuth.currentUser!.uid)
        .doc("ChatUsers")
        .collection("ChatUsers")
        .orderBy("lastActive", descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((chatUsers) {
      this.chatUsers =
          chatUsers.docs.map((doc) => Users.fromJson(doc.data())).toList();
      notifyListeners();
    });
  }

 }
