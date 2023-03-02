import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/state.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/providers/transaction_provider.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/error_page_widget.dart';
import 'package:foodmarket/widgets/transaction_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TransactionProvider _transactionProvider;

  List<Tab> orderTabs = <Tab>[
    const Tab(text: "In Progress"),
    const Tab(text: "Past Orders"),
    const Tab(text: "Cancel Orders"),
  ];

  int tabIndex = 0;
  double tabBarViewHeight = 300;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: orderTabs.length);
    _transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    _transactionProvider.orderPageState = PageState.Loading;
    _tabController.index = tabIndex;
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
      Future.microtask(() => _transactionProvider.getOrderTabPage(tabIndex));
    });
    Future.microtask(() => _transactionProvider.getOrderData(tabIndex));
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
              await Provider.of<AuthenticationProvider>(context, listen: false)
                  .logout()
                  .then((value) {
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .getUserData();
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, data, _) {
        tabBarViewHeight = 300;
        if (data.transactions.isNotEmpty &&
            data.orderPageState == PageState.Loaded &&
            data.tabPageState == PageState.Loaded) {
          tabBarViewHeight = 16 + ((60 + 16) * data.transactions.length) + 70;
        }

        if (data.orderPageState == PageState.ErrorUnautorized ||
            data.tabPageState == PageState.ErrorUnautorized) {
          Future.delayed(const Duration(microseconds: 500), () {
            alertIsUnauthorized(context);
          });
          return const Scaffold(
            body: SizedBox(),
          );
        }

        if (data.orderPageState == PageState.Loaded) {
          return Scaffold(
            appBar: appBar(
              context: context,
              title: "Your Orders",
              subtitle: "Wait for the best meal",
            ),
            body: ListView(
              children: [
                DefaultTabController(
                  length: orderTabs.length,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: TabBar(
                          indicatorPadding: EdgeInsets.zero,
                          controller: _tabController,
                          isScrollable: true,
                          indicator: MaterialIndicator(
                            height: 3,
                            topLeftRadius: 8,
                            topRightRadius: 8,
                            bottomLeftRadius: 8,
                            bottomRightRadius: 8,
                            horizontalPadding: 30,
                            tabPosition: TabPosition.bottom,
                            color: textColor,
                          ),
                          labelColor: textColor,
                          labelStyle: textStyleTheme().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: orderTabs,
                        ),
                      ),
                      data.tabPageState == PageState.Loaded
                          ? data.transactions.isNotEmpty
                              ? Container(
                                  height: tabBarViewHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: orderTabs
                                        .map((tab) => Column(
                                              children: [
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                for (TransactionModel transaction
                                                    in data.transactions)
                                                  TransactionWidget(
                                                    transactionModel:
                                                        transaction,
                                                  ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 100,
                                      ),
                                      Image.asset(
                                        'assets/images/empty-vector.png',
                                        width: 200,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Ouch! Hungry",
                                        style: textStyleTheme().copyWith(
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Seems like you have not\nordered any food yet",
                                        style: textStyleTheme().copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ButtonWidget(
                                        width: 200,
                                        elevation: 0,
                                        onPress: () {
                                          Provider.of<NavigationProvider>(
                                                  context,
                                                  listen: false)
                                              .setBottomNavbarIndex(0);
                                        },
                                        child: const Text(
                                          "Find Foods",
                                          style: TextStyle(color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : data.tabPageState == PageState.Error
                              ? ErrorPageWidget(
                                  message: data.errorTabPageLoad,
                                  press: () {
                                    Future.microtask(() => _transactionProvider
                                        .getOrderTabPage(tabIndex));
                                  },
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 85,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              250,
                                      padding: const EdgeInsets.all(15),
                                      child: const LoadingIndicator(
                                        indicatorType: Indicator.ballPulse,
                                        colors: [primaryColor],
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (data.orderPageState == PageState.Error) {
          return ErrorPageWidget(
              message: data.errorPageLoad,
              press: () {
                Future.microtask(
                    () => _transactionProvider.getOrderData(tabIndex));
              });
        } else {
          return Center(
            child: Container(
              width: 85,
              padding: const EdgeInsets.all(15),
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [primaryColor],
              ),
            ),
          );
        }
      },
    );
  }
}
