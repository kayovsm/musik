import 'package:flutter/material.dart';

import '../asset/svg_asset_app.dart';
import '../color/color_app.dart';

class ButtonIconApp extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double? iconH;
  final double? borderRadius;
  final Color? backgroundColor;
  final double? margin;

  const ButtonIconApp({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor = ColorApp.white,
    this.iconH,
    this.borderRadius = 16,
    this.margin = 0,
    this.backgroundColor = ColorApp.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(margin!),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: SvgAssetApp(icon: icon, color: iconColor),
      ),
    );
  }
}
