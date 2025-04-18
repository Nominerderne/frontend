//book_staggered_gridview.dart
import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/favorite/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'book_item.dart';

class BookStaggeredGridView extends StatelessWidget {
  final int selected;
  final PageController pageController;
  final List<Map<String, dynamic>> favoriteBooks;
  final VoidCallback? onFavoriteToggled;
  final Function(int index, List<Map<String, dynamic>> favorites) callback;

  BookStaggeredGridView(
    this.selected,
    this.pageController,
    this.callback,
    this.favoriteBooks, {
    this.onFavoriteToggled,
    Key? key,
  }) : super(key: key);

  Future<List<Book>> fetchBooks(BuildContext context) async {
    return await Book.fetchBooks(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: fetchBooks(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Алдаа: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Ном олдсонгүй'));
        }

        List<Book> bookList = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PageView(
            controller: pageController,
            onPageChanged:
                (index) => callback(index, favoriteBooks), // Зассан хэсэг
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  final book = bookList[index];
                  final isFavorite = favoriteBooks.any(
                    (favBook) => favBook['id'] == book.id,
                  );

                  return BookItem(
                    book: book,
                    isFavorite: isFavorite,
                    onFavoriteToggled: (isNowFavorite) async {
                      // Та хүсвэл энд серверээс дахин авж state шинэчилж болно
                      final updatedFavorites =
                          await FavoriteService.getFavorites();

                      // widget-ийг update хийж өгөхийн тулд callback ашиглана
                      callback(selected, updatedFavorites);
                    },
                  );
                },
              ),
              Container(),
            ],
          ),
        );
      },
    );
  }
}
