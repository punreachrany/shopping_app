import 'package:flutter/material.dart';
import 'package:shopping_app/services/auth_service.dart';
// import 'auth.dart'; // Import the AuthService class

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  Map<String, dynamic>? _userInfo;

  String? get token => _token;
  Map<String, dynamic>? get userInfo => _userInfo;

  Future<bool> registerUser(String name, String email, String password,
      String birthday, String gender) async {
    return await _authService.registerUser(
        name, email, password, birthday, gender);
  }

  Future<bool> loginUser(String email, String password) async {
    _token = await _authService.loginUser(email, password);
    notifyListeners();
    return _token != null;
  }

  Future<void> logoutUser() async {
    if (_token != null) {
      await _authService.logoutUser(_token!);
      _token = null;
      _userInfo = null;
      notifyListeners();
    }
  }

  Future<void> getUserInfo() async {
    if (_token != null) {
      _userInfo = await _authService.getUserInfo(_token!);
      notifyListeners();
    }
  }
}
