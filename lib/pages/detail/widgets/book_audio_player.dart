import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BookAudioPlayer extends StatefulWidget {
  final String audioUrl;
  const BookAudioPlayer({required this.audioUrl, super.key});

  @override
  State<BookAudioPlayer> createState() => _BookAudioPlayerState();
}

class _BookAudioPlayerState extends State<BookAudioPlayer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // URL-г оноож байна
    _player.setUrl(widget.audioUrl).catchError((error) {
      print("Аудио ачааллахад алдаа: $error");
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Үлгэр сонсох", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 30),
              onPressed: () => _player.play(),
            ),
            IconButton(
              icon: const Icon(Icons.pause, size: 30),
              onPressed: () => _player.pause(),
            ),
          ],
        ),
      ],
    );
  }
}
