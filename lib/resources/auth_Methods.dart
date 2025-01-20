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

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    // helpful is persisting state
    //* to get details of Current User just by passing uid of user */
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

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

  Future<bool> logInUser(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (ctx.mounted) {
        Provider.of<UserProvider>(ctx, listen: false).setUser(
          model.User.fromMap(await getCurrentUser(cred.user!.uid) ??
              {}), //to pass value to provider or setting user in provider
          /*
        ?  The getCurrentUser function retrieves the user’s details stored in Firebase Firestore by fetching a document with the user’s UID.
        ?  The uid is extracted from the UserCredential object (cred.user!.uid).
     *     How It Works:  The function uses await _userRef.doc(uid).get() to get the document snapshot corresponding to the UID.
              If the document exists, snap.data() returns a Map<String, dynamic> containing the user’s data. Otherwise, null is returned.
              '??' is used as ensure that if getCurrentUser returns null, an empty map {} is passed instead of causing a null error.
          */
        );
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      res = false;
    }
    return res;
  }
}
