import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MusicRepositoryImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _youtubeLinks = [];

  Future<void> initialize() async {
    _youtubeLinks = await getYoutubeLinksFromFirebase();
  }

  Future<List<String>> getYoutubeLinksFromFirebase() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('music')
        .get();
    return snapshot.docs.map((doc) => doc['music_url'] as String).toList();
  }

  List<String> getYoutubeLinks() {
    return _youtubeLinks;
  }

  Future<void> addYoutubeLink(String url) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    await firestore.collection('users').doc(user.uid).collection('music').add({
      'music_url': url,
    });
    _youtubeLinks.add(url);
  }
}
