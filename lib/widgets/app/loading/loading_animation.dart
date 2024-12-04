import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../text/subtitle_text_app.dart';

class LoadingAnimation extends StatelessWidget {
  final String message;

  const LoadingAnimation({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).buttonTheme.colorScheme!.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadingAnimationWidget.staggeredDotsWave(
                color: primaryColor,
                size: 60,
              ),
              SizedBox(height: 10),
              SubTitleTextApp(text: message),
            ],
          ),
        ),
      ),
    );
  }
}
