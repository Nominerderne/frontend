import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ebook_app/constants/colors.dart';
import 'package:ebook_app/models/book.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebook_app/pages/favorite/history_service.dart';

class BookCover extends StatefulWidget {
  final Book book;
  const BookCover(this.book, {Key? key}) : super(key: key);

  @override
  State<BookCover> createState() => _BookCoverState();
}

class _BookCoverState extends State<BookCover> {
  late AudioPlayer _player;
  bool isPlaying = false;
  int currentIndex = 0;
  late List<String> altImageUrls;
  Timer? _timer;
  bool isAudioPlaying = false;
  int imageChangeInterval = 10;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();

    altImageUrls =
        widget.book.altImgUrls.isNotEmpty ? widget.book.altImgUrls : [];

    if (altImageUrls.isNotEmpty) {
      _timer = Timer.periodic(Duration(seconds: imageChangeInterval), (timer) {
        if (mounted && isAudioPlaying) {
          setState(() {
            currentIndex = (currentIndex + 1) % altImageUrls.length;
          });
        }
      });
    }

    _player.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _player.durationStream.listen((duration) {
      if (mounted && duration != null && duration > Duration.zero) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _player.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            isPlaying = false;
            isAudioPlaying = false;
          });
        }

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('userid');
        final bookId = int.tryParse(widget.book.id);
        if (userId != null && bookId != null) {
          await HistoryService.saveReadingHistory(userId, bookId);
          print("Түүхэнд амжилттай хадгаллаа");
        }
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      await _player.setUrl(widget.book.audioUrl);
      await Future.delayed(const Duration(milliseconds: 500));

      final duration = _player.duration;
      if (mounted && duration != null && duration > Duration.zero) {
        setState(() {
          _totalDuration = duration;
        });
      }
    } catch (e) {
      print("Аудио ачааллахад алдаа: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (isPlaying) {
      await _player.pause();
      if (mounted) {
        setState(() {
          isAudioPlaying = false;
        });
      }
    } else {
      await _player.play();
      if (mounted) {
        setState(() {
          isAudioPlaying = true;
        });
      }
    }
    if (mounted) {
      setState(() {
        isPlaying = !isPlaying;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(left: 10),
      height: 300,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 50),
                width: MediaQuery.of(context).size.width - 20,
                height: 250,
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
                          : const Center(child: Text("Зураг байхгүй")),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _toggleAudio,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kFont,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
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
                const SizedBox(width: 10),
                Text(
                  _formatDuration(_currentPosition),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                      activeTrackColor: Colors.indigo,
                      inactiveTrackColor: Colors.indigo.shade100,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      min: 0,
                      max:
                          _totalDuration.inSeconds > 0
                              ? _totalDuration.inSeconds.toDouble()
                              : 1,
                      value:
                          _currentPosition.inSeconds
                              .clamp(
                                0,
                                _totalDuration.inSeconds > 0
                                    ? _totalDuration.inSeconds
                                    : 1,
                              )
                              .toDouble(),
                      onChanged:
                          _totalDuration.inSeconds > 0
                              ? (value) async {
                                try {
                                  await _player.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                } catch (e) {
                                  print("Seek хийхэд алдаа: $e");
                                }
                              }
                              : null,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
