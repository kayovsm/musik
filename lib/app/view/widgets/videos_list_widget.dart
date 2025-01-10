import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'audio_player_widget.dart';

class VideoListWidget extends StatelessWidget {
  final List<YoutubePlayerController> controllers;
  final List<Map<String, String>> videoDetails;
  final Function(YoutubePlayerController, String, String, String) onTap;

  const VideoListWidget({
    super.key,
    required this.controllers,
    required this.videoDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            AudioPlayerWidget(
              controller: controllers[index],
              videoDetail: videoDetails[index],
              onTap: () => onTap(
                controllers[index],
                videoDetails[index]['title']!,
                videoDetails[index]['author']!,
                videoDetails[index]['time']!,
              ),
            ),
          ],
        );
      },
    );
  }
}