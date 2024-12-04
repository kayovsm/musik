import 'package:flutter/material.dart';
import '../preference/user_prefs_controller.dart';

class DescriptionTextApp extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final bool oneLine;
  final double? fontSize;

  const DescriptionTextApp({
    super.key,
    required this.text,
    this.color,
    this.textAlign = TextAlign.start,
    this.oneLine = false,
    this.fontSize,
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
        fontWeight: FontWeight.w500,
        fontSize: oneLine ? fontSize - 1 : fontSize,
      ),
    );
  }
}