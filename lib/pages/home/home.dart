import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ebook_app/pages/favorite/favorite.dart';
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

  final List<Book> favoriteBooks = [];
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    fetchBooksAndInit();
  }

  Future<void> fetchBooksAndInit() async {
    // Fetch books and update state
    allBooks = await Book.fetchBooks(context);
    randomBook = Book.getRandomBook(allBooks);
    print("allBooks");
    print(allBooks);

    setState(() {
      pages.add(
        Column(
          children: [
            _buildStorySlider(),
            Expanded(
              child: BookStaggeredGridView(
                tabIndex,
                pageController,
                (int index) => setState(() {
                  tabIndex = index;
                }),
              ),
            ),
          ],
        ),
      );
      pages.add(FavoritePage());
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
              ? pages[bottomIndex]
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

  // Update this to display the book list using a for loop
  Widget _buildBookList() {
    return ListView.builder(
      itemCount: allBooks.length,
      itemBuilder: (context, index) {
        final book = allBooks[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    book.imgUrl, // Ensure this path is correct
                    width: 130,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title, // Show the name of the book
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 28,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle remove action here
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black54,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          bottomIndex = index;
        });
      },
    );
  }
}
