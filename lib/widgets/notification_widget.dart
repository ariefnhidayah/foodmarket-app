import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';

void showNotificationToast(GlobalKey<ScaffoldState> _scaffoldKey,
    BuildContext context, bool isError, String message) {
  // WidgetsBinding.instance!.addPostFrameCallback((_) {
  //   _scaffoldKey.currentState!.showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: isError ? dangerColor : successColor,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // });
  // BotToast.showText(
  //   text: message,
  //   backgroundColor: isError ? dangerColor : successColor,
  // );
  BotToast.showSimpleNotification(
    title: message,
    backgroundColor: isError ? dangerColor : successColor,
    titleStyle: textStyleTheme().copyWith(
      color: Colors.white,
      fontSize: 14,
    ),
    duration: const Duration(seconds: 2),
    hideCloseButton: true,
  );
}
