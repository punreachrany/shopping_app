import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/shares/constants.dart';
import 'package:shopping_app/shares/token_service.dart';

class AuthService {
  // =======================
  // USER REGISTRATION & LOGIN
  // =======================

  /// Register a new user and return the JWT token on success.
  Future<String?> registerUser(String name, String email, String password,
      String birthday, String gender) async {
    final url = Uri.parse('$BASE_URL/users/register/');
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
      await TokenService().saveToken(data['jwt']); // Save JWT to preferences
      return data['jwt'];
    }
    return null; // Return null if registration failed
  }

  /// Log in the user and return the JWT token on success.
  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('$BASE_URL/users/login/');
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
      await TokenService().saveToken(data['jwt']); // Save JWT to preferences
      return data['jwt'];
    }
    return null; // Return null if login failed
  }

  // =======================
  // LOGOUT FUNCTIONALITY
  // =======================

  /// Log out the user by clearing the token.
  Future<String> logoutUser() async {
    final token =
        await TokenService().getToken(); // Retrieve JWT from preferences
    final url = Uri.parse('$BASE_URL/users/logout/');

    final headers = {
      'Content-Type': 'text/plain',
      'Cookie': 'jwt=${token}', // Add JWT as a cookie
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await TokenService().clearToken(); // Clear token from preferences
      return data['message'];
    }
    return 'failed'; // Return failure message if logout failed
  }

  // =======================
  // USER INFORMATION & SESSION STATUS
  // =======================

  /// Fetch the logged-in user's information.
  Future<Map<String, dynamic>?> getUserInfo() async {
    final token =
        await TokenService().getToken(); // Retrieve JWT from preferences
    final url = Uri.parse('$BASE_URL/users/info');

    final headers = {
      'Content-Type': 'text/plain',
      'Cookie': 'jwt=${token}', // Add JWT as a cookie
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return user info as a Map
    }
    return null; // Return null if fetching user info failed
  }

  /// Check if the user is currently logged in.
  Future<bool> isLoggedIn() async {
    final token =
        await TokenService().getToken(); // Retrieve JWT from preferences
    if (token != null) {
      final url = Uri.parse('$BASE_URL/users/is_logged_in/');

      final headers = {
        'Content-Type': 'text/plain',
        'Cookie': 'jwt=${token}', // Add JWT as a cookie
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data["is_logged_in"]) {
          await TokenService()
              .clearToken(); // Clear token if user is not logged in
        }
        return data["is_logged_in"];
      }
    }
    return false; // Return false if no valid token exists
  }
}
