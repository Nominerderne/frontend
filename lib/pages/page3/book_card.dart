import 'package:flutter/material.dart';
import 'package:ebook_app/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrapping the image with Flexible to make it responsive
          Flexible(
            flex: 0, // Ensure image width remains consistent
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                book.imgUrl,
                fit: BoxFit.cover,
                height: 100, // Maintain a constant height
                width: 130, // Set a fixed width for the image to avoid overflow
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
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
                  book.review,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.green,
                          size: 18,
                        ),
                        Text(
                          "${book.duration} мин", // minut
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 18),
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        Text(
                          "${book.score}", //  vnelgee
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
