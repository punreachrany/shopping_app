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

    return FutureBuilder<bool>(
      future: userProvider.isLoggedIn(), // Check if user is logged in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the connection is waiting, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        }

        // Once the future is complete, check if user is logged in
        if (snapshot.hasData && snapshot.data == true) {
          return NavigationWrapper(); // User is logged in
        } else {
          return const Login(); // User is not logged in
        }
      },
    );
  }
}
