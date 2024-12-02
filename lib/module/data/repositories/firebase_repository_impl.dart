import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseRepositoryImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getYoutubeLinks() async {
    final snapshot = await firestore.collection('music').get();
    return snapshot.docs.map((doc) => doc['music_url'] as String).toList();
  }

  Future<String> convertToMp3(String youtubeUrl) async {
    try {
      // final response = await http.post(
      //   Uri.parse('https://convert-mp3-lqtd1r4wc-kayo-devs-projects.vercel.app/convert_get'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer prj_BEIzUNh4B5MZ4Smqe019C0WUKTqJ', // Substitua pelo seu token de API ou chave de API
      //   },
      //   body: json.encode({'video_url': youtubeUrl}),
      // );

final response = await http.post(
  Uri.parse('https://convert-mp3-lqtd1r4wc-kayo-devs-projects.vercel.app/convert'),
  headers: {
    'Content-Type': 'application/json',
  },
  body: json.encode({'video_url': 'https://youtu.be/WcTRQXtXJPs'}),
);

print('Response body: ${response.body}');
print('Response status code: ${response.statusCode}');



      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['mp3Url'];
      } else {
        print('Failed to convert YouTube link to MP3: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to convert YouTube link to MP3');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to convert YouTube link to MP3');
    }
  }
}
