import 'dart:math';

class Book {
  String type;
  String name;
  String publisher;
  DateTime date;
  String imgUrl;
  num score;
  // num ratings;
  String review;
  num height;
  int duration; // Add a field for duration in minutes

  // Constructor
  Book(
    this.type,
    this.name,
    this.publisher,
    this.date,
    this.imgUrl,
    this.score,
    // this.ratings,
    this.review,
    this.height,
    this.duration, // Add duration in the constructor
  );

  // Method to generate a list of books (with the new duration field)
  static List<Book> generateBooks() {
    return [
      Book(
        'Үлгэр',
        'Сэргэлэн туулай',
        'Оюунлаг',
        DateTime(2025, 2, 25),
        'assets/images/book1.jpeg',
        4.7,

        'Сэргэлэн туулайгийн сонирхолтой адал явдал!',
        220,
        15, // Duration in minutes
      ),
      Book(
        'Үлгэр',
        'Эрхий мэргэн',
        'iStudio',
        DateTime(2025, 2, 25),
        'assets/images/book2.jpeg',
        4.8,

        'Монголын эртний домог дээр үндэслэсэн сонирхолтой түүх.',
        230,
        18, // Duration in minutes
      ),
      Book(
        'Үлгэр',
        'Тэмээ',
        'iStudio',
        DateTime(2025, 2, 25),
        'assets/images/book3.jpeg',
        4.6,

        'Тэмээ хэрхэн өөрийн онцгой байдлаа олж авсан тухай үлгэр.',
        200,
        20, // Duration in minutes
      ),
      Book(
        'Үлгэр',
        'Болдоггүй бор өвгөн',
        'iStudio',
        DateTime(2025, 2, 25),
        'assets/images/book4.jpeg',
        4.7,

        'Болдоггүй бор өвгөний гайхамшигтай түүх.',
        210,
        16, // Duration in minutes
      ),
      Book(
        'Түүх',
        'Цуутын цагаагч гүү',
        'iStudio',
        DateTime(2025, 2, 25),
        'assets/images/book5.jpeg',
        4.3,

        'Монгол ардын домгийн нэгэн алдартай түүх.',
        240,
        22, // Duration in minutes
      ),
      Book(
        'Домог',
        'Алунгоо эх',
        '',
        DateTime(2025, 2, 25),
        'assets/images/book7.jpeg',
        4.3,
        '.',
        240,
        22,
      ),
      Book(
        'Домог',
        'Алтан гадас од ба 7 бурхан од',
        '',
        DateTime(2025, 2, 25),
        'assets/images/book6.jpeg',
        4.3,
        'Монгол ардын домгийн нэгэн алдартай түүх.',
        240,
        22,
      ),
    ];
  }

  // Function to get a random book from the list
  static Book getRandomBook() {
    List<Book> books = generateBooks();
    Random random = Random();
    return books[random.nextInt(books.length)];
  }
}

// Sample usage: Get a random book
final Book selectedBook = Book.getRandomBook();
