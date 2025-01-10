import 'package:flutter/material.dart';
import '../models/repositories/music_repository_impl.dart';
import 'widgets/base_music_page.dart';

class PlaylistDetailPage extends BaseMusicPage {
  final String playlistId;

  const PlaylistDetailPage({
    super.key,
    required MusicRepositoryImpl musicRepository,
    required String userId,
    required this.playlistId,
  }) : super(musicRepository: musicRepository, userId: userId);

  @override
  Future<List<String>> fetchYoutubeLinks() async {
    final playlists = await musicRepository.getPlaylists(userId);
    final playlist = playlists.firstWhere((p) => p.id == playlistId);
    return playlist.musicsUrl;
  }
}
