import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/keyboard_helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/register_screen_provider.dart';
import 'package:foodmarket/screens/authentication/register_address_screen.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:foodmarket/widgets/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String ROUTE_NAME = '/auth/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? avatarFile;

  late RegisterScreenProvider _registerScreenProvider;
  late AuthenticationProvider _authenticationProvider;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _registerScreenProvider =
        Provider.of<RegisterScreenProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  void _getImage(BuildContext context, ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      avatarFile = File(pickedFile.path);
    }
    setState(() {});
    if (avatarFile != null) {
      Navigator.pop(context);
    }
  }

  void action(RegisterScreenProvider data, BuildContext context) async {
    KeyboardHelper.hideKeyboard(context);
    showLoaderDialog(context);
    _registerScreenProvider.setError(emailErrorParam: '');
    Future.delayed(const Duration(seconds: 1), () async {
      var response =
          await _authenticationProvider.checkEmail(data.emailController.text);
      Navigator.pop(context);

      if (response.success) {
        Navigator.pushNamed(context, RegisterAddressScreen.ROUTE_NAME,
            arguments: {
              "fullName": data.fullnameController.text,
              "email": data.emailController.text,
              "password": data.passwordController.text,
              "file": avatarFile,
            });
      } else {
        if (response.message == 'Email has been used!') {
          _registerScreenProvider.setError(emailErrorParam: response.message);
        }
        showNotificationToast(
            _scaffoldKey, context, !response.success, response.message);
      }
    });
  }

  void selectUploadType(BuildContext context) {
    customAlertDialog(
      context,
      isDismissible: true,
      title: const Text("Select image upload path!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(
            elevation: 0,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_rounded,
                  color: textColor,
                  size: 18,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  "Camera",
                  style: textStyleTheme().copyWith(color: textColor),
                ),
              ],
            ),
            onPress: () {
              _getImage(context, ImageSource.camera);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(
            elevation: 0,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image,
                  color: textColor,
                  size: 18,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  "Gallery",
                  style: textStyleTheme().copyWith(color: textColor),
                ),
              ],
            ),
            onPress: () {
              _getImage(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar(
        title: "Sign Up",
        subtitle: "Register and eat",
        context: context,
        routeName: '/auth/register',
      ),
      body: Consumer<RegisterScreenProvider>(builder: (context, data, _) {
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
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        selectUploadType(context);
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: secondaryColor,
                        strokeWidth: 1,
                        dashPattern: const [
                          10,
                          10,
                        ],
                        radius: const Radius.circular(200),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: avatarFile == null
                              ? Image.asset(
                                  "assets/images/add-photo.png",
                                  width: 90,
                                  height: 90,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Image.file(
                                    avatarFile!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFieldWidget(
                    controller: data.fullnameController,
                    hintText: "Type your full name",
                    errorText: data.fullnameError,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _registerScreenProvider.setError(
                            fullnameErrorParam: '');
                      } else {
                        _registerScreenProvider.setError(
                            fullnameErrorParam: FULLNAME_ERROR_REQUIRED);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFieldWidget(
                    controller: data.emailController,
                    hintText: "Type your email address",
                    keyboardType: TextInputType.emailAddress,
                    errorText: data.emailError,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (value.isNotEmpty &&
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          _registerScreenProvider.setError(
                              emailErrorParam: EMAIL_ERROR_INVALID);
                        } else {
                          _registerScreenProvider.setError(emailErrorParam: '');
                        }
                      } else {
                        _registerScreenProvider.setError(
                            emailErrorParam: EMAIL_ERROR_REQUIRED);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFieldWidget(
                    controller: data.passwordController,
                    hintText: "Type your password",
                    isPassword: true,
                    errorText: data.passwordError,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _registerScreenProvider.setError(
                            passwordErrorParam: '');
                      } else {
                        _registerScreenProvider.setError(
                            passwordErrorParam: PASSWORD_ERROR_REQUIRED);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ButtonWidget(
                    elevation: 0,
                    onPress: () {
                      bool isAllFilled = data.emailController.text.isNotEmpty &&
                          data.fullnameController.text.isNotEmpty &&
                          data.passwordController.text.isNotEmpty;

                      if (isAllFilled) {
                        bool isNotError = true;
                        if (data.emailController.text.isNotEmpty &&
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(data.emailController.text)) {
                          _registerScreenProvider.setError(
                              emailErrorParam: EMAIL_ERROR_INVALID);
                          isNotError = false;
                        }

                        if (data.passwordController.text.length < 6) {
                          _registerScreenProvider.setError(
                              passwordErrorParam: PASSWORD_ERROR_6_LENGTH);
                          isNotError = false;
                        }

                        if (isNotError) {
                          action(data, context);
                        }
                      } else {
                        if (data.fullnameController.text.isEmpty) {
                          _registerScreenProvider.setError(
                              fullnameErrorParam: FULLNAME_ERROR_REQUIRED);
                        }
                        if (data.emailController.text.isEmpty) {
                          _registerScreenProvider.setError(
                              emailErrorParam: EMAIL_ERROR_REQUIRED);
                        }
                        if (data.passwordController.text.isEmpty) {
                          _registerScreenProvider.setError(
                              passwordErrorParam: PASSWORD_ERROR_REQUIRED);
                        }
                        if (data.emailController.text.isNotEmpty &&
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(data.emailController.text)) {
                          _registerScreenProvider.setError(
                              emailErrorParam: EMAIL_ERROR_INVALID);
                        }
                      }
                    },
                    child: const Text(
                      "Continue",
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
      }),
    );
  }
}
