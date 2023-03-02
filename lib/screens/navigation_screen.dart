import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodmarket/providers/navigation_provider.dart';
import 'package:foodmarket/screens/home/home_screen.dart';
import 'package:foodmarket/screens/order/order_screen.dart';
import 'package:foodmarket/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() =>
      // ignore: no_logic_in_create_state
      _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int bottomNavbarIndex = 0;

  _NavigationScreenState();

  late PageController _pageController;
  late NavigationProvider _navigationProvider;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    _pageController =
        PageController(initialPage: _navigationProvider.bottomNavbarIndex);
    bottomNavbarIndex = _navigationProvider.bottomNavbarIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, data, _) {
        if (data.bottomNavbarIndex != bottomNavbarIndex) {
          bottomNavbarIndex = data.bottomNavbarIndex;
          _pageController.jumpToPage(bottomNavbarIndex);
        }
        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              Container(
                color: Colors.white,
              ),
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeScreen(
                    scaffoldKey: scaffoldKey,
                  ),
                  const OrderScreen(),
                  const ProfileScreen(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  iconSize: 32,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  onTap: (index) {
                    // _pageController.jumpToPage(index);
                    // setState(() {
                    //   bottomNavbarIndex = index;
                    // });
                    _navigationProvider.setBottomNavbarIndex(index);
                  },
                  currentIndex: bottomNavbarIndex,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset("assets/images/ic_home.svg"),
                      icon:
                          SvgPicture.asset("assets/images/ic_home_normal.svg"),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      activeIcon:
                          SvgPicture.asset("assets/images/ic_order.svg"),
                      icon:
                          SvgPicture.asset("assets/images/ic_order_normal.svg"),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      activeIcon:
                          SvgPicture.asset("assets/images/ic_profile.svg"),
                      icon: SvgPicture.asset(
                          "assets/images/ic_profile_normal.svg"),
                      label: '',
                    ),
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
