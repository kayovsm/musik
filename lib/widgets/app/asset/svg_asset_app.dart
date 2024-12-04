import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../preference/user_prefs_controller.dart';

class SvgAssetApp extends StatelessWidget {
  final String icon;
  Color? color;
  double? iconHeight;

  SvgAssetApp({
    super.key,
    required this.icon,
    this.iconHeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final userPrefsController = UserPrefsController();
    double iconH;

    switch (userPrefsController.fontSizeOption) {
      case FontSizeOption.small:
        iconH = 24;
        break;
      case FontSizeOption.medium:
        iconH = 28;
        break;
      case FontSizeOption.large:
        iconH = 32;
        break;
      default:
        iconH = 24;
    }

    return SvgPicture.asset(
      icon,
      height: iconHeight ?? iconH,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}
