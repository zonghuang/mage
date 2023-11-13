import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserModel extends ChangeNotifier {
  late int _currentPageIndex = 0;

  UserModel() {
    /// do somethings
  }

  get currentPageIndex => _currentPageIndex;

  void updateIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void goTab(BuildContext context, String name) {
    switch (name) {
      case 'home':
        _currentPageIndex = 0;
        context.go('/');
        break;
      case 'me':
        _currentPageIndex = 1;
        context.go('/me');
        break;
      default:
    }
    notifyListeners();
  }
}
