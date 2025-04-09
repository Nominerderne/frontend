import 'package:ebook_app/models/book.dart';
import 'package:flutter/material.dart';
import 'book_card.dart';

class BichlegPage extends StatelessWidget {
  const BichlegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 122, 189, 248),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_book, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                "Монгол ардын үлгэр",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 2,
              tabs: [Tab(text: "Үлгэр"), Tab(text: "Домог")],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BooksTab(bookType: 'Үлгэр'),
                  BooksTab(bookType: 'Домог'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// vlger domgiig tusdan haruulxiig duugaj bgaa book_card
class BooksTab extends StatelessWidget {
  final String bookType;

  const BooksTab({Key? key, required this.bookType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> books = [];

    // Filter books based on the passed bookType ("Үлгэр" or "Домог")
    List<Book> filteredBooks =
        books.where((book) => book.type == bookType).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          return BookCard(book: filteredBooks[index]);
        },
      ),
    );
  }
}
