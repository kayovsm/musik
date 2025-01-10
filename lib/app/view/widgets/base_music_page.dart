import 'package:flutter/material.dart';
import 'package:musik/app/models/entities/playlist_entity.dart';
import 'package:musik/app/view/home_page.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/repositories/music_repository_impl.dart';
import '../player_page.dart';
import '../playlist_page.dart';
import 'bottom_sheet_widget.dart';
import 'videos_list_widget.dart';

abstract class BaseMusicPage extends StatefulWidget {
  final MusicRepositoryImpl musicRepository;
  final String userId;

  const BaseMusicPage({
    super.key,
    required this.musicRepository,
    required this.userId,
  });

  @override
  State<BaseMusicPage> createState() => _BaseMusicPageState();

  Future<List<String>> fetchYoutubeLinks();
}

class _BaseMusicPageState extends State<BaseMusicPage> {
  List<String> youtubeLinks = [];
  final List<YoutubePlayerController> _controllers = [];
  List<Map<String, String>> videoDetails = [];
  bool isLoading = true;
  YoutubePlayerController? _currentController;
  String? _currentTitle;
  String? _currentAuthor;
  String? _currentTime;
  List<PlaylistEntity> playlists = [];
  PlaylistEntity? selectedPlaylist;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _fetchPlaylists();
  }

  Future<void> _initializePlayer() async {
    youtubeLinks = await widget.fetchYoutubeLinks();
    final yt = YoutubeExplode();

    if (youtubeLinks.isNotEmpty) {
      for (var link in youtubeLinks) {
        final videoId = YoutubePlayer.convertUrlToId(link)!;
        final video = await yt.videos.get(videoId);
        final cleanedTitle = _cleanTitle(video.title, video.author);

        videoDetails.add({
          'title': cleanedTitle,
          'author': video.author,
          'id': videoId,
          'time': _formatDuration(video.duration!),
        });

        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            hideControls: true,
            controlsVisibleAtStart: false,
          ),
        );

        controller.addListener(() {
          if (controller.value.isReady && mounted) {
            setState(() {});
          }
        });

        _controllers.add(controller);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchPlaylists() async {
    playlists = await widget.musicRepository.getPlaylists(widget.userId);
    final favoritesPlaylist = playlists.firstWhere(
      (playlist) => playlist.name == 'Favoritos',
      orElse: () => PlaylistEntity(id: '', name: '', musicsUrl: []),
    );

    if (favoritesPlaylist.id.isEmpty) {
      final newFavoritesPlaylist = PlaylistEntity(
        id: DateTime.now().toString(),
        name: 'Favoritos',
        musicsUrl: [],
      );
      await widget.musicRepository
          .addPlaylist(widget.userId, newFavoritesPlaylist);
      playlists.add(newFavoritesPlaylist);
    }

    setState(() {
      selectedPlaylist = playlists.isNotEmpty ? playlists.first : null;
    });
  }

  String _cleanTitle(String title, String author) {
    title = title.replaceAll(author, '');
    title = title.replaceAll(RegExp(r'\(.*?\)'), '');
    title = title.replaceAll(RegExp(r'\[.*?\]'), '');
    title = title.replaceAll(RegExp(r'\{.*?\}'), '');
    title = title.replaceAll(RegExp(r'(^-)|(-$)|(\s-\s)'), ' ');
    title = title.trim();
    return title;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = duration.inMinutes.remainder(60).toString();
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${duration.inHours}:$minutes:$twoDigitSeconds";
    } else {
      return "$minutes:$twoDigitSeconds";
    }
  }

  void playAudio() {
    if (_currentController!.value.isPlaying) {
      _currentController!.pause();
    } else {
      _currentController!.play();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showBottomSheet(YoutubePlayerController controller, String title,
      String author, String time) {
    setState(() {
      _currentController = controller;
      _currentTitle = title;
      _currentAuthor = author;
      _currentTime = time;
    });
  }

  Future<void> _navigateToPlayerPage() async {
    if (_currentController != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerPage(
            musicRepository: widget.musicRepository,
            audioLink: _currentController!.metadata.videoId,
            controller: _currentController!,
          ),
        ),
      );

      if (result != null) {
        setState(() {
          _currentTitle = result['title'];
          _currentAuthor = result['author'];
          _currentTime = result['time'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APP MUSIK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addYoutubeLink,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: VideoListWidget(
                      controllers: _controllers,
                      videoDetails: videoDetails,
                      onTap: _showBottomSheet,
                    ),
                  ),
                  if (_currentController != null)
                    BottomSheetWidget(
                      controller: _currentController!,
                      title: _currentTitle ?? 'Título',
                      author: _currentAuthor ?? 'Autor',
                      onPlayPause: playAudio,
                      onNext: () {},
                      onPrevious: () {},
                      navigatorPlayer: _navigateToPlayerPage,
                    ),
                ],
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      userId: widget.userId,
                      musicRepository: widget.musicRepository,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_lesson_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistPage(
                      userId: widget.userId,
                      musicRepository: widget.musicRepository,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addYoutubeLink() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Adicionar link do YouTube'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Insira o link do YouTube',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PlaylistEntity>(
                value: selectedPlaylist,
                items: playlists.map((playlist) {
                  return DropdownMenuItem<PlaylistEntity>(
                    value: playlist,
                    child: Text(playlist.name),
                  );
                }).toList(),
                onChanged: (playlist) {
                  setState(() {
                    selectedPlaylist = playlist;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Escolha uma playlist',
                ),
              ),
              TextButton(
                onPressed: () {
                  _showCreatePlaylistDialog();
                },
                child: const Text('Criar nova playlist'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String link = controller.text;
                if (link.contains('?')) {
                  link = link.substring(0, link.indexOf('?'));
                }
                await widget.musicRepository
                    .addYoutubeLink(link, playlist: selectedPlaylist);
                final yt = YoutubeExplode();
                final videoId = YoutubePlayer.convertUrlToId(link)!;
                final video = await yt.videos.get(videoId);
                final cleanedTitle = _cleanTitle(video.title, video.author);

                setState(() {
                  videoDetails.add({
                    'title': cleanedTitle,
                    'author': video.author,
                    'id': videoId,
                    'time': _formatDuration(video.duration!),
                  });

                  final newController = YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      hideControls: true,
                      controlsVisibleAtStart: false,
                    ),
                  );

                  newController.addListener(() {
                    if (newController.value.isReady && mounted) {
                      setState(() {});
                    }
                  });

                  _controllers.add(newController);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePlaylistDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Criar nova playlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nome da playlist',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final playlistName = controller.text.trim();
                if (playlists
                    .any((playlist) => playlist.name == playlistName)) {
                  // Exibir mensagem de erro se a playlist já existir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Uma playlist com esse nome já existe.'),
                    ),
                  );
                } else {
                  final newPlaylist = PlaylistEntity(
                    id: playlistName, // Usar o nome da playlist como id
                    name: playlistName,
                    musicsUrl: [],
                  );
                  await widget.musicRepository
                      .addPlaylist(widget.userId, newPlaylist);
                  setState(() {
                    playlists.add(newPlaylist);
                    selectedPlaylist = newPlaylist;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }
}
