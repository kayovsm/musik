import 'package:flutter/material.dart';
import 'package:musik/app/view/widgets/controls_player_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/app/text/description_text_app.dart';
import '../../widgets/app/text/subtitle_text_app.dart';
import '../models/repositories/music_repository_impl.dart';

class PlayerPage extends StatefulWidget {
  final MusicRepositoryImpl musicRepository;
  final String audioLink;
  final YoutubePlayerController controller;

  const PlayerPage({
    super.key,
    required this.musicRepository,
    required this.audioLink,
    required this.controller,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final youtubeLinks = widget.musicRepository.getYoutubeLinks();

    print('LOG ** youtubeLinks: $youtubeLinks');
    print('LOG ** audioLink: ${widget.audioLink}');
    if (youtubeLinks.isNotEmpty) {
      _controller.addListener(() {
        if (_controller.value.isReady && mounted) {
          setState(() {
            isPlayerReady = true;
          });
        }
      });
      setState(() {
        isPlayerReady = true;
      });
    }
  }

  void _playAudio() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _nextAudio() {
    final youtubeLinks = widget.musicRepository.getYoutubeLinks();
    final int currentIndex = youtubeLinks
        .indexOf('https://youtu.be/${_controller.metadata.videoId}');

    print('LOG ** METADATA: ${_controller.metadata.videoId}');
    print('LOG ** NEXT currentIndex: $currentIndex');

    if (currentIndex < youtubeLinks.length - 1) {
      _controller
          .load(YoutubePlayer.convertUrlToId(youtubeLinks[currentIndex + 1])!);
    }
  }

  void _previousAudio() {
    final youtubeLinks = widget.musicRepository.getYoutubeLinks();
    final int currentIndex = youtubeLinks
        .indexOf('https://youtu.be/${_controller.metadata.videoId}');

    print('LOG ** PREVIOUS currentIndex: $currentIndex');

    if (currentIndex > 0) {
      _controller
          .load(YoutubePlayer.convertUrlToId(youtubeLinks[currentIndex - 1])!);
    }
  }

  void _returnToHomePage() {
    Navigator.pop(context, {
      'title': _controller.metadata.title,
      'author': _controller.metadata.author,
      'videoId': _controller.metadata.videoId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APP MUSIK'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _returnToHomePage,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: isPlayerReady
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(20)),
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        onReady: () => _controller.addListener(() {}),
                        onEnded: (metadata) => ControlsPlayerWidget(
                          controller: _controller,
                          firebaseRepository: widget.musicRepository,
                        ).nextAudio(),
                      ),
                    ),
                    SubTitleTextApp(text: _controller.metadata.title),
                    DescriptionTextApp(text: _controller.metadata.author),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ProgressBar(
                        controller: _controller,
                        colors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DescriptionTextApp(
                              text:
                                  '${(_controller.value.position.inMinutes % 60).toString().padLeft(2, '')}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}'),
                          DescriptionTextApp(
                              text:
                                  '${_controller.metadata.duration.inMinutes}:${(_controller.metadata.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: _previousAudio,
                        ),
                        IconButton(
                          icon: Icon(_controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: _playAudio,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: _nextAudio,
                        ),
                      ],
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
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
              onPressed: () {
                String link = controller.text;
                if (link.contains('?')) {
                  link = link.substring(0, link.indexOf('?'));
                }
                widget.musicRepository.addYoutubeLink(link);
                setState(() {
                  _initializePlayer();
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
