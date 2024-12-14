import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login(UserEntity user);
  Future<void> register(UserEntity user);
  Future<void> signOut();
}
