import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterAddressScreenProvider extends ChangeNotifier {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String? phoneNumberError;
  String? addressError;
  String? houseNumberError;
  String? cityError;

  void setError({
    String? phoneNumberErrorParam,
    String? addressErrorParam,
    String? houseNumberErrorParam,
    String? cityErrorParam,
  }) {
    if (phoneNumberErrorParam != null) {
      phoneNumberError = phoneNumberErrorParam;
    }
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

  void resetAllForm() {
    phoneNumberController.clear();
    addressController.clear();
    houseNumberController.clear();
    cityController.clear();
    notifyListeners();
  }
}
