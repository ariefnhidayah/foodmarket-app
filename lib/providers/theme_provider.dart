import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/commons/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData themeData = theme();

  SystemUiOverlayStyle _systemUiOverlayStyle = customSystemChrome();
  SystemUiOverlayStyle get systemUiOverlayStyle => _systemUiOverlayStyle;

  void changeTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }

  void changeUiOverlay(SystemUiOverlayStyle style) {
    _systemUiOverlayStyle = style;
    notifyListeners();
  }
}
