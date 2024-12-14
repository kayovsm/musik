import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginProvider with ChangeNotifier {
  final Login loginUseCase;

  LoginProvider({required this.loginUseCase});

  Future<void> login(String email, String password) async {
    final user = UserEntity(email: email, password: password);
    try {
      await loginUseCase.call(user);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
