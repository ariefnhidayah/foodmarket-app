import 'package:flutter/material.dart';
import 'package:foodmarket/commons/keyboard_helper.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/login_screen_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/screens/authentication/register_screen.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import '/commons/constant.dart';
import '/widgets/button_widget.dart';
import '/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenProvider _loginScreenProvider;
  late AuthenticationProvider _authenticationProvider;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loginScreenProvider =
        Provider.of<LoginScreenProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  void action(LoginScreenProvider data, BuildContext context) {
    KeyboardHelper.hideKeyboard(context);
    showLoaderDialog(context);
    Future.delayed(const Duration(seconds: 1), () async {
      var response = await _authenticationProvider.login(
          data.emailController.text, data.passwordController.text);
      Navigator.pop(context);
      if (response.success) {
        _loginScreenProvider.resetAllForm();
        _authenticationProvider.getUserData();

        Provider.of<NavigationProvider>(context, listen: false)
            .setBottomNavbarIndex(0);
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
        title: 'Sign In',
        subtitle: 'Find your best ever meal',
        context: context,
      ),
      body: Consumer<LoginScreenProvider>(
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
                            _loginScreenProvider.setError(
                                emailErrorParam: EMAIL_ERROR_INVALID);
                          } else {
                            _loginScreenProvider.setError(emailErrorParam: '');
                          }
                        } else {
                          _loginScreenProvider.setError(
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
                          _loginScreenProvider.setError(passwordErrorParam: '');
                        } else {
                          _loginScreenProvider.setError(
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
                        bool isAllFilled =
                            data.emailController.text.isNotEmpty &&
                                data.passwordController.text.isNotEmpty;

                        if (isAllFilled) {
                          bool isNotError = true;
                          if (data.emailController.text.isNotEmpty &&
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(data.emailController.text)) {
                            _loginScreenProvider.setError(
                                emailErrorParam: EMAIL_ERROR_INVALID);
                            isNotError = false;
                          }

                          if (data.passwordController.text.length < 6) {
                            _loginScreenProvider.setError(
                                passwordErrorParam: PASSWORD_ERROR_6_LENGTH);
                            isNotError = false;
                          }

                          if (isNotError) {
                            action(data, context);
                          }
                        } else {
                          if (data.emailController.text.isEmpty) {
                            _loginScreenProvider.setError(
                                emailErrorParam: EMAIL_ERROR_REQUIRED);
                          }
                          if (data.passwordController.text.isEmpty) {
                            _loginScreenProvider.setError(
                                passwordErrorParam: PASSWORD_ERROR_REQUIRED);
                          }
                          if (data.emailController.text.isNotEmpty &&
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(data.emailController.text)) {
                            _loginScreenProvider.setError(
                                emailErrorParam: EMAIL_ERROR_INVALID);
                          }
                        }
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ButtonWidget(
                      elevation: 0,
                      onPress: () {
                        Navigator.pushNamed(context, RegisterScreen.ROUTE_NAME);
                      },
                      child: const Text(
                        "Create New Account",
                      ),
                      color: secondaryColor,
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
