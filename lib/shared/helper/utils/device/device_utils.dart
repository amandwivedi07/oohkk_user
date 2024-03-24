import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtils {
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> setPreferredOrientations() async {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> hideStatusBar() async {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
  }
}
