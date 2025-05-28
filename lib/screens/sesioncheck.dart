import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriginalapp/screens/iniciarsesion.dart';
import 'package:theoriginalapp/screens/inicio.dart';


class SessionCheckScreen extends StatelessWidget {
  const SessionCheckScreen({Key? key}) : super(key: key);

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.data == true) {
            return Inicio();
          } else {
            return  LoginScreen();
          }
        }
      },
    );
  }
}
