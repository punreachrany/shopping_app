import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/landing/landing.dart';
import 'package:shopping_app/screens/navigation_wrapper.dart';
import 'package:shopping_app/services/auth_service.dart';
import 'package:shopping_app/services/user_provider.dart'; // Import your AuthService

class SignUpInfo extends StatefulWidget {
  final String email;
  final String password;

  SignUpInfo({required this.email, required this.password});

  @override
  _SignUpInfoState createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  DateTime? pickedDate;

  // text field state
  String? name;
  String? gender;
  String error = '';
  bool checkBoxValue = false;

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        pickedDate = date; // Update pickedDate only if date is not null
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && checkBoxValue) {
      setState(() {
        loading = true; // Start loading
      });

      final authService = AuthService();
      String? jwt = await authService.registerUser(
        name!,
        widget.email,
        widget.password,
        "1997-09-30",
        gender!,
      );

      setState(() {
        loading = false; // Stop loading
      });

      if (jwt != null) {
        // If registration is successful, update UserProvider
        Provider.of<UserProvider>(context, listen: false)
            .login(widget.email, widget.password);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Registration successful!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).popUntil((route) =>
                        route.isFirst); // Pop all screens until the first
                    // Now in the Login Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationWrapper(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If registration fails, show error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: const Text('Registration failed. Please try again.'),
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
    } else if (!checkBoxValue) {
      setState(() {
        error = 'You must accept the terms and conditions.';
      });
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 36),
                ),
                const Text(
                  'Registration',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 50),
                _buildTextField("Name", (val) => name = val),
                _buildTextField("Gender", (val) => gender = val),
                _buildDateField(),
                _buildTermsAndConditions(),
                const SizedBox(height: 25),
                _buildNextButton(),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
        ),
        validator: (val) => val!.isEmpty ? 'Input Your $label' : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5.0),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Text("Birthday",
                style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              onTap: _pickDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    pickedDate != null
                        ? "${pickedDate!.year}. ${pickedDate!.month}. ${pickedDate!.day}"
                        : "YYYY. MM. DD",
                    style: TextStyle(
                        color: pickedDate != null
                            ? Colors.black
                            : Colors.grey[600],
                        fontSize: 18),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: checkBoxValue,
          activeColor: const Color(0xFF2980b9),
          onChanged: (bool? newValue) {
            setState(() {
              checkBoxValue = newValue!;
            });
          },
        ),
        const Expanded(
          child: Text(
            'I accept the terms and policies of this Susu Concert Application.',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ],
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
        onPressed: loading ? null : _register, // Disable button while loading
        child: loading
            ? const CircularProgressIndicator() // Show loading indicator
            : const Text(
                'Complete (2/2)',
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
