import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// === HistoryService ===
class HistoryService {
  static Future<void> saveReadingHistory(int userId, int bookId) async {
    final url = Uri.parse("http://172.20.10.5:8000/readinghistory/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "addreadinghistory",
        "user_id": userId,
        "book_id": bookId,
      }),
    );

    if (response.statusCode != 200) {
      print("Хадгалах үед алдаа гарлаа.");
    }
  }
}

// === Favorite Page ===
class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteBooks;
  final int userId;

  const FavoritePage({
    Key? key,
    required this.favoriteBooks,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 2,
              tabs: [Tab(text: "Үзсэн түүх"), Tab(text: "Хадгалсан")],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WatchedHistoryTab(userId: userId),
                  SavedBooksTab(favoriteBooks: favoriteBooks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === Үзсэн түүх Tab ===
class WatchedHistoryTab extends StatefulWidget {
  final int userId;
  const WatchedHistoryTab({Key? key, required this.userId}) : super(key: key);

  @override
  State<WatchedHistoryTab> createState() => _WatchedHistoryTabState();
}

class _WatchedHistoryTabState extends State<WatchedHistoryTab> {
  List<Map<String, dynamic>> watchedBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWatchedBooks();
  }

  Future<void> fetchWatchedBooks() async {
    const String apiUrl = "http://172.20.10.5:8000/readinghistory/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "action": "getreadinghistory",
          "user_id": widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          watchedBooks = List<Map<String, dynamic>>.from(responseData["data"]);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching watched books: $e");
      setState(() => isLoading = false);
    }
  }

  void playBook(int bookId) {
    // TODO: Аудио тоглуулагч ашиглан тоглуулах
    print("Playing book with ID: $bookId");
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (watchedBooks.isEmpty) {
      return const Center(child: Text("Үзсэн түүх алга байна."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: watchedBooks.length,
        itemBuilder: (context, index) {
          final book = watchedBooks[index];
          final String dateWatched = dateFormat.format(
            DateTime.parse(book["watched_at"]),
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book["img_url"] ?? '',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book["title"] ?? "Үл мэдэгдэх ном",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Үзсэн огноо: $dateWatched",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              playBook(book["book_id"]);
                              HistoryService.saveReadingHistory(
                                widget.userId,
                                book["book_id"],
                              );
                            },
                          ),
                          const Text("Сонсох"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// === Хадгалсан ном Tab ===
class SavedBooksTab extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteBooks;
  const SavedBooksTab({Key? key, required this.favoriteBooks})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteBooks.isEmpty) {
      return const Center(child: Text("Хадгалсан ном алга байна."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          final book = favoriteBooks[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book['imgUrl'] ?? '',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Зохиогч: ${book['name'] ?? 'Тодорхойгүй'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
