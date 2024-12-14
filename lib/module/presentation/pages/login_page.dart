import 'package:flutter/material.dart';
import 'package:musik/module/domain/entities/user_entity.dart';
import '../../../../widgets/app/text/input_text_app.dart';
import '../../../../widgets/app/asset/icons_app.dart';
import '../../../../widgets/app/button/button_text_app.dart';
import '../../../../widgets/app/color/color_app.dart';
import '../../../../widgets/app/text/description_text_app.dart';
import '../../../../widgets/app/text/title_text_app.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/music_repository_impl.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final MusicRepositoryImpl musicRepository;

  const LoginPage({super.key, required this.musicRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  Future<void> _login() async {
    try {
      await _authRepository.login(
        UserEntity(
            email: emailController.text.trim(),
            password: passwordController.text.trim()),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(musicRepository: widget.musicRepository),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao fazer login: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).buttonTheme.colorScheme?.primary ?? Colors.blue;
    final dialogBackgroundColor =
        Theme.of(context).dialogTheme.backgroundColor ?? Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildTopContent(),
            _buildBottomContent(dialogBackgroundColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          TitleTextApp(
            text: 'Musik',
            color: ColorApp.white,
            fontSize: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent(Color dialogBackgroundColor) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TitleTextApp(
                text: 'Login',
                fontSize: 24,
              ),
              const DescriptionTextApp(
                text: 'Informe seus dados de acesso',
              ),
              const SizedBox(height: 10),
              InputTextApp(
                label: 'Usuario',
                iconLeft: IconsApp.person,
                controller: emailController,
              ),
              const SizedBox(height: 8),
              InputTextApp(
                label: 'Senha',
                iconLeft: IconsApp.lock,
                controller: passwordController,
              ),
              const SizedBox(height: 15),
              ButtonTextApp(
                label: 'Entrar',
                onTap: _login,
              ),
              const SizedBox(height: 15),
              ButtonTextApp(
                label: 'Registrar',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignUpPage(musicRepository: widget.musicRepository),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
