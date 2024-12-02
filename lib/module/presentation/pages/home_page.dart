import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/repositories/firebase_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FirebaseRepositoryImpl firebaseRepository = FirebaseRepositoryImpl();
  List<String> musicUrls = [];
  int currentTrackIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final youtubeLinks = await firebaseRepository.getYoutubeLinks();
      for (var link in youtubeLinks) {
        final mp3Url = await firebaseRepository.convertToMp3(link);
        musicUrls.add(mp3Url);
      }
      if (musicUrls.isNotEmpty) {
        await _audioPlayer.setSourceUrl(musicUrls[currentTrackIndex]);
      }
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextTrack() {
    if (currentTrackIndex < musicUrls.length - 1) {
      currentTrackIndex++;
      _audioPlayer.setSourceUrl(musicUrls[currentTrackIndex]);
      _audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _previousTrack() {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      _audioPlayer.setSourceUrl(musicUrls[currentTrackIndex]);
      _audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _playPause,
              child: Text(isPlaying ? 'Pause' : 'Play'),
            ),
            ElevatedButton(
              onPressed: _previousTrack,
              child: Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _nextTrack,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}