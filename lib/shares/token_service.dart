// token_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  /// Save the JWT token to shared preferences.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  /// Retrieve the JWT token from shared preferences.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  /// Clear the JWT token from shared preferences.
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }
}
