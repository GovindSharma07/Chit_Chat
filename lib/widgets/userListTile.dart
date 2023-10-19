import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chit_chat/FirebaseFirestoreFunctions/FirebaseFunctions.dart';

import '../model/user.dart';
import '../screens/chatScreen.dart';

class UserListTile extends StatelessWidget {
  const UserListTile(this.user, this.isAdd, {super.key});

  final Users user;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text("Last Active: ${timeago.format(user.lastActive)}"),
      leading: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: user.imgUrl,
        imageBuilder: (context, url) {
          return CircleAvatar(
            foregroundImage: url,
          );
        },
      ),
      onTap: () {
        if (isAdd) {
          DatabaseFunctions().addUser(user);
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(user: user)));
      },
    );
  }
}
