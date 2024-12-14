import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/repositories/music_repository_impl.dart';
import '../widgets/bottom_sheet_widget.dart';
import '../widgets/videos_list_widget.dart';
import '../pages/player_page.dart';

class HomePage extends StatefulWidget {
  final MusicRepositoryImpl musicRepository;

  const HomePage({super.key, required this.musicRepository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> youtubeLinks = [];
  final List<YoutubePlayerController> _controllers = [];
  List<Map<String, String>> videoDetails = [];
  bool isLoading = true;
  YoutubePlayerController? _currentController;
  String? _currentTitle;
  String? _currentAuthor;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    youtubeLinks = await widget.musicRepository.getYoutubeLinks();
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
        });

        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            hideControls: true, // Desativa os controles padrão do YouTube
            controlsVisibleAtStart:
                false, // Desativa a visibilidade inicial dos controles
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

  String _cleanTitle(String title, String author) {
    // Remove o nome do autor do título
    title = title.replaceAll(author, '');
    // Remove texto dentro de parênteses, colchetes e chaves
    title = title.replaceAll(RegExp(r'\(.*?\)'), '');
    title = title.replaceAll(RegExp(r'\[.*?\]'), '');
    title = title.replaceAll(RegExp(r'\{.*?\}'), '');

    // Remove hífen no início ou no final do título, ou entre espaços
    title = title.replaceAll(RegExp(r'(^-)|(-$)|(\s-\s)'), ' ');

    // Remove espaços extras
    title = title.trim();
    return title;
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

  void _showBottomSheet(
      YoutubePlayerController controller, String title, String author) {
    setState(() {
      _currentController = controller;
      _currentTitle = title;
      _currentAuthor = author;
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APP MUSIK'),
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
              icon: const Icon(Icons.add),
              onPressed: _addYoutubeLink,
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
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Insira o link do YouTube',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String link = controller.text;
                if (link.contains('?')) {
                  link = link.substring(0, link.indexOf('?'));
                }
                widget.musicRepository.addYoutubeLink(link);
                final yt = YoutubeExplode();
                final videoId = YoutubePlayer.convertUrlToId(link)!;
                final video = await yt.videos.get(videoId);
                final cleanedTitle = _cleanTitle(video.title, video.author);
                videoDetails.add({
                  'title': cleanedTitle,
                  'author': video.author,
                });

                setState(() {
                  youtubeLinks.add(link);
                  final newController = YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      hideControls:
                          true, // Desativa os controles padrão do YouTube
                      controlsVisibleAtStart:
                          false, // Desativa a visibilidade inicial dos controles
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
}
