import 'package:flutter/material.dart';

import '../asset/svg_asset_app.dart';
import '../preference/user_prefs_controller.dart';

class ButtonTextApp extends StatelessWidget {
  final String label;
  final Color? buttonColor;
  final Color? labelColor;
  final VoidCallback onTap;
  final String? buttonIcon;
  final double? iconHeight;
  final Color? colorIcon;
  final double? borderRadius;
  final bool oneLine;
  final bool fullWidth;

  const ButtonTextApp({
    super.key,
    required this.label,
    required this.onTap,
    this.buttonIcon,
    this.colorIcon,
    this.iconHeight,
    this.labelColor,
    this.buttonColor,
    this.borderRadius = 20,
    this.oneLine = true,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final userPrefsController = UserPrefsController();

    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = fullWidth ? screenWidth : null;
    final theme = Theme.of(context).buttonTheme.colorScheme;

    if (theme == null) {
      return const SizedBox.shrink();
    }

    final isTertiary = buttonColor == theme.tertiary;
    final primaryColor = theme.primary;
    final onPrimaryColor = theme.onPrimary;

    final fontSize = _getFontSize(userPrefsController.fontSizeOption);

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          width: buttonWidth,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: buttonColor ?? primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
            border: isTertiary ? Border.all(color: primaryColor) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buttonIcon != null) ...[
                SvgAssetApp(icon: buttonIcon!, color: colorIcon),
                const SizedBox(width: 5),
              ],
              oneLine
                  ? Center(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: labelColor ?? onPrimaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize,
                        ),
                      ),
                    )
                  : Flexible(
                      child: Center(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: labelColor ?? onPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  double _getFontSize(FontSizeOption option) {
    switch (option) {
      case FontSizeOption.small:
        return 15;
      case FontSizeOption.medium:
        return 16;
      case FontSizeOption.large:
        return 17;
      default:
        return 16;
    }
  }
}
