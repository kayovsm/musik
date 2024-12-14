import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'module/data/repositories/music_repository_impl.dart';
import 'module/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseRepository = MusicRepositoryImpl();
  await firebaseRepository.initialize();
  runApp(MyApp(musicRepository: firebaseRepository));
}

class MyApp extends StatelessWidget {
  final MusicRepositoryImpl musicRepository;

  const MyApp({super.key, required this.musicRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musik',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(musicRepository: musicRepository),
    );
  }
}
