import 'package:dio/dio.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/edit_address_provider.dart';
import 'package:foodmarket/providers/edit_profile_provider.dart';
import 'package:foodmarket/providers/home_screen_provider.dart';
import 'package:foodmarket/providers/login_screen_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/providers/register_address_screen_provider.dart';
import 'package:foodmarket/providers/register_screen_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/services/authentication_service.dart';
import 'package:foodmarket/services/food_service.dart';
import 'package:foodmarket/services/transaction_service.dart';
import 'package:foodmarket/services/user_service.dart';
import '/providers/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

void init({required SharedPreferences preferences}) async {
  // PROVIDER
  locator.registerFactory<ThemeProvider>(() => ThemeProvider());
  locator.registerFactory<NavigationProvider>(() => NavigationProvider());
  locator.registerFactory<LoginScreenProvider>(() => LoginScreenProvider());
  locator
      .registerFactory<RegisterScreenProvider>(() => RegisterScreenProvider());
  locator.registerFactory<RegisterAddressScreenProvider>(
      () => RegisterAddressScreenProvider());
  locator.registerFactory<AuthenticationProvider>(
      () => AuthenticationProvider(authenticationService: locator()));
  locator.registerFactory<HomeScreenProvider>(
      () => HomeScreenProvider(foodService: locator()));
  locator.registerFactory<TransactionProvider>(
      () => TransactionProvider(transactionService: locator()));
  locator.registerFactory<EditProfileProvider>(
      () => EditProfileProvider(userService: locator()));
  locator.registerFactory<EditAddressProvider>(
      () => EditAddressProvider(userService: locator()));

  // SERVICE
  locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationServiceImpl(
            preferences: locator(),
            dio: locator(),
          ));
  locator.registerLazySingleton<FoodService>(
      () => FoodServiceImpl(dio: locator()));
  locator
      .registerLazySingleton<TransactionService>(() => TransactionServiceImpl(
            preferences: locator(),
            dio: locator(),
          ));
  locator.registerLazySingleton<UserService>(
      () => UserServiceImpl(preferences: locator(), dio: locator()));

  // EXTERNAL
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton(() => preferences);
}
