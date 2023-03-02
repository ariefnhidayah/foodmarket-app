import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/keyboard_helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/edit_address_provider.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:foodmarket/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);
  static const String ROUTE_NAME = '/profile/edit-address';

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late AuthenticationProvider _authenticationProvider;
  late EditAddressProvider _editAddressProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _editAddressProvider =
        Provider.of<EditAddressProvider>(context, listen: false);
    _editAddressProvider.setError(
      addressErrorParam: '',
      cityErrorParam: '',
      houseNumberErrorParam: '',
    );
  }

  void action(EditAddressProvider data, BuildContext context) {
    KeyboardHelper.hideKeyboard(context);
    showLoaderDialog(context);
    Future.delayed(const Duration(milliseconds: 500), () async {
      var response = await _editAddressProvider.updateData({
        "address": data.addressController.text,
        "house_number": data.houseNumberController.text,
        "city": data.cityController.text,
      });
      Navigator.pop(context);
      if (response.success) {
        _authenticationProvider.getUserData();
        showNotificationToast(_scaffoldKey, context, false, response.message);
      } else {
        if (response.statusCode == 401) {
          await _authenticationProvider.logout().then((value) {
            alertIsUnauthorized(context);
          });
        } else {
          showNotificationToast(
              _scaffoldKey, context, !response.success, response.message);
        }
      }
    });
  }

  void alertIsUnauthorized(BuildContext context) {
    customAlertDialog(
      context,
      title: const Text("Notification!"),
      content: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: const Text("Session has ended, please sign in again!"),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.all(8),
          child: ButtonWidget(
            elevation: 0,
            child: Text(
              "OK",
              style: textStyleTheme(),
            ),
            onPress: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              _authenticationProvider.getUserData();
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(
        context: context,
        title: 'Home Address',
        subtitle: 'Change your address',
        routeName: '/profile/edit-address',
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, auth, _) {
          _editAddressProvider.addressController.text = auth.userData!.address;
          _editAddressProvider.houseNumberController.text =
              auth.userData!.houseNumber;
          _editAddressProvider.cityController.text = auth.userData!.city;
          return Consumer<EditAddressProvider>(builder: (context, data, _) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
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
                            errorText: data.addressError,
                            hintText: "Type your address",
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _editAddressProvider.setError(
                                  addressErrorParam: '',
                                );
                              } else {
                                _editAddressProvider.setError(
                                  addressErrorParam: ADDRESS_REQUIRED,
                                );
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
                            errorText: data.houseNumberError,
                            hintText: "Type your house number",
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _editAddressProvider.setError(
                                  houseNumberErrorParam: '',
                                );
                              } else {
                                _editAddressProvider.setError(
                                  houseNumberErrorParam: HOUSE_NUMBER_REQUIRED,
                                );
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
                            errorText: data.cityError,
                            hintText: "Type your city",
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _editAddressProvider.setError(
                                  cityErrorParam: '',
                                );
                              } else {
                                _editAddressProvider.setError(
                                  cityErrorParam: HOUSE_NUMBER_REQUIRED,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(24),
                    child: ButtonWidget(
                      child: Text(
                        "Save",
                        style: textStyleTheme(),
                      ),
                      elevation: 0,
                      onPress: () {
                        bool isAllFilled =
                            data.addressController.text.isNotEmpty &&
                                data.houseNumberController.text.isNotEmpty &&
                                data.cityController.text.isNotEmpty;
                        if (isAllFilled) {
                          action(data, context);
                        } else {
                          if (data.addressController.text.isEmpty) {
                            _editAddressProvider.setError(
                              addressErrorParam: ADDRESS_REQUIRED,
                            );
                          }
                          if (data.houseNumberController.text.isEmpty) {
                            _editAddressProvider.setError(
                              houseNumberErrorParam: HOUSE_NUMBER_REQUIRED,
                            );
                          }
                          if (data.cityController.text.isEmpty) {
                            _editAddressProvider.setError(
                              cityErrorParam: CITY_REQUIRED,
                            );
                          }
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          });
        },
      ),
    );
  }
}
