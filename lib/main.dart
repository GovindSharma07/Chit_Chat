import 'package:chit_chat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chit_chat/provider/provider.dart';

import 'package:chit_chat/screens/home_page.dart';
import 'package:chit_chat/screens/user_auth.dart';
import 'package:chit_chat/screens/user_detail.dart';
import 'package:chit_chat/utilits/SharedPrefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: MaterialApp(
        title: "WhatsApp Clone",
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        debugShowCheckedModeBanner: false,
        home: mAuth.currentUser == null ? const UserAuth() : ((mAuth.currentUser?.displayName == null) ? const UserDetail() : const HomePage()) ,
      ),
    );
  }
}
