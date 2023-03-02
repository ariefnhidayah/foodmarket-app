import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/screens/home/home_screen.dart';
import 'package:foodmarket/screens/navigation_screen.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import '/screens/authentication/login_screen.dart';
import '/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String ROUTE_NAME = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late AuthenticationProvider authenticationProvider;

  @override
  void initState() {
    super.initState();
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    Future.microtask(() => authenticationProvider.getUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, data, _) {
        if (data.userData != null) {
          return const NavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
