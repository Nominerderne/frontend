// === home.dart ===
// (Таны өмнөх HomePage код энд байна...)
// ...

// === favorite.dart ===
import 'package:ebook_app/pages/favorite/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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

class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteBooks;
  final int userId;
  final VoidCallback? onFavoriteChanged;

  const FavoritePage({
    Key? key,
    required this.favoriteBooks,
    required this.userId,
    this.onFavoriteChanged,
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
                  SavedBooksTab(
                    favoriteBooks: favoriteBooks,
                    onFavoriteChanged: onFavoriteChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class SavedBooksTab extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteBooks;
  final VoidCallback? onFavoriteChanged;

  const SavedBooksTab({
    Key? key,
    required this.favoriteBooks,
    this.onFavoriteChanged,
  }) : super(key: key);

  @override
  State<SavedBooksTab> createState() => _SavedBooksTabState();
}

class _SavedBooksTabState extends State<SavedBooksTab> {
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = widget.favoriteBooks;
  }

  @override
  void didUpdateWidget(covariant SavedBooksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favoriteBooks != widget.favoriteBooks) {
      setState(() {
        favorites = widget.favoriteBooks;
      });
    }
  }

  Future<void> _removeFavorite(String bookId) async {
    await FavoriteService.removeFavorite(bookId);
    final updated =
        favorites.where((book) => book['id'].toString() != bookId).toList();
    setState(() {
      favorites = updated;
    });

    if (widget.onFavoriteChanged != null) {
      widget.onFavoriteChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(child: Text("Хадгалсан ном алга байна."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final book = favorites[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
            ),
            child: Row(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => _removeFavorite(book['id'].toString()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
