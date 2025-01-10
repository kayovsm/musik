import 'package:flutter/material.dart';
import '../preference/user_prefs_controller.dart';

class SubTitleTextApp extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final bool oneLine;

  const SubTitleTextApp({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.color,
    this.fontSize,
    this.oneLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final userPrefsController = UserPrefsController();
    double fontSize;

    if (this.fontSize != null) {
      fontSize = this.fontSize!;
    } else {
      switch (userPrefsController.fontSizeOption) {
        case FontSizeOption.small:
          fontSize = 15;
          break;
        case FontSizeOption.medium:
          fontSize = 16.5;
          break;
        case FontSizeOption.large:
          fontSize = 18;
          break;
      }
    }

    return Text(
      text!,
      textAlign: textAlign,
      maxLines: oneLine ? 1 : null,
      overflow: oneLine ? TextOverflow.ellipsis : TextOverflow.visible,
      softWrap: oneLine ? false : true,
      style: TextStyle(
        fontFamily: 'Ubuntu',
        color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        decoration: TextDecoration.none,
      ),
    );
  }
}
