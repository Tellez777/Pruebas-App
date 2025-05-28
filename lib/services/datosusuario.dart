import 'package:flutter/material.dart';

class Datosusuario with ChangeNotifier {
  String? _email;
  String? _username;

  String? get email => _email;
  String? get username => _username;

  void setUser(String email, String username) {
    _email = email;
    _username = username;
    notifyListeners();
  }

  void clearUser() {
    _email = null;
    _username = null;
    notifyListeners();
  }
}