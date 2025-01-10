import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../widgets/app/text/description_text_app.dart';
import '../../../widgets/app/text/subtitle_text_app.dart';
import '../../models/repositories/music_repository_impl.dart';
import '../player_page.dart';

class BottomSheetWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final String title;
  final String author;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback navigatorPlayer;

  const BottomSheetWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.author,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.navigatorPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: onPrevious,
                ),
                IconButton(
                  icon: Icon(controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  onPressed: onPlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: onNext,
                ),
              ],
            ),
            Flexible(
              child: InkWell(
                onTap: navigatorPlayer,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleTextApp(text: title),
                      DescriptionTextApp(text: author),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
