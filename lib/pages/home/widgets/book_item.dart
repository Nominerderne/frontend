import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/detail/detail.dart';
import 'package:flutter/material.dart';

class BookItem extends StatefulWidget {
  final Book book;
  const BookItem(this.book, {Key? key}) : super(key: key);

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool isFavorite = false; // Track the heart icon state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailPage(widget.book)),
          ),
      child: Container(
        height: widget.book.height as double,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.book.imgUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Align items at the bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8), // Padding for text and icon
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Make the text widget flexible so it takes up available space
                    child: Text(
                      widget.book.name, // Book name text
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow
                              .ellipsis, // Handles text overflow with "..."
                      maxLines:
                          1, // Ensure the text doesn't wrap into multiple lines
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite; // Toggle the heart icon
                      });
                    },
                    child: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border, // Toggle icon
                      color:
                          isFavorite
                              ? Colors.red
                              : Colors.white, // Red when favorite
                    ),
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
