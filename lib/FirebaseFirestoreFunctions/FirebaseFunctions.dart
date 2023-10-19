import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chit_chat/model/user.dart';

import '../model/message.dart';

class DatabaseFunctions {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void addMessages(Message message) {
    db
        .collection(message.receiverId)
        .doc("ChatUsers")
        .collection("AllUsersMessages")
        .doc(message.senderId)
        .collection("Messages")
        .add(message.toJson());

    db
        .collection(message.senderId)
        .doc("ChatUsers")
        .collection("AllUsersMessages")
        .doc(message.receiverId)
        .collection("Messages")
        .add(message.toJson());
  }

  void addUser(Users user) {
    db
        .collection(uid)
        .doc("ChatUsers")
        .collection("ChatUsers")
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<List<Users>> getAllUsers() async {
    List<Users> ans = [];
    final snapshot =
        await db.collection("users").orderBy("name", descending: false).get();
    ans = snapshot.docs.map((e) => Users.fromJson(e.data())).toList();
    return ans;
  }
}
