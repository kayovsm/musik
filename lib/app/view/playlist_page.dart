import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/repositories/music_repository_impl.dart';
import '../models/entities/playlist_entity.dart';
import 'widgets/playlist_list_widget.dart';

class PlaylistPage extends StatefulWidget {
  final String userId;
  final MusicRepositoryImpl musicRepository;

  PlaylistPage({
    super.key,
    required this.userId,
    required this.musicRepository,
  });

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<PlaylistEntity> playlists = [];
  bool isLoading = true;
  PlaylistEntity? selectedPlaylist;

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    try {
      playlists = await widget.musicRepository.getPlaylists(widget.userId);
      setState(() {
        selectedPlaylist = playlists.isNotEmpty ? playlists.first : null;
      });
    } catch (e) {
      print('Failed to fetch playlists: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addPlaylist(String name) async {
    final newPlaylist = PlaylistEntity(
      id: name, // Usar o nome da playlist como id
      name: name,
      musicsUrl: [],
    );
    try {
      await widget.musicRepository.addPlaylist(widget.userId, newPlaylist);
      setState(() {
        playlists.add(newPlaylist);
        selectedPlaylist = newPlaylist;
      });
    } catch (e) {
      print('Failed to add playlist: $e');
    }
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
                await widget.musicRepository.addYoutubeLink(link, playlist: selectedPlaylist);
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
                if (playlists.any((playlist) => playlist.name == playlistName)) {
                  // Exibir mensagem de erro se a playlist já existir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Uma playlist com esse nome já existe.'),
                    ),
                  );
                } else {
                  _addPlaylist(playlistName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addYoutubeLink,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PlaylistListWidget(
                    playlists: playlists,
                    userId: widget.userId,
                    musicRepository: widget.musicRepository,
                  ),
                ),
              ],
            ),
    );
  }
}