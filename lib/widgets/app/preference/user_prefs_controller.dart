import 'package:flutter/material.dart';

enum FontSizeOption { small, medium, large }

class UserPrefsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  FontSizeOption _fontSizeOption = FontSizeOption.medium;

  ThemeMode get themeMode => _themeMode;
  FontSizeOption get fontSizeOption => _fontSizeOption;

  UserPrefsController() {
    _loadUserPreferences();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveUserPreferences();
    notifyListeners();
  }

  Future<void> setFontSize(FontSizeOption option) async {
    _fontSizeOption = option;
    print('FONT SIZE SET: ${option.toString().split('.').last}');
    await _saveUserPreferences();
    notifyListeners();
  }

  Future<void> _saveUserPreferences() async {
    String fontSize = _fontSizeOption.toString().split('.').last;
    String theme = _themeMode.toString().split('.').last;
    // await UserDataDB().saveUserPreferences(fontSize, theme);
  }

  Future<void> _loadUserPreferences() async {
    Map<String, String> preferences = {'fontSize': 'medium', 'theme': 'light'}; // valor padrão
    _fontSizeOption = FontSizeOption.values.firstWhere(
        (e) => e.toString().split('.').last == preferences['fontSize']);
    _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString().split('.').last == preferences['theme']);
    notifyListeners();
  }
}