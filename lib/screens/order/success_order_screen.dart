import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class SuccessOrderScreen extends StatelessWidget {
  static const String ROUTE_NAME = '/order/success';
  const SuccessOrderScreen({Key? key}) : super(key: key);

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
                'assets/images/success-order-vector.png',
                width: 200,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "You've Made Order",
                style: textStyleTheme().copyWith(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Just stay at home while we are\npreparing your best foods",
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
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setBottomNavbarIndex(0);
                },
                child: const Text(
                  "Order Other Foods",
                  style: TextStyle(color: textColor),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                width: 200,
                elevation: 0,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setBottomNavbarIndex(1);
                },
                color: secondaryColor,
                child: const Text(
                  "View My Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
