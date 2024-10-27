import 'package:flutter/material.dart';

import 'sign_up_info.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Email',
                  style: TextStyle(fontSize: 36),
                ),
                Text(
                  'Registration',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 50),
                _buildTextField(
                  hintText: 'Input your email',
                  isPassword: false,
                  validator: (val) => val!.isEmpty || !val!.contains('@')
                      ? 'Enter a valid email'
                      : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  hintText: 'Input your password',
                  isPassword: true,
                  validator: (val) =>
                      val!.length < 6 ? 'Enter a password 6+ char long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  hintText: 'Input your password again',
                  isPassword: true,
                  validator: (val) =>
                      val != password ? 'Passwords don\'t match!' : null,
                ),
                const SizedBox(height: 25),
                _buildNextButton(),
                const SizedBox(height: 10),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isPassword,
    required String? Function(String?) validator,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        obscureText: isPassword,
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
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
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignUpInfo(email: email, password: password),
            ),
          );
          // if (_formKey.currentState?.validate() ?? false) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           SignUpInfo(email: email, password: password),
          //     ),
          //   );
          // } else {
          //   setState(() {
          //     error = 'Validation Failed: Please put the right information.';
          //   });
          // }
        },
        child: const Text(
          'Next (1/2)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
