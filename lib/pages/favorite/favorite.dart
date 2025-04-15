// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FavoritePage extends StatelessWidget {
//   const FavoritePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         body: Column(
//           children: [
//             const TabBar(
//               labelColor: Colors.blueAccent,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.blueAccent,
//               indicatorWeight: 2,
//               tabs: [Tab(text: "Үзсэн түүх"), Tab(text: "Хадгалсан")],
//             ),
//             Expanded(
//               child: const TabBarView(
//                 children: [WatchedHistoryTab(), SavedBooksTab()],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Үзсэн түүх харагдах хэсэг
// class WatchedHistoryTab extends StatelessWidget {
//   const WatchedHistoryTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Example list of watched timestamps (You can modify this to be dynamic)
//     final List<DateTime> watchedDates = [DateTime(2025, 3, 24, 10, 30)];

//     // Create a date formatter for "yyyy MM dd" format
//     final DateFormat dateFormat = DateFormat('yyyy MM dd');

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView.builder(
//         itemCount: 1,
//         itemBuilder: (context, index) {
//           String formattedDate = dateFormat.format(
//             watchedDates[index],
//           ); // Format the date

//           return Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.asset(
//                     'assets/images/book${index + 1}.jpeg', // Ensure this path is correct
//                     width: 100,
//                     height: 80,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Үлгэрийн нэр $index",
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       // Add the formatted date to show when it was watched
//                       Text(
//                         "Үзсэн огноо: $formattedDate", // Shows the formatted date
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Хадгалсан ном харагдах хэсэг
// class SavedBooksTab extends StatelessWidget {
//   const SavedBooksTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.asset(
//                     'assets/images/book1.jpeg', // Ensure this path is correct
//                     width: 130,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Сэргэлэн туулай",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Icon(
//                             Icons.favorite,
//                             color: Colors.pink,
//                             size: 28,
//                           ),
//                           GestureDetector(
//                             onTap: () {},
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: const BoxDecoration(
//                                 color: Colors.black12,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.black54,
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:ebook_app/models/book.dart';
import 'package:ebook_app/pages/favorite/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 2,
              tabs: [Tab(text: "Үзсэн түүх"), Tab(text: "Хадгалсан")],
            ),
            const Expanded(
              child: TabBarView(
                children: [WatchedHistoryTab(), SavedBooksTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Үзсэн түүх харагдах хэсэг
class WatchedHistoryTab extends StatelessWidget {
  const WatchedHistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DateTime> watchedDates = [DateTime(2025, 3, 24, 10, 30)];
    final DateFormat dateFormat = DateFormat('yyyy MM dd');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: watchedDates.length,
        itemBuilder: (context, index) {
          String formattedDate = dateFormat.format(watchedDates[index]);
          return Container(
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
                    'assets/images/book${index + 1}.jpeg',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Үлгэрийн нэр $index",
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
                        "Үзсэн огноо: $formattedDate",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Хадгалсан ном харагдах хэсэг
class SavedBooksTab extends StatefulWidget {
  const SavedBooksTab({Key? key}) : super(key: key);

  @override
  State<SavedBooksTab> createState() => _SavedBooksTabState();
}

class _SavedBooksTabState extends State<SavedBooksTab> {
  List<Map<String, dynamic>> _savedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    final books = await FavoriteService.getFavorites();
    setState(() {
      _savedBooks = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_savedBooks.isEmpty) {
      return const Center(child: Text("Хадгалсан ном алга байна."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _savedBooks.length,
        itemBuilder: (context, index) {
          final book = _savedBooks[index];

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
                    child: Image.network(
                      book['imgUrl'] ?? '',
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'] ?? '',
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
                          "Зохиогч: ${book['name'] ?? 'Тодорхойгүй'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
