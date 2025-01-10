import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/entities/playlist_entity.dart';
import '../models/repositories/playlist_repository.dart';

class PlaylistViewModel with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final PlaylistRepository playlistRepository;
  List<PlaylistEntity> playlists = [];
  bool isLoading = true;

  PlaylistViewModel({required this.playlistRepository});

  Future<void> fetchPlaylists() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }
      playlists = await playlistRepository.getPlaylists(user.uid);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch playlists: $e');
    }
  }

  Future<void> addPlaylist(String name) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }
      final newPlaylist = PlaylistEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        musicsUrl: [],
      );
      await playlistRepository.addPlaylist(user.uid, newPlaylist);
      playlists.add(newPlaylist);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add playlist: $e');
    }
  }
}
