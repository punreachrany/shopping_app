import 'package:flutter/material.dart';
import 'package:shopping_app/models/user.dart';
import 'package:shopping_app/services/auth_service.dart'; // Adjust the import based on your folder structure

class UserProvider with ChangeNotifier {
  User? _user; // Private variable to store user information
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService

  User? get user => _user; // Getter for the user

  // Method to set user
  void setUser(User? user) {
    _user = user;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to log in the user
  Future<bool> login(String email, String password) async {
    final token = await _authService.loginUser(email, password);
    if (token != null) {
      // You might want to fetch user info after login
      // For example:
      final userInfo = await _authService.getUserInfo(token);
      if (userInfo != null) {
        _user = User.fromJson(userInfo);
        notifyListeners();
        return true; // Login success
      }
    }
    return false; // Login failed
  }

  // Method to log out the user
  Future<void> logout() async {
    if (_user != null) {
      // Assuming you have the JWT token saved somewhere
      await _authService.logoutUser(
          _user!.email); // Adjust this line based on your logout logic
      _user = null;
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    // You might need to get the token from shared preferences or a secure storage
    final token = ''; // Retrieve your token here
    final result = await _authService.isLoggedIn(token);
    return result?['is_logged_in'] ?? false;
  }
}
