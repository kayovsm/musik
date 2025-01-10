import '../entities/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<List<PlaylistEntity>> getPlaylists(String userId);
  Future<void> addPlaylist(String userId, PlaylistEntity playlist);
}