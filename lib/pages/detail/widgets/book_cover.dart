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
  bool isAudioReady = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setUrl(widget.book.audioUrl);
      setState(() {
        isAudioReady = true;
      });
      print('Audio loaded successfully: ${widget.book.audioUrl}');
    } catch (e) {
      print('Audio ачааллаж чадсангүй: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (!isAudioReady) return;

    try {
      if (isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      print('Play/Pause error: $e');
    }
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
              child: Image.network(widget.book.imgUrl, fit: BoxFit.cover),
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
