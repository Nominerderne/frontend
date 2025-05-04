//book_review.dart
import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/detail/review_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookReview extends StatefulWidget {
  final Book book;
  const BookReview(this.book, {Key? key}) : super(key: key);

  @override
  State<BookReview> createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  int userRating = 0;
  String _commentText = '';
  List<Map<String, dynamic>> _otherReviews = [];
  String currentUserId = '';
  bool showFullReview = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt('userid')?.toString() ?? '';
    });
    await _loadReviews();
  }

  Future<void> _loadReviews() async {
    final result = await ReviewService.fetchReviewsWithRating(
      int.tryParse(widget.book.id) ?? 0,
    );
    setState(() {
      _otherReviews = List<Map<String, dynamic>>.from(result['reviews']);
      userRating = result['user_rating'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    String shortReview =
        book.review.length > 200 ? book.review.substring(0, 200) : book.review;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInteractiveStars(),
          // Review товч бичвэр
          Text(
            showFullReview ? book.review : shortReview,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          if (book.review.length > 200)
            TextButton(
              onPressed: () {
                setState(() {
                  showFullReview = !showFullReview;
                });
              },
              child: Text(
                showFullReview ? "Хураах" : "… Дэлгэрэнгүй",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          const SizedBox(height: 8),

          const Text(
            'Сэтгэгдэл:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // Сэтгэгдэл бичих хэсэг
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Сэтгэгдэл бичих...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  onChanged: (val) {
                    setState(() {
                      _commentText = val;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.black),
                onPressed: () async {
                  if (_commentText.trim().isEmpty) return;

                  if (userRating > 0) {
                    await ReviewService.submitRating(
                      bookId: int.tryParse(widget.book.id) ?? 0,
                      rating: userRating,
                      comment: _commentText,
                    );
                  } else {
                    await ReviewService.submitComment(
                      bookId: int.tryParse(widget.book.id) ?? 0,
                      comment: _commentText,
                    );
                  }

                  setState(() {
                    _commentText = '';
                  });

                  await _loadReviews();
                },
              ),
            ],
          ),

          if (_otherReviews.isEmpty)
            const Text("Одоогоор сэтгэгдэл алга байна."),
          ..._otherReviews.map((review) {
            final isOwn = review['user_id'].toString() == currentUserId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: isOwn ? Colors.yellow[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("★ ${review['rating']} | ${review['created_at']}"),
                    const SizedBox(height: 4),
                    Text(
                      "${review['username']}${isOwn ? ' (Та)' : ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review['comment'].toString().isNotEmpty
                          ? review['comment']
                          : "(Сэтгэгдэл бичээгүй)",
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInteractiveStars() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            size: 24,
            color: index < userRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () async {
            setState(() {
              userRating = index + 1;
            });

            await ReviewService.submitRating(
              bookId: int.tryParse(widget.book.id) ?? 0,
              rating: userRating,
              comment: _commentText,
            );

            await _loadReviews();
          },
        );
      }),
    );
  }
}
