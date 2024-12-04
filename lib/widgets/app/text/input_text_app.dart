import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../asset/icons_app.dart';
import '../color/color_app.dart';
import '../device/device_type_app.dart';
import 'description_text_app.dart';

class InputTextApp extends StatelessWidget {
  final String label;
  final double? width;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxChar;
  final FocusNode? focusNode;
  final bool isRequired;
  final String? iconLeft;
  final TextInputFormatter? inputFormatter;

  const InputTextApp({
    super.key,
    this.width,
    required this.label,
    this.onChanged,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxChar,
    this.focusNode,
    this.isRequired = false,
    this.iconLeft,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Device deviceType = DeviceTypeApp().getDeviceType(screenWidth);
    double maxW;

    switch (deviceType) {
      case Device.mobile:
        maxW = screenWidth;
        break;
      case Device.tablet:
        maxW = screenWidth;
        break;
      case Device.desktop:
        maxW = 600;
        break;
    }

    bool required = isRequired ? controller.text.isEmpty : false;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: Container(
        width: width ?? screenWidth,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Theme.of(context).textTheme.bodyMedium!.color!,
                maxLength: maxChar,
                maxLines: null,
                controller: controller,
                onChanged: onChanged,
                keyboardType: keyboardType,
                focusNode: focusNode,
                inputFormatters: [
                  if (inputFormatter != null) inputFormatter!,
                  NoLeadingSpacesFormatter(),
                ],
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: required
                      ? Padding(
                          padding: const EdgeInsetsDirectional.all(12),
                          child: SvgPicture.asset(
                            IconsApp.warningAmber,
                            height: 22,
                            color: ColorApp.red,
                          ),
                        )
                      : iconLeft != null
                          ? Padding(
                              padding: const EdgeInsetsDirectional.all(12),
                              child: SvgPicture.asset(
                                iconLeft!,
                                height: 22,
                                color: ColorApp.grey,
                              ),
                            )
                          : null,
                  fillColor: ColorApp.transparent,
                  label: DescriptionTextApp(
                    text: label,
                    color: Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyMedium!.color!,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// remove espaços no início do texto
class NoLeadingSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.trimLeft();
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
