import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/models/user_model.dart';
import 'package:foodmarket/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationService authenticationService;
  AuthenticationProvider({
    required this.authenticationService,
  });

  UserModel? userData;

  void getUserData() async {
    var response = await authenticationService.getUser();
    if (response.success) {
      userData = response.data;
    } else {
      userData = null;
    }
    notifyListeners();
  }

  Future<ResponseModel<bool>> login(String email, String password) async {
    return await authenticationService.login(email, password);
  }

  Future<ResponseModel<bool>> register({
    String fullName = '',
    String email = '',
    String password = '',
    String phoneNumber = '',
    String address = '',
    String houseNumber = '',
    String city = '',
    File? avatar,
  }) async {
    return await authenticationService.register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      houseNumber: houseNumber,
      city: city,
      avatar: avatar,
    );
  }

  Future<ResponseModel<bool>> logout() async {
    return await authenticationService.logout();
  }

  Future<ResponseModel<bool>> checkEmail(String email) async {
    return await authenticationService.checkEmail(email);
  }
}
