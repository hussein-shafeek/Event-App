import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  String languageCode = 'en';
  bool get isDark => themeMode == ThemeMode.dark;
  void changeTheme(ThemeMode theme) {
    themeMode = theme;
    notifyListeners();
  }

  void changrLanguage(String language) {
    if (languageCode == language) return;
    languageCode = language;
    notifyListeners();
  }

  static void of(BuildContext context, {required bool listen}) {}
}
