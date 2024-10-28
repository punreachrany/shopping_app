import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/authentication/sign_up.dart';
import 'package:shopping_app/screens/navigation_wrapper.dart';
import 'package:shopping_app/services/auth_service.dart';
import 'package:shopping_app/services/user_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();
      String? jwt = await authService.loginUser(email, password);

      if (jwt != null) {
        // If JWT is obtained, update the UserProvider
        Provider.of<UserProvider>(context, listen: false).login(email,
            password); // You may want to modify this line based on how you implement login in UserProvider

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Login successful!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NavigationWrapper()), // Navigate to your main app page
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If login fails
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: const Text('Invalid email or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2980b9),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Center(
                      child: Text(
                        "SUSU Shopping",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: const Center(
                      child: Text(
                        "Anything from Anywhere",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            transform: Matrix4.translationValues(0, 250, 1),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: const Text(
                        "Login to Continue",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        validator: (val) =>
                            (val == null || val.isEmpty || !val.contains('@'))
                                ? 'Enter a valid email'
                                : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        validator: (val) => (val == null || val.length < 5)
                            ? 'Enter a password 5+ characters long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: const Color(0xFF2980b9),
                          padding: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: const Color(0xFF2980b9),
                          padding: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
