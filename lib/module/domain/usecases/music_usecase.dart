import 'package:musik/module/domain/entities/music_entity.dart';

import '../repositories/music_repository.dart';

class GetMusicUseCase {
  final MusicRepository repository;

  GetMusicUseCase(this.repository);

  Future<MusicEntity> call(String url) async {
    final musicModel = await repository.getMusic(url);
    return MusicEntity(url: musicModel.url);
  }
}