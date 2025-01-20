// ignore: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:streamzlive/models/user.dart' as model;
import 'package:streamzlive/resources/userprovider.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('user');

  Future<bool> signup(String username, String email, String password,
      BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        model.User user1 = model.User(
          userId: cred.user!.uid,
          username: username,
          email: email,
        );

        await _userRef.doc(cred.user!.uid).set(user1.toMap());

        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(user1); //here the value is set for provider
        }
        res = true;
      }
    } on FirebaseAuthException catch (err) {
      print(err.message);
    }
    return res;
  }
}
