import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode(bool value) {
    _isDarkModeEnabled = value;
    notifyListeners();
  }
}

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'Español';

  String get selectedLanguage => _selectedLanguage;

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
