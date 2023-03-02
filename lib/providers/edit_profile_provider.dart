import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/services/user_service.dart';

class EditProfileProvider extends ChangeNotifier {
  final UserService userService;

  EditProfileProvider({required this.userService});

  Future<ResponseModel<bool>> uploadPhoto(File image) async {
    return await userService.uploadPhotoProfile(image);
  }

  Future<ResponseModel<bool>> updateData(Map<String, dynamic> data) async {
    return await userService.updateProfile(data);
  }

  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? fullnameError;
  String? phoneNumberError;

  void setError({
    String? fullnameErrorParam,
    String? phoneNumberErrorParam,
  }) {
    if (fullnameErrorParam != null) {
      fullnameError = fullnameErrorParam;
    }
    if (phoneNumberErrorParam != null) {
      phoneNumberError = phoneNumberErrorParam;
    }
    notifyListeners();
  }

  void resetAllForm() {
    fullnameController.clear();
    phoneNumberController.clear();
    notifyListeners();
  }
}
