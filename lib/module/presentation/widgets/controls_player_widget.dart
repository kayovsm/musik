import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/repositories/firebase_repository_impl.dart';

class ControlsPlayerWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final FirebaseRepositoryImpl firebaseRepository;

  const ControlsPlayerWidget(
      {super.key, required this.controller, required this.firebaseRepository});

  @override
  State<ControlsPlayerWidget> createState() => _ControlsPlayerWidgetState();

  void playAudio() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void nextAudio() {
    final youtubeLinks = firebaseRepository.getYoutubeLinks();
    final int currentIndex =
        youtubeLinks.indexOf('https://youtu.be/${controller.metadata.videoId}');

    print('LOG ** METADATA: ${controller.metadata.videoId}');
    print('LOG ** NEXT currentIndex: $currentIndex');

    if (currentIndex < youtubeLinks.length - 1) {
      controller
          .load(YoutubePlayer.convertUrlToId(youtubeLinks[currentIndex + 1])!);
    }
  }

  void previousAudio() {
    final youtubeLinks = firebaseRepository.getYoutubeLinks();
    final int currentIndex = youtubeLinks
        .indexOf('https://youtu.be/${controller.metadata.videoId}');

    print('LOG ** PREVIOUS currentIndex: $currentIndex');

    if (currentIndex > 0) {
      controller
          .load(YoutubePlayer.convertUrlToId(youtubeLinks[currentIndex - 1])!);
    }
  }
}

class _ControlsPlayerWidgetState extends State<ControlsPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {
              widget.previousAudio();
            },
          ),
          IconButton(
            icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              widget.playAudio();
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              widget.nextAudio();
            },
          ),
        ],
      ),
    );
  }
}
