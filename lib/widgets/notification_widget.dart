import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';

void showNotificationToast(GlobalKey<ScaffoldState> _scaffoldKey,
    BuildContext context, bool isError, String message) {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? dangerColor : successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  });
}
