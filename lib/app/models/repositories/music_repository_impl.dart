import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/playlist_entity.dart';

class MusicRepositoryImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _youtubeLinks = [];

  Future<void> initialize() async {
    try {
      _youtubeLinks = await getYoutubeLinksFromFirebase();
    } catch (e) {
      // Handle the exception gracefully
      print('Error initializing music repository: $e');
    }
  }

  Future<List<String>> getYoutubeLinksFromFirebase() async {
  final user = auth.currentUser;
  if (user == null) {
    throw Exception('No user is currently logged in.');
  }

  final snapshot = await firestore
      .collection('users')
      .doc(user.uid)
      .collection('playlist')
      .where('name', isEqualTo: 'Favoritos')
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) {
    throw Exception('Favoritos playlist not found.');
  }

  final favoritesPlaylist = snapshot.docs.first;
  return List<String>.from(favoritesPlaylist['musics_url']);
}

  // Future<List<String>> getYoutubeLinksFromFirebase() async {
  //   final user = auth.currentUser;
  //   if (user == null) {
  //     throw Exception('No user is currently logged in.');
  //   }

  //   final snapshot = await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('playlist')
  //       .get();
  //   return snapshot.docs.map((doc) => doc['music_url'] as String).toList();
  // }

  List<String> getYoutubeLinks() {
    return _youtubeLinks;
  }

  Future<void> addYoutubeLink(String url, {PlaylistEntity? playlist}) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    if (playlist != null) {
      // Adicionar música à playlist
      playlist.musicsUrl.add(url);
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('playlist')
          .doc(playlist.id)
          .set({
        'name': playlist.name,
        'musics_url': playlist.musicsUrl,
      });
    } else {
      // Adicionar música à coleção de músicas do usuário
      await firestore.collection('users').doc(user.uid).collection('music').add({
        'music_url': url,
      });
      _youtubeLinks.add(url);
    }
  }

  Future<List<PlaylistEntity>> getPlaylists(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('playlist')
          .get();
      return querySnapshot.docs
          .map((doc) => PlaylistEntity(
                id: doc.id,
                name: doc['name'],
                musicsUrl: List<String>.from(doc['musics_url']),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch playlists: $e');
    }
  }

  Future<void> addPlaylist(String userId, PlaylistEntity playlist) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('playlist')
          .doc(playlist.id)
          .set({
        'name': playlist.name,
        'musics_url': playlist.musicsUrl,
      });
    } catch (e) {
      throw Exception('Failed to add playlist: $e');
    }
  }
}