import 'package:ebook_app/constants/colors.dart';
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
  bool isPlaying = false;
  int userRating = 0;
  String _commentText = '';
  List<Map<String, dynamic>> _otherReviews = [];
  String currentUserId = '';

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

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_buildInteractiveStars()]),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Сэтгэгдэл бичих...',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (val) {
              setState(() {
                _commentText = val;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              if (userRating == 0 && _commentText.trim().isEmpty) return;

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
            icon: const Icon(Icons.send),
            label: const Text("Сэтгэгдэл хадгалах"),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(0, 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    print(isPlaying ? 'Playing audio' : 'Stopped audio');
                  },
                  child: Icon(
                    Icons.volume_up,
                    color: isPlaying ? kFont : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  book.review,
                  style: const TextStyle(
                    color: kFont,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Бусдын сэтгэгдэл:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
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
          }).toList(),
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
            color: index < userRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              userRating = index + 1;
            });
          },
        );
      }),
    );
  }
}
