import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return GroupChatHomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
