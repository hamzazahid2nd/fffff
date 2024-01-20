
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class StateHandler with ChangeNotifier {
  bool showProfileScreenAppBar = true;
  bool isProfileScreenScrollingDown = false;
  void setProfileScreenAppBarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showProfileScreenAppBar = appBarState;
    isProfileScreenScrollingDown = scrollState;
    notifyListeners();
  }

  bool showProfileDetailScreenAppBar = true;
  bool isProfileDetailScrollingDown = false;
  void setProfileDetailScreenAppBarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showProfileDetailScreenAppBar = appBarState;
    isProfileDetailScrollingDown = scrollState;
    notifyListeners();
  }

  bool showContactUsScreenAppbar = true;
  bool isContactUsScreenScrollingDown = false;
  void setContactUsScreenAppbarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showContactUsScreenAppbar = appBarState;
    isContactUsScreenScrollingDown = scrollState;
    notifyListeners();
  }

  bool showCorporateScreenAppbar = true;
  bool isCorporateScreenScrollingDown = false;
  void setCorporateScreenAppbarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showCorporateScreenAppbar = appBarState;
    isCorporateScreenScrollingDown = scrollState;
    notifyListeners();
  }

  bool showAboutUsScreenAppbar = true;
  bool isAboutUsScreenScrollingDown = false;
  void setAboutUsScreenAppbarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showAboutUsScreenAppbar = appBarState;
    isAboutUsScreenScrollingDown = scrollState;
    notifyListeners();
  }

  bool showWebViewScreenAppbar = true;
  bool isWebViewScreenScrollingDown = false;
  void setWebViewScreenAppbarAndScrollState({
    required bool appBarState,
    required bool scrollState,
  }) {
    showWebViewScreenAppbar = appBarState;
    isWebViewScreenScrollingDown = scrollState;
    notifyListeners();
  }

  double height = 400;
  void setAuthMode(double newheight) {
    height = newheight;
    notifyListeners();
  }
}
