import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/keyboard_helper.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/register_address_screen_provider.dart';
import 'package:foodmarket/providers/register_screen_provider.dart';
import 'package:foodmarket/screens/authentication/register_success_screen.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:foodmarket/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class RegisterAddressScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final File? avatar;

  const RegisterAddressScreen({
    Key? key,
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.avatar,
  }) : super(key: key);

  // ignore: constant_identifier_names
  static const String ROUTE_NAME = '/auth/register/address';

  @override
  State<RegisterAddressScreen> createState() => _RegisterAddressScreenState();
}

class _RegisterAddressScreenState extends State<RegisterAddressScreen> {
  late RegisterScreenProvider _registerScreenProvider;
  late RegisterAddressScreenProvider _registerAddressScreenProvider;
  late AuthenticationProvider _authenticationProvider;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _registerAddressScreenProvider =
        Provider.of<RegisterAddressScreenProvider>(context, listen: false);
    _registerScreenProvider =
        Provider.of<RegisterScreenProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  void action(RegisterAddressScreenProvider data, BuildContext context) {
    KeyboardHelper.hideKeyboard(context);
    showLoaderDialog(context);
    Future.delayed(const Duration(seconds: 1), () async {
      var response = await _authenticationProvider.register(
        fullName: widget.fullName,
        email: widget.email,
        password: widget.password,
        avatar: widget.avatar,
        address: data.addressController.text,
        city: data.cityController.text,
        houseNumber: data.houseNumberController.text,
        phoneNumber: data.phoneNumberController.text,
      );

      Navigator.pop(context);
      if (response.success) {
        _registerScreenProvider.resetAllForm();
        _registerAddressScreenProvider.resetAllForm();
        _authenticationProvider.getUserData();
        Navigator.pushNamed(context, RegisterSuccessScreen.ROUTE_NAME);
      } else {
        showNotificationToast(
            _scaffoldKey, context, !response.success, response.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar(
        title: "Address",
        subtitle: "Make sure it's valid",
        context: context,
        routeName: '/auth/register/address',
      ),
      body: Consumer<RegisterAddressScreenProvider>(
        builder: (context, data, _) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        "Phone No.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller: data.phoneNumberController,
                      hintText: "Type your phone number",
                      keyboardType: TextInputType.phone,
                      errorText: data.phoneNumberError,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _registerAddressScreenProvider.setError(
                              phoneNumberErrorParam: '');
                        } else {
                          _registerAddressScreenProvider.setError(
                              phoneNumberErrorParam: PHONE_NUMBER_REQUIRED);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller: data.addressController,
                      hintText: "Type your address",
                      errorText: data.addressError,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _registerAddressScreenProvider.setError(
                              addressErrorParam: '');
                        } else {
                          _registerAddressScreenProvider.setError(
                              addressErrorParam: ADDRESS_REQUIRED);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        "House No.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller: data.houseNumberController,
                      hintText: "Type your house number",
                      errorText: data.houseNumberError,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _registerAddressScreenProvider.setError(
                              houseNumberErrorParam: '');
                        } else {
                          _registerAddressScreenProvider.setError(
                              houseNumberErrorParam: HOUSE_NUMBER_REQUIRED);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        "City",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller: data.cityController,
                      hintText: "Type your city",
                      errorText: data.cityError,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _registerAddressScreenProvider.setError(
                              cityErrorParam: '');
                        } else {
                          _registerAddressScreenProvider.setError(
                              cityErrorParam: CITY_REQUIRED);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ButtonWidget(
                      elevation: 0,
                      onPress: () {
                        bool isAllFilled =
                            data.phoneNumberController.text.isNotEmpty &&
                                data.addressController.text.isNotEmpty &&
                                data.houseNumberController.text.isNotEmpty &&
                                data.cityController.text.isNotEmpty;

                        if (isAllFilled) {
                          action(data, context);
                        } else {
                          if (data.phoneNumberController.text.isEmpty) {
                            _registerAddressScreenProvider.setError(
                                phoneNumberErrorParam: PHONE_NUMBER_REQUIRED);
                          }
                          if (data.addressController.text.isEmpty) {
                            _registerAddressScreenProvider.setError(
                                addressErrorParam: ADDRESS_REQUIRED);
                          }
                          if (data.houseNumberController.text.isEmpty) {
                            _registerAddressScreenProvider.setError(
                                houseNumberErrorParam: HOUSE_NUMBER_REQUIRED);
                          }
                          if (data.cityController.text.isEmpty) {
                            _registerAddressScreenProvider.setError(
                                cityErrorParam: CITY_REQUIRED);
                          }
                        }
                      },
                      child: const Text(
                        "Sign Up Now",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
