import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/entities/playlist_entity.dart';
import '../../models/repositories/music_repository_impl.dart';
import '../playlist_detail_page.dart';

class PlaylistListWidget extends StatelessWidget {
  final List<PlaylistEntity> playlists;
  final MusicRepositoryImpl musicRepository;
  final String userId;

  const PlaylistListWidget({
    super.key,
    required this.playlists,
    required this.userId,
    required this.musicRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return ListTile(
          title: Text(playlist.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistDetailPage(
                  userId: userId,
                  playlistId: playlist.id,
                  musicRepository: musicRepository,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
