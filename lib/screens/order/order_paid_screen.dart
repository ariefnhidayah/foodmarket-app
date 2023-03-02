import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/image_helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OrderPaidScreen extends StatefulWidget {
  final TransactionModel transaction;
  const OrderPaidScreen({Key? key, required this.transaction})
      : super(key: key);

  static const String ROUTE_NAME = '/order/detail/paid';

  @override
  State<OrderPaidScreen> createState() =>
      // ignore: no_logic_in_create_state
      _OrderPaidScreenState(transaction: transaction);
}

class _OrderPaidScreenState extends State<OrderPaidScreen> {
  final TransactionModel transaction;
  _OrderPaidScreenState({required this.transaction});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TransactionProvider _transactionProvider;
  late AuthenticationProvider _authenticationProvider;

  File? imageFile;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget _imagePreview(File file) {
    return Dialog(
      child: Image(
        image: FileImage(file),
      ),
    );
  }

  void _getImage(BuildContext context, ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    Directory tempDir = await getTemporaryDirectory();
    if (pickedFile != null) {
      if (imageFile != null && imageFile!.existsSync()) {
        imageFile!.delete();
      }
      String dirPath = '${tempDir.path}/payment_proof/${timestamp()}';
      await Directory(dirPath).create(recursive: true);
      String fullPath =
          '$dirPath/${transaction.code.replaceAll('/', '-')}-${timestamp()}.jpeg';
      imageFile = await ImageHelper.moveFile(File(pickedFile.path), fullPath);
    }
    setState(() {});
    Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
    _transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(
        title: "Payment",
        subtitle: "Pay for your order to proceed",
        context: context,
        routeName: '/order/detail/paid',
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Details Transaction",
                      style: textStyleTheme().copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 24 - 24,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                transaction.food.name,
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(formatRupiah(transaction.total)),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Driver",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(formatRupiah(transaction.shippingCost)),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Application Fee",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(formatRupiah(transaction.tax)),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Price",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                formatRupiah(transaction.grandTotal),
                                style: textStyleTheme().copyWith(
                                    color: successColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Account Information",
                      style: textStyleTheme().copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 24 - 24,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Bank Name",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              const Text("BCA"),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Account Number",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              const Text("123321233"),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Account Name",
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              const Text("FoodMarket Pay"),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 24 - 24,
                  child: Row(
                    children: [
                      imageFile != null && imageFile!.existsSync()
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => _imagePreview(imageFile!),
                                    barrierDismissible: true);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(File(imageFile!.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                selectUploadType(context);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.file_upload_outlined,
                                  size: 24,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          selectUploadType(context);
                        },
                        child: imageFile != null
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                    color: secondaryColor,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Change File",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width -
                                    24 -
                                    24 -
                                    60 -
                                    12,
                                child: const Text(
                                  "Upload Proof of Transaction",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      )
                    ],
                  ),
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
                  "Submit",
                  style: textStyleTheme(),
                ),
                elevation: 0,
                onPress: imageFile != null && imageFile!.existsSync()
                    ? () {
                        showLoaderDialog(context);
                        Future.delayed(const Duration(milliseconds: 500),
                            () async {
                          var response = await _transactionProvider
                              .uploadPaymentProof(transaction, imageFile!);
                          Navigator.pop(context);
                          if (response.success) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Future.microtask(
                                () => _transactionProvider.getOrderTabPage(0));
                          } else {
                            if (response.statusCode == 401) {
                              await _authenticationProvider
                                  .logout()
                                  .then((value) {
                                alertIsUnauthorized(context);
                              });
                            } else {
                              showNotificationToast(_scaffoldKey, context,
                                  !response.success, response.message);
                            }
                          }
                        });
                      }
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
