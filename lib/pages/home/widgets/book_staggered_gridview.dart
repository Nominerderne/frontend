import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/home/widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  final bookList = Book.generateBooks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PageView(
        controller: pageController,
        onPageChanged: (index) => callback(index),
        physics: NeverScrollableScrollPhysics(), // Гараар шилжихийг хязгаарлах
        children: [
          MasonryGridView.count(
            crossAxisCount: 2, // 2 багана
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: bookList.length,
            itemBuilder: (context, index) => BookItem(bookList[index]),
          ),
          Container(), // 2 дахь хуудас
        ],
      ),
    );
  }
}
