import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/repositories/firebase_repository_impl.dart';

class OldHomePage extends StatefulWidget {
  const OldHomePage({super.key, required this.title});

  final String title;

  @override
  State<OldHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<OldHomePage> {
  final FirebaseRepositoryImpl firebaseRepository = FirebaseRepositoryImpl();
  List<String> youtubeLinks = [];
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    youtubeLinks = await firebaseRepository.getYoutubeLinks();

    print('LOG ** youtubeLinks: $youtubeLinks');
    if (youtubeLinks.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(youtubeLinks[0])!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      )..addListener(() {
          if (isPlayerReady && mounted) {
            setState(() {});
          }
        });
      setState(() {
        isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isPlayerReady
            ? YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                onReady: () {
                  _controller.addListener(() {});
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}