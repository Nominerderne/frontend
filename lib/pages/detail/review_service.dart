import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const String baseUrl =
      'http://0.0.0.0:8000/review/'; // ← серверийн хаяг

  static Future<void> submitRating({
    required int bookId,
    required int rating,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');

    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'rate',
        'user_id': userId,
        'book_id': bookId,
        'rating': rating,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Үнэлгээ илгээхэд алдаа гарлаа');
    }
  }

  static Future<Map<String, dynamic>> fetchReviewsWithRating(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');

    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'action': 'get', 'user_id': userId, 'book_id': bookId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'user_rating': 0, 'reviews': []};
    }
  }
}
