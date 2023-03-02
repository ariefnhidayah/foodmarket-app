import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterScreenProvider extends ChangeNotifier {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? fullnameError;
  String? emailError;
  String? passwordError;

  void setError({
    String? fullnameErrorParam,
    String? emailErrorParam,
    String? passwordErrorParam,
  }) {
    if (fullnameErrorParam != null) {
      fullnameError = fullnameErrorParam;
    }
    if (emailErrorParam != null) {
      emailError = emailErrorParam;
    }
    if (passwordErrorParam != null) {
      passwordError = passwordErrorParam;
    }
    notifyListeners();
  }

  void resetAllForm() {
    fullnameController.clear();
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
