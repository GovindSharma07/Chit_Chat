import 'package:chit_chat/FirebaseFirestoreFunctions/FirebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chit_chat/provider/provider.dart';
import 'package:chit_chat/screens/user_auth.dart';
import 'package:chit_chat/widgets/drawer.dart';
import 'package:chit_chat/widgets/userListTile.dart';

import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    mAuth.authStateChanges().listen((event) => {
          if (event == null)
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const UserAuth()))
            }
        });

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chat App",
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  showSearch(
                      context: context,
                      delegate: customDelegate(
                          await DatabaseFunctions().getAllUsers()));
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            title: const Text("Log Out"),
                            content: const Text(
                                "Do you want to Log Out the account"),
                            actions: [
                              TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  child: const Text("cancel")),
                              TextButton(
                                  onPressed: () => mAuth.signOut(),
                                  child: const Text(
                                    "sure",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          )));
                },
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
        ),
        drawer: Drawer(child: DrawerContent()),
        body: Consumer<FirebaseProvider>(builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.chatUsers.length,
            itemBuilder: (context, index) {
              return UserListTile(value.chatUsers[index], false);
            },
          );
        }));
  }
}

class customDelegate extends SearchDelegate {
  List<Users> allUsers;

  customDelegate(this.allUsers);

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
              .startsWith(query.toLowerCase())) {
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
              .startsWith(query.toLowerCase())) {
            return UserListTile(allUsers[index], true);
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }
}
