import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/register_address_screen_provider.dart';
import 'package:foodmarket/providers/register_screen_provider.dart';
import 'package:foodmarket/screens/authentication/register_screen.dart';
import 'package:foodmarket/screens/main_screen.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class RegisterSuccessScreen extends StatelessWidget {
  static const String ROUTE_NAME = '/auth/register/success';
  const RegisterSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/success-signup-vector.png',
                width: 200,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Yeay! Completed',
                style: textStyleTheme().copyWith(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Now you are able to order\nsome foods as a self-reward",
                style: textStyleTheme().copyWith(
                  fontSize: 14,
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                width: 200,
                elevation: 0,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Provider.of<RegisterScreenProvider>(context, listen: false)
                      .resetAllForm();
                  Provider.of<RegisterAddressScreenProvider>(context,
                          listen: false)
                      .resetAllForm();
                },
                child: const Text(
                  "Find Foods",
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
