import 'package:flutter/material.dart';

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
  String? university;
  String error = '';
  bool checkBoxValue = false;

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    if (date != null) {
      setState(() {
        pickedDate = date;
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
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
                SizedBox(height: 50),
                _buildTextField("Name", (val) => name = val),
                _buildTextField("Gender", (val) => gender = val),
                _buildDateField(),
                _buildTextField("University", (val) => university = val),
                _buildTermsAndConditions(),
                SizedBox(height: 25),
                _buildNextButton(),
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
          border: UnderlineInputBorder(),
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
          Expanded(
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
                  Icon(Icons.keyboard_arrow_down),
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
          activeColor: Color(0xFF2980b9),
          onChanged: (bool? newValue) {
            setState(() {
              checkBoxValue = newValue!;
            });
          },
        ),
        Expanded(
          child: Text(
            'I accept the terms and policies of this SUSU mobile messenger application.',
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
        onPressed: () async {},
        child: const Text(
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
