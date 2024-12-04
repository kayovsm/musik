import 'package:flutter/material.dart';

enum Device { mobile, tablet, desktop }

class DeviceTypeApp {
  Device getDeviceType(double width) {
    if (width < 600) {
      return Device.mobile;
    } else if (width > 600 && width < 1200) {
      return Device.tablet;
    } else {
      return Device.desktop;
    }
  }

  double getIconSize(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    Device deviceType = DeviceTypeApp().getDeviceType(screenW);
    double iconH;

    switch (deviceType) {
      case Device.mobile:
        iconH = 30;
        break;
      case Device.tablet:
        iconH = 36;
        break;
      case Device.desktop:
        iconH = 38;
        break;
    }
    return iconH;
  }

  double getFontSize(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    Device deviceType = DeviceTypeApp().getDeviceType(screenW);
    double fontSize;
    switch (deviceType) {
      case Device.mobile:
        fontSize = 16;
        break;
      case Device.tablet:
        fontSize = 18;
        break;
      case Device.desktop:
        fontSize = 18;
        break;
    }
    return fontSize;
  }

  double getPaddingBody(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    Device deviceType = getDeviceType(screenW);
    double paddingH;
    switch (deviceType) {
      case Device.mobile:
        paddingH = 18;
        break;
      case Device.tablet:
        paddingH = 50;
        break;
      case Device.desktop:
        paddingH = 80;
        break;
    }
    return paddingH;
  }

  double getPaddingAppBar(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    Device deviceType = getDeviceType(screenW);
    double paddingH;

    switch (deviceType) {
      case Device.mobile:
        paddingH = 0;
        break;
      case Device.tablet:
        paddingH = 25;
        break;
      case Device.desktop:
        paddingH = 25;
        break;
    }
    return paddingH;
  }
}
