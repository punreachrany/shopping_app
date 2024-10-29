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
    // Check if the user is already logged in
    if (await isLoggedIn()) {
      return true; // User is already logged in
    }

    final token = await _authService.loginUser(email, password);
    if (token != null) {
      // Fetch user info after login
      final userInfo = await _authService.getUserInfo();
      if (userInfo != null) {
        _user = User.fromJson(userInfo); // Create User object from response
        notifyListeners(); // Notify listeners of user state change
        return true; // Login success
      }
    }
    return false; // Login failed
  }

  // Method to register a new user
  Future<bool> register(String name, String email, String password,
      String birthday, String gender) async {
    final token = await _authService.registerUser(
        name, email, password, birthday, gender);

    if (token != null) {
      // Fetch user info after successful registration
      final userInfo = await _authService.getUserInfo();
      if (userInfo != null) {
        _user = User.fromJson(userInfo); // Store user information
        notifyListeners(); // Notify listeners of user state change
        return true; // Registration success
      }
    }
    return false; // Registration failed
  }

  // Method to log out the user
  Future<void> logout() async {
    if (_user != null) {
      await _authService.logoutUser(); // Log out the user
      _user = null; // Clear user data
      notifyListeners(); // Notify listeners of user state change
    }
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn(); // Check if the user is logged in
  }
}
