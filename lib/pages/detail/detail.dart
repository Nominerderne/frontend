import 'package:ebook_app/constants/colors.dart';
import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/detail/widgets/book_cover.dart';
import 'package:ebook_app/pages/detail/widgets/book_review.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Make sure to import this for DateFormat

class DetailPage extends StatelessWidget {
  final Book book;
  const DetailPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // If this was the content in the broken return block, add it here
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   book.type.toUpperCase(),
                  //   style: const TextStyle(
                  //     color: Colors.deepOrange,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 24,
                  //   ),
                  // ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${book.title} ',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kFont,
                          ),
                        ),
                        TextSpan(
                          text:
                              "Зохиолч:"
                              '${book.name}',
                          style: const TextStyle(
                            fontSize: 16, // жижиг фонт
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   book.publisher,
                      //   style: const TextStyle(
                      //     color: kFont,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // Text(
                      //   DateFormat.yMMMd().format(book.date),
                      //   style: const TextStyle(color: Colors.grey),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            BookCover(book),
            BookReview(book),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_outlined, color: kFont),
      ),
    );
  }
}
