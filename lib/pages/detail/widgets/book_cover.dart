import 'dart:async'; // Timer ашиглахад хэрэгтэй
import 'package:flutter/material.dart';
import 'package:ebook_app/constants/colors.dart';
import 'package:ebook_app/models/book.dart';
import 'package:just_audio/just_audio.dart';

class BookCover extends StatefulWidget {
  final Book book;
  const BookCover(this.book, {Key? key}) : super(key: key);

  @override
  State<BookCover> createState() => _BookCoverState();
}

class _BookCoverState extends State<BookCover> {
  late AudioPlayer _player;
  bool isPlaying = false;
  int currentIndex = 0; // Зураг солигдох индекс
  late List<String> altImageUrls; // alt_img_urls массив
  late Timer _timer; // Таймер
  bool isAudioPlaying = false; // Аудио тоглож байна уу?
  int imageChangeInterval = 10; // Зураг солигдох интервал (секундээр)

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setUrl(widget.book.audioUrl); // book.audioUrl байх ёстой!

    // alt_img_urls массивыг авах
    altImageUrls =
        widget.book.altImgUrls.isNotEmpty ? widget.book.altImgUrls : [];

    // Таймер тохируулж зураг солигдох үйлдлийг хийх
    if (altImageUrls.isNotEmpty) {
      _timer = Timer.periodic(Duration(seconds: imageChangeInterval), (timer) {
        if (isAudioPlaying) {
          setState(() {
            currentIndex = (currentIndex + 1) % altImageUrls.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Таймерыг зогсоох
    _player.dispose(); // Аудио тоглуулагчийг устгах
    super.dispose();
  }

  void _toggleAudio() async {
    if (isPlaying) {
      await _player.pause();
      setState(() {
        isAudioPlaying = false; // Аудио зогссон
      });
    } else {
      await _player.play();
      setState(() {
        isAudioPlaying = true; // Аудио тоглож байна
      });
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(left: 20),
      height: 250,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 50),
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              child:
                  altImageUrls.isNotEmpty
                      ? Image.network(
                        altImageUrls[currentIndex],
                        fit: BoxFit.cover,
                      )
                      : const Center(
                        child: Text("Зураг байхгүй"),
                      ), // Зураг байхгүй тохиолдолд
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: InkWell(
              onTap: _toggleAudio,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kFont,
                ),
                child: Row(
                  children: [
                    Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isPlaying ? 'Зогсоох' : 'Сонсох',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
