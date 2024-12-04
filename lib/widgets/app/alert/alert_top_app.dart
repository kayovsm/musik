import 'package:flutter/material.dart';

import '../asset/icons_app.dart';
import '../asset/svg_asset_app.dart';
import '../color/color_app.dart';
import '../text/description_text_app.dart';
import '../text/subtitle_text_app.dart';

class AlertTopApp {
  void showNotificationTop({
    required BuildContext context,
    required String? icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ColorApp.blackLightMode, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: SvgAssetApp(icon: icon, color: ColorApp.white),
                        ),
                      SubTitleTextApp(color: textColor, text: title),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
                  child: Center(
                    child: DescriptionTextApp(text: description, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  void success({required BuildContext context, required String title, required String message}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    showNotificationTop(
      context: context,
      icon: IconsApp.checkCircle,
      title: title,
      description: message,
      backgroundColor: isDarkTheme
          ? ColorApp.alertSuccessLightMode
          : ColorApp.alertSuccessLightMode,
      textColor: isDarkTheme ? ColorApp.white : ColorApp.white,
    );
  }

  void error({required BuildContext context, required String title, required String message}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    showNotificationTop(
      context: context,
      icon: IconsApp.info,
      title: title,
      description: message,
      backgroundColor: isDarkTheme
          ? ColorApp.alertErrorDarkMode
          : ColorApp.alertErrorLightMode,
      textColor: isDarkTheme ? ColorApp.white : ColorApp.white,
    );
  }
}