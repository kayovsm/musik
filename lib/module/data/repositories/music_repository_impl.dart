import '../../domain/repositories/music_repository.dart';
import '../models/music_model.dart';

class MusicRepositoryImpl implements MusicRepository {
  @override
  Future<MusicModel> getMusic(String url) async {
    // Aqui você pode adicionar lógica para buscar a música de uma API, se necessário
    return MusicModel(url: url);
  }
}