import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/services/user_service.dart';

class EditAddressProvider extends ChangeNotifier {
  final UserService userService;

  EditAddressProvider({required this.userService});

  Future<ResponseModel<bool>> updateData(Map<String, dynamic> data) async {
    return await userService.updateProfile(data);
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String? addressError;
  String? houseNumberError;
  String? cityError;

  void setError({
    String? addressErrorParam,
    String? houseNumberErrorParam,
    String? cityErrorParam,
  }) {
    if (addressErrorParam != null) {
      addressError = addressErrorParam;
    }
    if (houseNumberErrorParam != null) {
      houseNumberError = houseNumberErrorParam;
    }
    if (cityErrorParam != null) {
      cityError = cityErrorParam;
    }
    notifyListeners();
  }
}
