// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../entities/playlist_entity.dart';
// import 'playlist_repository.dart';

// class PlaylistRepositoryImpl implements PlaylistRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Future<List<PlaylistEntity>> getPlaylists(String userId) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('playlist')
//           .get();
//       return querySnapshot.docs
//           .map((doc) => PlaylistEntity(
//                 id: doc.id,
//                 name: doc['name'],
//                 musicsUrl: List<String>.from(doc['musics_url']),
//               ))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch playlists: $e');
//     }
//   }

//   @override
//   Future<void> addPlaylist(String userId, PlaylistEntity playlist) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('playlist')
//           .doc(playlist.id)
//           .set({
//         'name': playlist.name,
//         'musics_url': playlist.musicsUrl,
//       });
//     } catch (e) {
//       throw Exception('Failed to add playlist: $e');
//     }
//   }
// }