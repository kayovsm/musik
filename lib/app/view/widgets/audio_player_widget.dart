import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../widgets/app/text/description_text_app.dart';
import '../../../widgets/app/text/subtitle_text_app.dart';

class AudioPlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final Map<String, String> videoDetail;
  final VoidCallback onTap;

  const AudioPlayerWidget({
    super.key,
    required this.controller,
    required this.videoDetail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: false,
            aspectRatio: 8 / 5,
            width: 80,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTitleTextApp(
                    text: videoDetail['title'] ?? 'Carregando...',
                    oneLine: true,
                  ),
                  Row(
                    children: [
                      DescriptionTextApp(
                        text: videoDetail['author'] ?? 'Carregando...',
                        oneLine: true,
                      ),
                      const DescriptionTextApp(text: ' • '),
                      DescriptionTextApp(text: videoDetail['time'] ?? '0:00'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
