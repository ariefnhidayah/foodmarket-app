import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/keyboard_helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/edit_profile_provider.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:foodmarket/widgets/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const String ROUTE_NAME = '/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? avatarFile;

  late EditProfileProvider _editProfileProvider;
  late AuthenticationProvider _authenticationProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _editProfileProvider.setError(
        fullnameErrorParam: '', phoneNumberErrorParam: '');
  }

  void _getImage(BuildContext context, ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      avatarFile = File(pickedFile.path);
    }
    setState(() {});
    if (avatarFile != null) {
      uploadPhoto(context);
    }
  }

  void uploadPhoto(BuildContext context) async {
    showLoaderDialog(context);
    Future.delayed(const Duration(milliseconds: 500), () async {
      var response = await _editProfileProvider.uploadPhoto(avatarFile!);
      Navigator.pop(context);
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

  void action(EditProfileProvider data, BuildContext context) {
    KeyboardHelper.hideKeyboard(context);
    showLoaderDialog(context);
    Future.delayed(const Duration(seconds: 1), () async {
      var response = await _editProfileProvider.updateData({
        "name": data.fullnameController.text,
        "phone_number": data.phoneNumberController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(
        context: context,
        title: 'Edit Profile',
        subtitle: 'Change your profile',
        routeName: '/profile/edit',
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, auth, _) {
          _editProfileProvider.fullnameController.text = auth.userData!.name;
          _editProfileProvider.phoneNumberController.text =
              auth.userData!.phoneNumber;

          return Consumer<EditProfileProvider>(
            builder: (context, data, _) {
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
                            Center(
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
                                      ? ImageNetworkWidget(
                                          imageUrl:
                                              auth.userData!.profilePhotoPath,
                                          width: 90,
                                          height: 90,
                                          boxFit: BoxFit.cover,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
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
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  selectUploadType(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: textColor,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Change Photo",
                                      style: textStyleTheme().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
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
                              errorText: data.fullnameError,
                              hintText: "Type your full name",
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _editProfileProvider.setError(
                                      fullnameErrorParam: '');
                                } else {
                                  _editProfileProvider.setError(
                                      fullnameErrorParam:
                                          FULLNAME_ERROR_REQUIRED);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 16,
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
                              errorText: data.phoneNumberError,
                              hintText: "Type your phone number",
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _editProfileProvider.setError(
                                      phoneNumberErrorParam: '');
                                } else {
                                  _editProfileProvider.setError(
                                      phoneNumberErrorParam:
                                          PHONE_NUMBER_REQUIRED);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 24 * 4,
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
                              data.fullnameController.text.isNotEmpty &&
                                  data.phoneNumberController.text.isNotEmpty;
                          if (isAllFilled) {
                            action(data, context);
                          } else {
                            if (data.fullnameController.text.isEmpty) {
                              _editProfileProvider.setError(
                                  fullnameErrorParam: FULLNAME_ERROR_REQUIRED);
                            }
                            if (data.phoneNumberController.text.isEmpty) {
                              _editProfileProvider.setError(
                                  phoneNumberErrorParam: PHONE_NUMBER_REQUIRED);
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
