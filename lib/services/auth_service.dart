import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/shares/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register User
  Future<String?> registerUser(String name, String email, String password,
      String birthday, String gender) async {
    final url = Uri.parse('$BASE_URL/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'birthday': birthday,
        'gender': gender,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      // Save the JWT token in shared preferences
      await _saveToken(data['jwt']);
      return data['jwt']; // Return the JWT token
    }

    return null; // Return null if registration failed
  }

  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('$BASE_URL/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Save the JWT token in shared preferences
      await _saveToken(data['jwt']);
      return data['jwt']; // Return the JWT token
    }

    return null; // Return null if login failed
  }

  Future<String> logoutUser() async {
    final token = await _getToken(); // Get token from shared preferences
    final url = Uri.parse('$BASE_URL/users/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Send the token in headers
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _clearToken(); // Clear the token from shared preferences
      return data['message'];
    }

    return 'failed'; // Return failed message if logout failed
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final token = await _getToken(); // Get token from shared preferences
    final url = Uri.parse('$BASE_URL/users/info');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Send the token in headers
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return user info as a Map
    }

    return null; // Return null if fetching user info failed
  }

  // New method to check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken(); // Get token from shared preferences
    return token != null; // Return true if the token exists
  }

  // Save token to shared preferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  // Get token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  // Clear token from shared preferences
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }
}
