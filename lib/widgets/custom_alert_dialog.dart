import 'package:flutter/material.dart';

void customAlertDialog(
  BuildContext context, {
  required Widget title,
  required Widget content,
  List<Widget>? actions,
  bool isDismissible = false,
}) {
  showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          title: title,
          content: content,
          actions: actions,
        );
      });
}
