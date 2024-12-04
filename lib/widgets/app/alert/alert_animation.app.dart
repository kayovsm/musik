import 'package:flutter/material.dart';

class AlertAnimationApp extends StatefulWidget {
  final String image;

  const AlertAnimationApp({super.key, required this.image});

  @override
  _AlertAnimationAppState createState() => _AlertAnimationAppState();
}

class _AlertAnimationAppState extends State<AlertAnimationApp> {
  late Future<void> _delayFuture;

  @override
  void initState() {
    super.initState();
    _delayFuture = Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _delayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            content: Container(
              child: Image.asset(
                'assets/gifs/${widget.image}',
                height: 100,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
