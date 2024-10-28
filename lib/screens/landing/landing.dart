import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/user.dart';
import 'package:shopping_app/screens/authentication/login.dart';
import 'package:shopping_app/screens/navigation_wrapper.dart';

class Landing extends StatelessWidget {
  // User _user;

  @override
  Widget build(BuildContext context) {
    final user =
        User(name: "punreach", email: "punreach", password: "punreach");
    if (user == null) {
      print("NO User");
      return Login();
      // return LoginTesting();
    } else {
      print("Have a user logged in");
      return NavigationWrapper();
    }
  }
}
