import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/shares/constants.dart';
import 'package:shopping_app/shares/token_service.dart';

class ApiService {
  Future<bool> sendInquiry(String title, String message) async {
    final jwt = await TokenService().getToken();
    final Uri url = Uri.parse('$BASE_URL/email_sender/inquiry/');

    final headers = {
      'Content-Type':
          'application/json', // Changed from text/plain to application/json
      'Cookie': 'jwt=$jwt', // Add JWT as a cookie
    };

    final body = jsonEncode({
      'title': title,
      'message': message,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body, // Sending JSON body
    );

    if (response.statusCode == 200) {
      return true; // Inquiry sent successfully
    } else {
      return false; // Failed to send inquiry
    }
  }
}
