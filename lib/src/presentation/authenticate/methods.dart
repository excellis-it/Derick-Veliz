import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cpscom/src/utils/messgaetoast.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "status": "Unavalible",
      "uid": _auth.currentUser!.uid,
      "isAdmin": true
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
    // } on FirebaseAuthException catch (e) {
    //   print("Test???" + e.code);
    //   showToastMessage(e.code);
    // }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'network-request-failed') {
      showToastMessage('No Internet Connection');
      //devtools.log('No Internet Connection');
    } else if (e.code == "wrong-password") {
      showToastMessage('Please Enter correct password');
    } else if (e.code == 'user-not-found') {
      showToastMessage('Email not found');
      // print('Email not found');
    } else if (e.code == 'too-many-requests') {
      showToastMessage('Too many attempts please try later');
      //print('Too many attempts please try later');
    } else if (e.code == 'unknwon') {
      showToastMessage('Email and password field are required');
      //print('Email and password field are required');
    } else if (e.code == 'unknown') {
      showToastMessage('Email and Password Fields are required');
      //print(e.code);
    } else {
      print(e.code);
    }
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  } catch (e) {
    print("error");
  }
}
