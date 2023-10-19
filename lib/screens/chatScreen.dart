import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/FirebaseFirestoreFunctions/FirebaseFunctions.dart';
import 'package:chit_chat/model/user.dart';
import 'package:chit_chat/widgets/messageBubble.dart';

import '../model/message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.user});

  final ScrollController _scrollController = ScrollController();
  final Users user;

  final TextEditingController controller = TextEditingController();

  final FocusNode myFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/playstore.png"))),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44,
                  margin: const EdgeInsets.only(right: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl: user.imgUrl),
                ),
                Text(user.name)
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(FirebaseAuth.instance.currentUser!.uid)
                        .doc("ChatUsers")
                        .collection("AllUsersMessages")
                        .doc(user.uid)
                        .collection("Messages")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        // Scroll to the end when new data arrives
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              Message message = Message.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              return MessageBubble(
                                message: message,
                                isMe: FirebaseAuth.instance.currentUser!.uid ==
                                    message.senderId,
                              );
                            });
                      }
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: TextField(
                    controller: controller,
                    focusNode: myFocus,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (controller.value.toString().isNotEmpty) {
                              Message message = Message(
                                  content: controller.value.text,
                                  senderId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  receiverId: user.uid,
                                  time: DateTime.now());
                              DatabaseFunctions().addMessages(message);
                              controller.clear();
                              myFocus.unfocus();
                            }
                          },
                        ),
                        filled: true,
                        hintText: "Message",
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        )),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
