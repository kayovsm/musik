import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'module/data/repositories/firebase_repository_impl.dart';
import 'module/presentation/pages/old_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseRepository = FirebaseRepositoryImpl();
  await firebaseRepository.initialize();
  runApp(MyApp(firebaseRepository: firebaseRepository));
}

class MyApp extends StatelessWidget {
  final FirebaseRepositoryImpl firebaseRepository;

  const MyApp({super.key, required this.firebaseRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(firebaseRepository: firebaseRepository),
    );
  }
}
