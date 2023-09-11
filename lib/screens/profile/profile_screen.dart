import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/screens/profile/edit_address_screen.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> profileTabs = [
    const Tab(text: "Account"),
    const Tab(text: "FoodMarket"),
  ];

  int tabIndex = 0;
  double tabBarViewHeight = 400;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: profileTabs.length);
    _tabController.index = tabIndex;
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  void alertLogout(BuildContext context) {
    customAlertDialog(
      context,
      isDismissible: true,
      title: const Text("Are you sure want to sign out?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(
            elevation: 0,
            color: dangerColor,
            child: const Text("Yes"),
            onPress: () async {
              Navigator.pop(context);
              var response = await Provider.of<AuthenticationProvider>(context,
                      listen: false)
                  .logout();
              if (response.success) {
                Provider.of<NavigationProvider>(context, listen: false)
                    .setBottomNavbarIndex(0);
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .getUserData();
              }
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
    return Consumer<AuthenticationProvider>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leadingWidth: MediaQuery.of(context).size.width,
            titleSpacing: 0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageNetworkWidget(
                  imageUrl: data.userData!.profilePhotoPath,
                  width: 90,
                  height: 90,
                  boxFit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(200),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  data.userData!.name,
                  style:
                      textStyleTheme().copyWith(color: textColor, fontSize: 18),
                ),
                Text(
                  data.userData!.email,
                  style: textStyleTheme()
                      .copyWith(fontSize: 14, color: secondaryColor),
                )
              ],
            ),
            toolbarHeight: 232,
          ),
          body: ListView(
            children: [
              DefaultTabController(
                length: profileTabs.length,
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
                        tabs: profileTabs,
                      ),
                    ),
                    Container(
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
                        controller: _tabController,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 11,
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, EditProfileScreen.ROUTE_NAME);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Edit Profile'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, EditAddressScreen.ROUTE_NAME);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Home Address'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {},
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Security'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {
                                    alertLogout(context);
                                  },
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Sign Out'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 11,
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {},
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Rate App'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {},
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Help Center'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {},
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Privacy & Policy'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: () {},
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 24),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Terms & Conditions'),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
