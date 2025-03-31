import 'dart:convert'; // JSON өгөгдөлтэй ажиллах
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];

  // CSRF Token
  String csrfToken = "CSRF_TOKEN_HERE"; // Энэ токеныг серверээс авах хэрэгтэй.

  // Хайлтын логик
  Future<void> _search(String query) async {
    final response = await http.post(
      Uri.parse(
        'http://127.0.0.1:8000/search-log/',
      ), // Django серверийн эндпоинт
      headers: {
        'Content-Type': 'application/json', // JSON өгөгдөл илгээж байгаа тул
        'X-CSRFToken': csrfToken, // CSRF token
      },
      body: json.encode({'search_query': query}), // Хайлтын хүсэлт
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data; // Хайлтын үр дүнг хадгална
      });
    } else {
      print('Хайлтын API алдаа: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 189, 248),
        title: const Text('Хайлт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Хайлтаа оруулна уу',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                _search(text); // Хайлтыг эхлүүлэх
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _searchResults[index]['title'] ?? 'Нэр байхгүй',
                    ),
                    subtitle: Text(
                      _searchResults[index]['content'] ?? 'Мазмүүн байхгүй',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
