import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/providers/authentication_provider.dart';
import 'package:foodmarket/providers/home_screen_provider.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/widgets/appbar_widget.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/custom_alert_dialog.dart';
import 'package:foodmarket/widgets/food_banner_widget.dart';
import 'package:foodmarket/widgets/food_widget.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:foodmarket/widgets/lazy_load_widget.dart';
import 'package:foodmarket/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AuthenticationProvider _authenticationProvider;
  late HomeScreenProvider _homeScreenProvider;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Tab> foodCategoryTabs = <Tab>[
    const Tab(text: "New Taste"),
    const Tab(text: "Popular"),
    const Tab(text: "Recommended"),
  ];

  late TabController _tabController;

  int tabIndex = 0;
  double tabBarViewHeight = 300;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    _tabController =
        TabController(vsync: this, length: foodCategoryTabs.length);
    _tabController.index = tabIndex;
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
        tabBarViewHeight = 16 + ((60 + 16) * 3) + 50;
        foods = loadingFoods;
      });
      Future.delayed(const Duration(seconds: 1), () async {
        await getFoods(context);
      });
    });
    tabBarViewHeight = 16 + ((60 + 16) * 3) + 50;
    foods = loadingFoods;

    foodBanner = loadingFoodBanner;
    startLoading();
  }

  List<Widget> loadingFoodBanner = List.generate(
    6,
    (index) => Container(
      width: 200,
      margin: EdgeInsets.only(
        left: index == 0 ? 24 : 0,
        right: 24,
        top: 24,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.150),
            blurRadius: 4,
            offset: const Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LazyLoadWidget(
              child: Container(
                width: 200,
                height: 140,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LazyLoadWidget(
                    child: Container(
                      width: 120,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  LazyLoadWidget(
                    child: Container(
                      width: 80,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );

  List<Widget> foodBanner = [];

  List<Widget> foods = [];

  List<Widget> loadingFoods = List.generate(
    3,
    (index) => Container(
      margin: const EdgeInsets.only(
        bottom: 16,
        left: 24,
        right: 24,
      ),
      child: Row(
        children: [
          LazyLoadWidget(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LazyLoadWidget(
                child: Text(
                  "Loading...",
                  style: textStyleTheme().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              LazyLoadWidget(
                child: Text(
                  "Loading...",
                  style: textStyleTheme().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: secondaryColor,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );

  void startLoading() async {
    Future.delayed(const Duration(milliseconds: 10), () {
      _refreshIndicatorKey.currentState!.show();
    });
  }

  Future<void> getFoodBanner(BuildContext context) async {
    setState(() {
      foodBanner = loadingFoodBanner;
      tabBarViewHeight = 16 + ((60 + 16) * 3) + 50;
      foods = loadingFoods;
    });
    ResponseModel<List<FoodModel>> response =
        await _homeScreenProvider.getFoodBanner();

    if (response.success) {
      if (response.data!.isNotEmpty) {
        foodBanner = response.data!.map((item) {
          int index = response.data!.indexOf(item);
          return FoodBannerWidget(food: item, index: index);
        }).toList();
        setState(() {});
      }
    } else {
      showNotificationToast(
          widget.scaffoldKey, context, true, response.message);
    }
  }

  Future<void> getFoods(BuildContext context) async {
    ResponseModel<List<FoodModel>> response =
        await _homeScreenProvider.getFoodsByType(
      tabIndex == 0
          ? 'New Taste'
          : tabIndex == 1
              ? 'Popular'
              : 'Recommended',
    );

    if (response.success) {
      if (response.data!.isNotEmpty) {
        foods = response.data!.map((item) {
          return FoodWidget(food: item);
        }).toList();
        tabBarViewHeight = 16 + ((60 + 16) * foods.length) + 70;
      }
    } else {
      showNotificationToast(
          widget.scaffoldKey, context, true, response.message);
    }
    setState(() {});
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
              var response = await _authenticationProvider.logout();
              if (response.success) {
                _authenticationProvider.getUserData();
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
    return Scaffold(
      appBar: appBar(
        context: context,
        routeName: '/',
        title: 'FoodMarket',
        subtitle: "Let's get some foods",
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<AuthenticationProvider>(
                builder: (context, data, _) {
                  return GestureDetector(
                    onTap: () async {
                      // alertLogout(context);
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setBottomNavbarIndex(2);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageNetworkWidget(
                          imageUrl: data.userData!.profilePhotoPath,
                          width: 50,
                          height: 50,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await getFoodBanner(context);
          await getFoods(context);
        },
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: foodBanner,
                  ),
                ),
                DefaultTabController(
                  length: foodCategoryTabs.length,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TabBar(
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
                          tabs: foodCategoryTabs,
                        ),
                      ),
                      Container(
                        //Add this to give height
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
                          physics: const NeverScrollableScrollPhysics(),
                          children: foodCategoryTabs
                              .map(
                                (tab) => Column(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    for (Widget food in foods) food,
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
