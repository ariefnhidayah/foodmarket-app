import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/edit_address_provider.dart';
import 'package:foodmarket/providers/edit_profile_provider.dart';
import 'package:foodmarket/providers/home_screen_provider.dart';
import 'package:foodmarket/providers/login_screen_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/providers/register_address_screen_provider.dart';
import 'package:foodmarket/providers/register_screen_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/screens/authentication/register_address_screen.dart';
import 'package:foodmarket/screens/authentication/register_screen.dart';
import 'package:foodmarket/screens/food_detail/food_detail_screen.dart';
import 'package:foodmarket/screens/order/order_detail_screen.dart';
import 'package:foodmarket/screens/order/order_paid_screen.dart';
import 'package:foodmarket/screens/order/success_order_screen.dart';
import 'package:foodmarket/screens/payment/payment_screen.dart';
import 'package:foodmarket/screens/profile/edit_address_screen.dart';
import 'package:foodmarket/screens/profile/edit_profile_screen.dart';
import 'package:foodmarket/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.dart' as di;
import 'providers/theme_provider.dart';
import 'screens/authentication/register_success_screen.dart';
import 'screens/main_screen.dart';
import 'widgets/error_page_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  di.init(preferences: preferences);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<ThemeProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<LoginScreenProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<RegisterScreenProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<RegisterAddressScreenProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<AuthenticationProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TransactionProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<EditProfileProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<EditAddressProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<HomeScreenProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<NavigationProvider>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, data, _) {
          SystemChrome.setSystemUIOverlayStyle(data.systemUiOverlayStyle);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: data.themeData,
            title: 'Foodmarket',
            builder: BotToastInit(),
            initialRoute: SplashScreen.ROUTE_NAME,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case MainScreen.ROUTE_NAME:
                  return MaterialPageRoute(builder: (_) => const MainScreen());
                case RegisterScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const RegisterScreen());
                case RegisterAddressScreen.ROUTE_NAME:
                  Map<String, dynamic> args =
                      settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                      builder: (_) => RegisterAddressScreen(
                            fullName: args['fullName'] as String,
                            email: args['email'] as String,
                            password: args['password'] as String,
                            avatar: args['file'] as File?,
                          ));
                case FoodDetailScreen.ROUTE_NAME:
                  FoodModel food = settings.arguments as FoodModel;
                  return MaterialPageRoute(
                      builder: (_) => FoodDetailScreen(food: food));
                case OrderDetailScreen.ROUTE_NAME:
                  TransactionModel transaction =
                      settings.arguments as TransactionModel;
                  return MaterialPageRoute(
                      builder: (_) =>
                          OrderDetailScreen(transaction: transaction));
                case OrderPaidScreen.ROUTE_NAME:
                  TransactionModel transaction =
                      settings.arguments as TransactionModel;
                  return MaterialPageRoute(
                      builder: (_) =>
                          OrderPaidScreen(transaction: transaction));
                case PaymentScreen.ROUTE_NAME:
                  Map<String, dynamic> args =
                      settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                      quantity: args['quantity'] as int,
                      food: args['food'] as FoodModel,
                    ),
                  );
                case EditProfileScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const EditProfileScreen());
                case EditAddressScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const EditAddressScreen());
                case SplashScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const SplashScreen());
                case SuccessOrderScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const SuccessOrderScreen());
                case RegisterSuccessScreen.ROUTE_NAME:
                  return MaterialPageRoute(
                      builder: (_) => const RegisterSuccessScreen());
                default:
                  return MaterialPageRoute(builder: (_) {
                    return ErrorPageWidget(
                        message: 'Page not found!',
                        press: () {
                          Navigator.pushNamed(context, MainScreen.ROUTE_NAME);
                        });
                  });
              }
            },
          );
        },
      ),
    );
  }
}
