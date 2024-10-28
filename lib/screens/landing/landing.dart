import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/authentication/login.dart';
import 'package:shopping_app/screens/navigation_wrapper.dart';
import 'package:shopping_app/services/user_provider.dart'; // Adjust the import based on your folder structure

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return user == null ? const Login() : NavigationWrapper();
  }
}
