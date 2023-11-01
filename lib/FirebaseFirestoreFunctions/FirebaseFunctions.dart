import 'package:chit_chat/utilits/SharedPrefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chit_chat/model/user.dart';

import '../model/message.dart';

class DatabaseFunctions {



  DatabaseFunctions(){
    db = FirebaseFirestore.instance;
    currentUser = FirebaseAuth.instance.currentUser!;
    currentUserModel = Users(uid: currentUser.uid, name: currentUser.displayName!, imgUrl: SharedPrefs().getImgUrl(), email: currentUser.email!, lastActive: DateTime.now());
  }

  late FirebaseFirestore db;
  late User currentUser;
  late Users currentUserModel;

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
    Map<String,dynamic> json = currentUserModel.toJson();

    db
        .collection(currentUser.uid)
        .doc("ChatUsers")
        .collection("ChatUsers")
        .doc(user.uid)
        .set(user.toJson(),SetOptions(merge:  true));

    db
    .collection(user.uid)
    .doc("ChatUsers")
    .collection("ChatUsers")
    .doc(currentUser.uid)
    .set(json,SetOptions(merge: true));
  }

  Future<List<Users>> getAllUsers() async {
    List<Users> ans = [];
    final snapshot =
        await db.collection("users").orderBy("name", descending: false).get();
    ans = snapshot.docs.map((e) => Users.fromJson(e.data())).toList();
    return ans;
  }
}
