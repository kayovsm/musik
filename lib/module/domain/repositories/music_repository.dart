import '../../data/models/music_model.dart';

abstract class MusicRepository {
  Future<MusicModel> getMusic(String url);
}