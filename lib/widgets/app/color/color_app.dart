import 'package:flutter/material.dart';

class ColorApp {
  ColorApp._privateConstructor();

  static final ColorApp _instance = ColorApp._privateConstructor();

  factory ColorApp() {
    return _instance;
  }

  // STATIC COLOR
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF616161);
  static const transparent = Colors.transparent;
  static const red = Color(0xFFE9523F);
  static const blue = Color(0xFF313586);

  static const cardBopm = Color(0xFFE9523F);
  static const cardTco = Color(0xFFF7B749);
  static const cardLibrary = Color(0xFF1991FF);

  static const finishedLightMode = Color(0xFF313586);
  static const pedingLightMode = Color(0xFFE9523F);
  static const lockLightMode = Color(0xFFA5A5A5);
  static const finishedDarkMode = Color(0xFF005DB2);
  static const pedingDarkMode = Color(0xFFE9523F);
  static const lockDarkMode = Color(0xFF616161);

  static const finished = Color(0xFF005DB2);
  static const peding = Color(0xFFE9523F);
  static const lock = Color(0xFF616161);

  // LIGHT MODE

  static const greyLightMode = Color(0xFFB6B4B4);
  static const backgroundLightMode = Color(0xFFFFFFFF);
  static const whiteLightMode = Color(0xFFFEFEFE);
  static const blackLightMode = Color(0xFF474747);

  static const blueLightMode = Color(0xFF005DB2);

  static const dialogBackgroundColorLightMode = Color(0xFFEBEBEB);

  static const alertSuccessLightMode = Color(0xFF005DB2);
  static const alertErrorLightMode = Color(0xFFE9523F);

  static const cardLightMode = Color(0xFFEBEBEB);
  static const borderCardLightMode = Color(0xFF303136);
  static const appBarLightMode = Color(0xFF005DB2);
  static const iconLightMode = Color(0xFF474747);

  static const textTitleLightMode = Color(0xFF000000);
  static const textSubtitleLightMode = Color(0xFF969696);

  static const buttonPrimaryLightMode = Color(0xFF005DB2);
  static const buttonSecondaryLightMode = Color(0xFFE9523F);

  static const buttonTertiaryLightMode = Colors.transparent;

  static const focusButtonLightMode = Color(0xFF005DB2);

  static const floatingButtonLightMode = Color(0xFF005DB2);

  static const chipLightMode = Color(0xFFEBEBEB);

  // DARK MODE

  static const greyDarkMode = Color(0xFF616161);

  static const backgroundDarkMode = Color(0xFF17181A);
  static const whiteDarkMode = Color(0xFFFEFEFE);
  static const blackDarkMode = Color(0xFF2E2E2E);

  // static const blueDarkMode = Color(0xFF313586);

  static const dialogBackgroundColorDarkMode = Color(0xFF17181A);

  // ALERT
  static const alertSuccessDarkMode = Color(0xFF3D76F1);
  static const alertErrorDarkMode = Color(0xFFE9523F);

  static const cardDarkMode = Color(0xFF303136);
  static const borderCardDarkMode = Color(0xFF8D8D8D);

  static const appBarDarkMode = Color(0xFF005DB2);
  // static const appBarDarkMode = Color(0xFFDDE9FC);
  static const iconDarkMode = Color(0xFFFEFEFE);

  static const textTitleDarkMode = Color(0xFFFEFEFE);
  static const textSubtitleDarkMode = Color(0xFF8D8D8D);

  static const buttonPrimaryDarkMode = Color(0xFF005DB2);
  static const buttonSecondaryDarkMode = Color(0xFFE9523F);
  static const buttonTertiaryDarkMode = Colors.transparent;

  static const focusButtonDarkMode = Color(0xFF005DB2);
  static const focusTextDarkMode = Color(0xFFD5D4D4);

  static const floatingButtonDarkMode = Color(0xFF005DB2);
  static const chipDarkMode = Color(0xFF303136);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: ColorApp.buttonPrimaryLightMode,
      colorScheme: ColorScheme.light(
        primary: ColorApp.buttonPrimaryLightMode,
      ),
      canvasColor: ColorApp.backgroundLightMode,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: ColorApp.textTitleLightMode),
        bodyMedium: TextStyle(color: ColorApp.textSubtitleLightMode),
      ),
      appBarTheme: AppBarTheme(
        color: ColorApp.appBarLightMode,
        iconTheme: IconThemeData(
          color: ColorApp.iconLightMode,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorApp.iconLightMode,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ColorApp.dialogBackgroundColorLightMode,
      ),
      cardTheme: CardTheme(
        color: ColorApp.cardLightMode,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorApp.borderCardLightMode,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ColorApp.chipLightMode,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorApp.chipLightMode,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        secondaryLabelStyle: TextStyle(
          color: ColorApp.whiteLightMode,
        ),
        brightness: Brightness.light,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorApp.floatingButtonLightMode,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
          primary: ColorApp.buttonPrimaryLightMode,
          secondary: ColorApp.buttonSecondaryDarkMode,
          tertiary: ColorApp.transparent,
          onPrimary: ColorApp.whiteLightMode,
          onTertiary: ColorApp.blackLightMode,
        ),
      ),
      focusColor: ColorApp.focusButtonLightMode,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: ColorApp.buttonPrimaryDarkMode,
      colorScheme: ColorScheme.dark(
        primary: ColorApp.buttonPrimaryDarkMode,
      ),
      canvasColor: ColorApp.backgroundDarkMode,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: ColorApp.textTitleDarkMode),
        bodyMedium: TextStyle(color: ColorApp.textSubtitleDarkMode),
      ),
      appBarTheme: AppBarTheme(
        color: ColorApp.appBarDarkMode,
        iconTheme: IconThemeData(
          color: ColorApp.iconDarkMode,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorApp.iconDarkMode,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ColorApp.dialogBackgroundColorDarkMode,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorApp.floatingButtonDarkMode,
      ),
      cardTheme: CardTheme(
        color: ColorApp.cardDarkMode,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorApp.borderCardDarkMode,
            width: 1,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ColorApp.chipDarkMode,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        secondaryLabelStyle: TextStyle(
          color: ColorApp.whiteDarkMode,
        ),
        brightness: Brightness.dark,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark(
          primary: ColorApp.buttonPrimaryDarkMode,
          secondary: ColorApp.buttonSecondaryDarkMode,
          tertiary: ColorApp.transparent,
          onPrimary: ColorApp.whiteDarkMode,
          onTertiary: ColorApp.whiteDarkMode,
        ),
      ),
      focusColor: ColorApp.focusButtonDarkMode,
    );
  }
}
