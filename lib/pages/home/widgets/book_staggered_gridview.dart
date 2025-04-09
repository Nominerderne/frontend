import 'package:ebook_app/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'book_item.dart'; // Үүнийг ашиглаж байгаа

class BookStaggeredGridView extends StatelessWidget {
  final int selected;
  final PageController pageController;
  final Function callback;

  BookStaggeredGridView(
    this.selected,
    this.pageController,
    this.callback, {
    Key? key,
  }) : super(key: key);

  Future<List<Book>> fetchBooks(BuildContext context) async {
    return await Book.fetchBooks(context); // Asynchronous function
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: fetchBooks(context), // Асинхрон функц дуудах
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Ачаалж байгаа үед харуулах
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Алдаа: ${snapshot.error}')); // Алдаа гарсан бол харуулах
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Ном олдсонгүй')); // Ном байхгүй бол харуулах
        }

        List<Book> bookList = snapshot.data!; // bookList хадгалах

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => callback(index),
            physics: NeverScrollableScrollPhysics(),
            children: [
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: bookList.length,
                itemBuilder: (context, index) => BookItem(bookList[index]), // BookItem холбох
              ),
              Container(), // 2 дахь хуудас
            ],
          ),
        );
      },
    );
  }
}
