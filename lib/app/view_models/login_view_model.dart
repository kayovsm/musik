import 'package:flutter/material.dart';

import '../models/entities/user_entity.dart';
import '../models/repositories/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository authRepository;

  LoginViewModel({required this.authRepository});

  Future<void> login(String email, String password) async {
    final user = UserEntity(email: email, password: password);

    try {
      await authRepository.login(user);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
