import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/concert.dart';
import 'package:shopping_app/shares/constants.dart';
import 'package:shopping_app/shares/token_service.dart';

class ApiService {
  Future<bool> sendInquiry(String title, String message) async {
    final Uri url = Uri.parse('$BASE_URL/email_sender/inquiry/');
    final jwt = await TokenService().getToken();
    final headers = {'Content-Type': 'application/json', 'Cookie': 'jwt=$jwt'};

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

  Future<List<Concert>> fetchAvailableConcerts() async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/concert/available/'));
      if (response.statusCode == 200) {
        List<dynamic> concertsJson = jsonDecode(response.body);
        return concertsJson.map((json) => Concert.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load concerts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Concert> fetchConcertDetails(int id) async {
    final response = await http.get(Uri.parse('$BASE_URL/concert/$id/'));
    if (response.statusCode == 200) {
      return Concert.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load concert details');
    }
  }

  Future<Map<String, dynamic>> bookConcert(int concertId, int numSeats) async {
    final jwt = await TokenService().getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'jwt=$jwt', // Use Authorization header for JWT token
    };

    final response = await http.post(
      Uri.parse('$BASE_URL/concert/book/$concertId/'),
      headers: headers,
      body: jsonEncode({'num_seats': numSeats}), // Encode body as JSON
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to book concert: ${response.body}');
    }
  }

  Future<List<Booking>> fetchBookings() async {
    final jwt = await TokenService().getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'jwt=$jwt', // Use Authorization header for JWT token
    };
    final response =
        await http.get(Uri.parse('$BASE_URL/concert/mine/'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}
