import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseRepositoryImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getYoutubeLinks() async {
    final snapshot = await firestore.collection('music').get();
    return snapshot.docs.map((doc) => doc['music_url'] as String).toList();
  }

  Future<void> addYoutubeLink(String url) async {
    await firestore.collection('music').add({'music_url': url});
  }
}
