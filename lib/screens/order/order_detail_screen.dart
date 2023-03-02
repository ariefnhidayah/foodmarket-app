import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/screens/order/order_paid_screen.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:foodmarket/widgets/lazy_load_widget.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final TransactionModel transaction;
  const OrderDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  static const String ROUTE_NAME = '/order/detail';

  @override
  // ignore: no_logic_in_create_state
  State<OrderDetailScreen> createState() =>
      _OrderDetailScreenState(transaction: transaction);
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TransactionModel transaction;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _OrderDetailScreenState({required this.transaction});

  late TransactionProvider _transactionProvider;

  @override
  void initState() {
    super.initState();
    _transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
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
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .getUserData();
            },
          ),
        )
      ],
    );
  }

  Widget _imagePreview(String imageURL) {
    return Dialog(
      child: CachedNetworkImage(
        imageUrl: imageURL,
        placeholder: (context, _) {
          return LazyLoadWidget(
            child: Container(
              decoration: BoxDecoration(
                color: baseColorLazyLoad,
              ),
            ),
          );
        },
      ),
    );
  }

  void cancelOrder(BuildContext context) {
    customAlertDialog(
      context,
      isDismissible: true,
      title: const Text("Are you sure want to cancel?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(
            elevation: 0,
            color: dangerColor,
            child: const Text("Yes"),
            onPress: () async {
              Navigator.pop(context);
              showLoaderDialog(context);
              Future.delayed(const Duration(milliseconds: 500), () async {
                var response =
                    await _transactionProvider.cancelOrder(transaction);
                Navigator.pop(context);
                if (response.success) {
                  Navigator.pop(context);
                  Future.microtask(
                      () => _transactionProvider.getOrderTabPage(0));
                } else {
                  if (response.statusCode == 401) {
                    await Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .logout()
                        .then((value) {
                      alertIsUnauthorized(context);
                    });
                  } else {
                    showNotificationToast(
                        _scaffoldKey, context, true, response.message);
                  }
                }
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(
            elevation: 0,
            color: secondaryColor,
            child: const Text("No"),
            onPress: () {
              Navigator.pop(context);
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
      appBar: appBar(
        title: "Payment",
        subtitle: "You deserve better meal",
        context: context,
        routeName: '/order/detail',
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Item Ordered",
                  style: textStyleTheme().copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    ImageNetworkWidget(
                      imageUrl: transaction.food.picturePath,
                      width: 60,
                      height: 60,
                      boxFit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width - 24 - 24 - 12 - 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width -
                                    24 -
                                    24 -
                                    12 -
                                    60 -
                                    60,
                                child: Text(
                                  transaction.food.name,
                                  style: textStyleTheme().copyWith(
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                formatRupiah(transaction.food.price),
                                style: textStyleTheme().copyWith(
                                  fontSize: 13,
                                  color: secondaryColor,
                                ),
                              )
                            ],
                          ),
                          Text(
                            "${transaction.quantity} items",
                            style: textStyleTheme().copyWith(
                              fontSize: 13,
                              color: secondaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deliver to:",
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
                            "Name",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(transaction.user!.name),
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
                            "Phone No.",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(transaction.user!.phoneNumber),
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
                            "Address",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(transaction.user!.address),
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
                            "House No.",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(transaction.user!.houseNumber),
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
                            "City",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(transaction.user!.city),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Status:",
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
                            "#${transaction.code}",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            transaction.status[0].toUpperCase() +
                                transaction.status.substring(1).toLowerCase(),
                            style: textStyleTheme().copyWith(
                              color: transaction.status == 'pending'
                                  ? warningColor
                                  : transaction.status == 'paid'
                                      ? successColor
                                      : transaction.status == 'expired'
                                          ? dangerColor
                                          : textColor,
                            ),
                          ),
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
                            "Transaction Date",
                            style: textStyleTheme().copyWith(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            convertDateFormat(transaction.dateAdded),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: transaction.paymentProof.isEmpty ? 0 : 6,
                      ),
                      transaction.paymentProof.isEmpty
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Proof",
                                  style: textStyleTheme().copyWith(
                                    color: secondaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => _imagePreview(
                                            transaction.paymentProof),
                                        barrierDismissible: true);
                                  },
                                  child: ImageNetworkWidget(
                                    imageUrl: transaction.paymentProof,
                                    width: 60,
                                    height: 60,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          transaction.status == 'pending'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ButtonWidget(
                    child: Text(
                      "Paid My Order",
                      style: textStyleTheme().copyWith(
                        color: textColor,
                      ),
                    ),
                    elevation: 0,
                    onPress: () {
                      Navigator.pushNamed(context, OrderPaidScreen.ROUTE_NAME,
                          arguments: transaction);
                    },
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: transaction.status == 'pending' ? 16 : 0,
          ),
          transaction.status == 'pending' || transaction.status == 'paid'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ButtonWidget(
                    color: dangerColor,
                    child: Text(
                      "Cancel My Order",
                      style: textStyleTheme().copyWith(
                        color: Colors.white,
                      ),
                    ),
                    elevation: 0,
                    onPress: () {
                      cancelOrder(context);
                    },
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height:
                transaction.status == 'pending' || transaction.status == 'paid'
                    ? 24
                    : 0,
          ),
        ],
      ),
    );
  }
}
