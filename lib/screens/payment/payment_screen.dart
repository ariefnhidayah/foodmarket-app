import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/screens/order/success_order_screen.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:foodmarket/widgets/loading_dialog_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final int quantity;
  final FoodModel food;
  const PaymentScreen({Key? key, required this.quantity, required this.food})
      : super(key: key);

  static const String ROUTE_NAME = '/payment';

  @override
  // ignore: no_logic_in_create_state
  State<PaymentScreen> createState() => _PaymentScreenState(
        food: food,
        quantity: quantity,
      );
}

class _PaymentScreenState extends State<PaymentScreen> {
  final int quantity;
  final FoodModel food;

  late TransactionProvider _transactionProvider;
  late AuthenticationProvider _authenticationProvider;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _PaymentScreenState({required this.quantity, required this.food});

  @override
  void initState() {
    super.initState();
    _transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
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
        title: "Payment",
        subtitle: "You deserve better meal",
        context: context,
        routeName: '/payment',
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
                      "Item Ordered",
                      style: textStyleTheme().copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        ImageNetworkWidget(
                          imageUrl: food.picturePath,
                          width: 60,
                          height: 60,
                          boxFit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width -
                              24 -
                              24 -
                              12 -
                              60,
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
                                      food.name,
                                      style: textStyleTheme().copyWith(
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(food.price),
                                    style: textStyleTheme().copyWith(
                                      fontSize: 13,
                                      color: secondaryColor,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "$quantity items",
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
                                food.name,
                                style: textStyleTheme().copyWith(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(formatRupiah(quantity * food.price)),
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
                              Text(formatRupiah(25000)),
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
                              Text(formatRupiah(3000)),
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
                                formatRupiah(
                                    (quantity * food.price) + 25000 + 3000),
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
              Consumer<AuthenticationProvider>(
                builder: (context, data, _) {
                  if (data.userData == null) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Name",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data.userData!.name),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Phone No.",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data.userData!.phoneNumber),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Address",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data.userData!.address),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "House No.",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data.userData!.houseNumber),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "City",
                                    style: textStyleTheme().copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data.userData!.city),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(24),
              child: ButtonWidget(
                child: Text(
                  "Checkout Now",
                  style: textStyleTheme(),
                ),
                elevation: 0,
                onPress: () {
                  showLoaderDialog(context);
                  Future.delayed(const Duration(seconds: 1), () async {
                    var response =
                        await _transactionProvider.exec(food, quantity, 25000);
                    Navigator.pop(context);
                    if (response.success) {
                      Navigator.pushNamed(
                          context, SuccessOrderScreen.ROUTE_NAME);
                    } else {
                      if (response.statusCode == 401) {
                        await _authenticationProvider.logout().then((value) {
                          alertIsUnauthorized(context);
                        });
                      } else {
                        showNotificationToast(_scaffoldKey, context,
                            !response.success, response.message);
                      }
                    }
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
