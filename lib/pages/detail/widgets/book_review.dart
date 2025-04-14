import 'package:ebook_app/constants/colors.dart';
import 'package:ebook_app/models/book.dart';
import 'package:flutter/material.dart';

class BookReview extends StatefulWidget {
  final Book book;
  const BookReview(this.book, {Key? key}) : super(key: key);

  @override
  State<BookReview> createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${book.score}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              _buildStar(),
            ],
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Дээр нь бага зэрэг өргөсөн icon
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
        ],
      ),
    );
  }

  Widget _buildStar() {
    final List<Color> color = [
      Colors.amber,
      Colors.amber,
      Colors.amber,
      Colors.amber,
      Colors.grey,
    ];
    return Row(
      children: color.map((e) => Icon(Icons.star, size: 25, color: e)).toList(),
    );
  }
}
