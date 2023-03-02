import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/commons/constant.dart';

ThemeData theme() {
  return ThemeData(
    backgroundColor: const Color(0xffFAFAFC),
    fontFamily: "Poppins",
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: appBarTheme(),
    textTheme: const TextTheme(bodyText1: TextStyle(fontFamily: "Poppins")),
    inputDecorationTheme: inputDecorationTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: textColor),
);

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: successColor)),
    border: outlineInputBorder,
    errorBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: dangerColor)),
    hintStyle: const TextStyle(color: secondaryColor),
    errorStyle: const TextStyle(height: 0),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(color: textColor),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleTextStyle: TextStyle(fontFamily: "Poppins", color: textColor),
    toolbarTextStyle: TextStyle(fontFamily: "Poppins", color: textColor),
  );
}

SystemUiOverlayStyle customSystemChrome() {
  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  );
}

TextStyle textStyleTheme() {
  return const TextStyle(fontFamily: "Poppins", color: textColor);
}
