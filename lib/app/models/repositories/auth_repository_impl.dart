import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/user_entity.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String domain = '@musik.com';

  @override
  Future<void> login(UserEntity user) async {
    try {
      final email = '${user.email}$domain';
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: user.password,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> register(UserEntity user) async {
    try {
      final email = '${user.email}$domain';
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: user.password,
      );

      // Create a collection for the new user
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }
}
