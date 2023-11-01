import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../widgets/userListTile.dart';

class CustomDelegate extends SearchDelegate {
  List<Users> allUsers;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  CustomDelegate(this.allUsers);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.keyboard_backspace));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          return UserListTile(allUsers[index], true);
        },
      );
    } else {
      return ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          if (allUsers[index]
              .name
              .toLowerCase()
              .startsWith(query.toLowerCase())
              &&
              allUsers[index].uid != uid) {
            return UserListTile(allUsers[index], true);
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          return UserListTile(allUsers[index], true);
        },
      );
    } else {
      return ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          if (allUsers[index]
              .name
              .toLowerCase()
              .startsWith(query.toLowerCase())
              &&
              allUsers[index].uid != uid) {
            return UserListTile(allUsers[index], true);
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }
}
