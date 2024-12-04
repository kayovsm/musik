import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepositoryImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> _youtubeLinks = [];

  Future<void> initialize() async {
    _youtubeLinks = await getYoutubeLinksFromFirebase();
  }

  Future<List<String>> getYoutubeLinksFromFirebase() async {
    final snapshot = await firestore.collection('music').get();
    return snapshot.docs.map((doc) => doc['music_url'] as String).toList();
  }

  List<String> getYoutubeLinks() {
    return _youtubeLinks;
  }

  Future<void> addYoutubeLink(String url) async {
    await firestore.collection('music').add({'music_url': url});
    _youtubeLinks.add(url);
  }
}