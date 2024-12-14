import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.login(user);
  }
}
