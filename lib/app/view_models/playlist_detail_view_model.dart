import 'package:flutter/material.dart';
import '../models/entities/playlist_entity.dart';
import '../models/repositories/playlist_repository.dart';

class PlaylistDetailViewModel with ChangeNotifier {
  final PlaylistRepository playlistRepository;
  PlaylistEntity? playlist;
  bool isLoading = true;

  PlaylistDetailViewModel({required this.playlistRepository});

  Future<void> fetchPlaylist(String userId, String playlistId) async {
    try {
      final playlists = await playlistRepository.getPlaylists(userId);
      playlist = playlists.firstWhere((p) => p.id == playlistId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch playlist: $e');
    }
  }

  Future<void> addMusicToPlaylist(
      String userId, String playlistId, String musicUrl) async {
    try {
      if (playlist == null) {
        throw Exception('Playlist not loaded');
      }
      playlist!.musicsUrl.add(musicUrl);
      await playlistRepository.addPlaylist(userId, playlist!);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add music to playlist: $e');
    }
  }
}
