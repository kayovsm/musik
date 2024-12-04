import 'package:flutter/material.dart';

import '../button/button_text_app.dart';
import '../color/color_app.dart';
import '../device/device_type_app.dart';
import '../text/description_text_app.dart';
import '../text/title_text_app.dart';

class AlertCenterApp {
  Future<List<dynamic>?> select({
    required BuildContext context,
    required String title,
    required String description,
    required String leftButtonLabel,
    required String rightButtonLabel,
    required List<String> options,
    required bool oneSelect,
  }) {
    List<String> selectedOptions = [];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogWidth = _getDialogWidth(screenWidth);

    return showDialog<List<dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: TitleTextApp(text: title)),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                DescriptionTextApp(text: description),
                Flexible(
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            ...options.map((option) {
                              return _buildOptions(
                                context,
                                option,
                                selectedOptions,
                                oneSelect,
                                (String option) {
                                  setState(() {
                                    if (oneSelect) {
                                      selectedOptions.clear();
                                      selectedOptions.add(option);
                                    } else {
                                      if (selectedOptions.contains(option)) {
                                        selectedOptions.remove(option);
                                      } else {
                                        selectedOptions.add(option);
                                      }
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonTextApp(
                    label: leftButtonLabel,
                    buttonColor:
                        Theme.of(context).buttonTheme.colorScheme!.secondary,
                    onTap: () {
                      if (selectedOptions.isEmpty) {
                        Navigator.of(context).pop([1, null]);
                      } else {
                        Navigator.of(context).pop([
                          1,
                          oneSelect ? selectedOptions.first : selectedOptions
                        ]);
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ButtonTextApp(
                    label: rightButtonLabel,
                    buttonColor:
                        Theme.of(context).buttonTheme.colorScheme!.primary,
                    onTap: () {
                      if (selectedOptions.isEmpty) {
                        Navigator.of(context).pop([1, null]);
                      } else {
                        Navigator.of(context).pop([
                          2,
                          oneSelect ? selectedOptions.first : selectedOptions
                        ]);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: const EdgeInsets.all(20),
          insetPadding: EdgeInsets.symmetric(
            horizontal: (screenWidth - dialogWidth) / 2,
            vertical: screenHeight * 0.1,
          ),
        );
      },
    );
  }

  Future<List<dynamic>?> confirm({
    required BuildContext context,
    required String title,
    required String description,
    required String leftButtonLabel,
    required String rightButtonLabel,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogWidth = _getDialogWidth(screenWidth);

    return showDialog<List<dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: TitleTextApp(text: title)),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DescriptionTextApp(text: description),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonTextApp(
                    label: leftButtonLabel,
                    buttonColor:
                        Theme.of(context).buttonTheme.colorScheme!.secondary,
                    onTap: () => Navigator.of(context).pop([1, null]),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ButtonTextApp(
                    label: rightButtonLabel,
                    buttonColor:
                        Theme.of(context).buttonTheme.colorScheme!.primary,
                    onTap: () => Navigator.of(context).pop([2, null]),
                  ),
                ),
              ],
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: const EdgeInsets.all(20),
          insetPadding: EdgeInsets.symmetric(
            horizontal: (screenWidth - dialogWidth) / 2,
            vertical: screenHeight * 0.1,
          ),
        );
      },
    );
  }

  Widget _buildOptions(
      BuildContext context,
      String label,
      List<String> selectedOptions,
      bool oneSelect,
      Function(String) onOptionSelected) {
    bool isSelected = selectedOptions.contains(label);
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onOptionSelected(label),
      child: Container(
        width: screenWidth,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).buttonTheme.colorScheme!.primary
                : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Theme.of(context).buttonTheme.colorScheme!.primary
              : Colors.transparent,
        ),
        child: Center(
          child: DescriptionTextApp(
            text: label,
            color: isSelected
                ? ColorApp.white
                : Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }

  double _getDialogWidth(double screenWidth) {
    Device deviceType = DeviceTypeApp().getDeviceType(screenWidth);
    switch (deviceType) {
      case Device.mobile:
        return screenWidth - 40;
      case Device.tablet:
        return screenWidth - 150;
      case Device.desktop:
        return 400;
      default:
        return screenWidth - 40;
    }
  }
}