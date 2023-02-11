import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ChatThemeProvider extends ChangeNotifier {
  bool isDark = false;

  void changeTheme(BuildContext context) {
    if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark) {
      AdaptiveTheme.of(context).setLight();
      isDark = false;
      notifyListeners();
    } else {
      isDark = true;
      notifyListeners();
      AdaptiveTheme.of(context).setDark();
    }
  }
}
