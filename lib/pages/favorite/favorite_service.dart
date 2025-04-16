import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteService {
  static const String baseUrl = 'http://172.20.10.5:8000/favorite/';

  static Future<void> addFavorite(Map<String, dynamic> book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'action': 'add', 'book': book}),
    );

    if (response.statusCode != 200) {
      throw Exception('Ном хадгалах үед алдаа гарлаа');
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'action': 'get'}),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      throw Exception('Хадгалсан ном авах үед алдаа гарлаа');
    }
  }

  static Future<void> removeFavorite(String bookId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'action': 'remove', 'book_id': bookId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Хадгалсан ном устгах үед алдаа гарлаа');
    }
  }
}
