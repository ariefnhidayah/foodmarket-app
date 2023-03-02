import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/screens/main_screen.dart';
import '/commons/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String ROUTE_NAME = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // show splash screen
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.ROUTE_NAME, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/foodmarket-logo.svg',
              color: textColor,
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'FoodMarket',
              style: textStyleTheme().copyWith(
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
