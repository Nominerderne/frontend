import 'package:flutter/material.dart';
import 'package:ebook_app/pages/favorite/favorite_service.dart';
import 'package:ebook_app/pages/favorite/watched_history_tab.dart';

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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: const Color.fromARGB(255, 216, 220, 253),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color.fromARGB(255, 47, 139, 245),
                      width: 2,
                    ),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [Tab(text: "Үзсэн түүх"), Tab(text: "Хадгалсан")],
                ),
              ),
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    book['imgUrl'] ?? '',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 48),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Зохиогч: ${book['name'] ?? 'Тодорхойгүй'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.redAccent),
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
