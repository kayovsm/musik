import 'package:flutter/material.dart';
import '../models/repositories/music_repository_impl.dart';
import 'widgets/base_music_page.dart';

class HomePage extends BaseMusicPage {
  const HomePage({
    super.key,
    required MusicRepositoryImpl musicRepository,
    required String userId,
  }) : super(musicRepository: musicRepository, userId: userId);

  @override
  Future<List<String>> fetchYoutubeLinks() async {
    return await musicRepository.getYoutubeLinks();
  }
}