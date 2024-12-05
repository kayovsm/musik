import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../widgets/app/color/color_app.dart';
import '../../../widgets/app/text/description_text_app.dart';
import '../../../widgets/app/text/subtitle_text_app.dart';
import '../../data/repositories/firebase_repository_impl.dart';
import 'player_page.dart';

class HomePage extends StatefulWidget {
  final FirebaseRepositoryImpl firebaseRepository;

  const HomePage({required this.firebaseRepository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> youtubeLinks = [];
  List<YoutubePlayerController> _controllers = [];
  List<Map<String, String>> videoDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    youtubeLinks = await widget.firebaseRepository.getYoutubeLinks();
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

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
            : ListView.builder(
                itemCount: youtubeLinks.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAudioPlayer(
                          _controllers[index], videoDetails[index]),
                    ],
                  );
                },
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
                widget.firebaseRepository.addYoutubeLink(link);
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

  Widget _buildAudioPlayer(
      YoutubePlayerController controller, Map<String, String> videoDetail) {
    return GestureDetector(
      onTap: () {
        print('LOG ** TAP ${videoDetail['id']}');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerPage(
              audioLink: videoDetail['id']!,
              firebaseRepository: widget.firebaseRepository,
            ),
          ),
        );
      },
      child: Row(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: false,
            aspectRatio: 8 / 5,
            width: 100,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTitleTextApp(
                    text: videoDetail['title'] ?? 'Carregando...',
                    oneLine: true,
                  ),
                  DescriptionTextApp(
                    text: videoDetail['author'] ?? 'Carregando...',
                    oneLine: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
