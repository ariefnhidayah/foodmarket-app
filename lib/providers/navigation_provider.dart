import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _bottomNavbarIndex = 0;
  int get bottomNavbarIndex => _bottomNavbarIndex;

  void setBottomNavbarIndex(int index) {
    _bottomNavbarIndex = index;
    notifyListeners();
  }
}
