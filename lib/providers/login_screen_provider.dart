import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreenProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void setError({
    String? fullnameErrorParam,
    String? emailErrorParam,
    String? passwordErrorParam,
  }) {
    if (emailErrorParam != null) {
      emailError = emailErrorParam;
    }
    if (passwordErrorParam != null) {
      passwordError = passwordErrorParam;
    }
    notifyListeners();
  }

  void resetAllForm() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
