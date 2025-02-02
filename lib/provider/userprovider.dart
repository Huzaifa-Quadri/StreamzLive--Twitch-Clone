import 'package:flutter/material.dart';
import 'package:streamzlive/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(userId: '', username: '', email: '');

  User get user => _user; //getter for accessing private variable('_user')

  setUser(User realUser) {
    _user = realUser;
    notifyListeners();
  }
}
