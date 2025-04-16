import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ebook_app/pages/favorite/favorite.dart';
import 'package:ebook_app/pages/favorite/favorite_service.dart';
import 'package:ebook_app/pages/home/widgets/book_item.dart';
import 'package:ebook_app/pages/profile.dart';
import 'package:ebook_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:ebook_app/constants/colors.dart';
import 'package:ebook_app/pages/detail/detail.dart';
import 'package:ebook_app/pages/home/widgets/book_staggered_gridview.dart';
import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/page3/bichleg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tabIndex = 0;
  var bottomIndex = 0;
  final pageController = PageController();
  final storyPageController = PageController();
  int currentPage = 0;

  List<Book> allBooks = [];
  Book? randomBook;
  List<Map<String, dynamic>> favoriteBooks = [];

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    fetchBooksAndInit();
  }

  Future<void> fetchBooksAndInit() async {
    // Fetch books and favorite state
    allBooks = await Book.fetchBooks(context);
    randomBook = Book.getRandomBook(allBooks);
    favoriteBooks = await FavoriteService.getFavorites();

    setState(() {
      // Home Page (book grid) page
      pages.add(
        Column(
          children: [
            _buildStorySlider(),
            Expanded(
              child: BookStaggeredGridView(
                tabIndex, // tabIndex
                pageController, // pageController
                (int index, List<Map<String, dynamic>> updatedFavorites) {
                  setState(() {
                    tabIndex = index;
                    favoriteBooks =
                        updatedFavorites; // Шинэчилсэн дуртай номын жагсаалт
                  });
                }, // callback function
                favoriteBooks, // favoriteBooks
              ),
            ),
          ],
        ),
      );

      // Add FavoritePage as a new page
      pages.add(
        FavoritePage(
          favoriteBooks: favoriteBooks,
        ), // Pass favoriteBooks to FavoritePage
      );

      // Other pages (Bichleg, Profile)
      pages.add(BichlegPage());
      pages.add(ProfilePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:
          pages.isNotEmpty
              ? pages[bottomIndex] // Based on bottomIndex, switch pages
              : const Center(
                child: CircularProgressIndicator(),
              ), // Loading indicator
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStorySlider() {
    List<Book> limitedStories = allBooks.take(3).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: storyPageController,
            itemCount: limitedStories.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(limitedStories[index]),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      limitedStories[index].imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            limitedStories.length,
            (index) => Container(
              margin: const EdgeInsets.all(4.0),
              width: currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.blueAccent : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
      itemCount: allBooks.length,
      itemBuilder: (context, index) {
        final book = allBooks[index];
        final isFavorite = favoriteBooks.any(
          (favBook) => favBook['id'] == book.id,
        );
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookItem(book: allBooks[index], isFavorite: isFavorite),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 122, 189, 248),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_book, color: white),
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
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          icon: const Icon(Icons.search_outlined, color: white),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    final bottoms = [
      const Icon(Icons.home, size: 30, color: Colors.white),
      const Icon(Icons.favorite, size: 30, color: Colors.white),
      const Icon(Icons.access_time, size: 30, color: Colors.white),
      const Icon(Icons.person, size: 30, color: Colors.white),
    ];

    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: const Color.fromARGB(255, 122, 189, 248),
      buttonBackgroundColor: Colors.blueAccent,
      height: 60,
      items: bottoms,
      onTap: (index) {
        setState(() {
          bottomIndex = index; // Set bottomIndex to navigate
        });
      },
    );
  }
}
