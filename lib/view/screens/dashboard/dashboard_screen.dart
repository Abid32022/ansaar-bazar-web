import 'dart:async';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_colors.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/view/screens/cart/cart_screen.dart';
import 'package:ansarbazzarweb/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:ansarbazzarweb/view/screens/favourite/favourite_screen.dart';
import 'package:ansarbazzarweb/view/screens/home/home_screen.dart';
import 'package:ansarbazzarweb/view/screens/menu/menu_screen.dart';
import 'package:ansarbazzarweb/view/screens/order/order_screen.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../data/model/response/restaurant_model.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final int id;

  DashboardScreen({@required this.pageIndex,@required this.id,});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  // final restaurantController = RestaurantController();


  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      // RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen(restaurant: restaurant),
      // RestaurantScreen(restaurant:  restaurantController.restaurant,),
      RestaurantScreen(),
      OrderScreen(),
      CartScreen(fromNav: true),
      FavouriteScreen(),
      Container(),

    ];

    // List<GetPage> _screens = [
    //   GetPage(
    //     name: RouteHelper.getRestaurantRoute(widget.restaurant.id),
    //     page: () => RestaurantScreen(),
    //     // binding: RestaurantBinding(), // If you have a binding class
    //     // arguments: RestaurantScreen(restaurant: widget.restaurant.id),
    //   ),
    //   GetPage(
    //     name: 'OrderScreen', // Assuming you have a route for the OrderScreen
    //     page: () => OrderScreen(),
    //   ),
    //   GetPage(
    //     name: 'RouteHelper.cartScreen', // Assuming you have a route for the CartScreen
    //     page: () => CartScreen(fromNav: true),
    //   ),
    //   GetPage(
    //     name: 'RouteHelper.favouriteScreen', // Assuming you have a route for the FavouriteScreen
    //     page: () => FavouriteScreen(),
    //   ),
    //   GetPage(
    //     name: 'RouteHelper.containerScreen', // Assuming you have a route for the ContainerScreen
    //     page: () => Container(),
    //   ),
    // ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        //backgroundColor:  Color(0xffFFF8DC),
        key: _scaffoldKey,

        /*  floatingActionButton: ResponsiveHelper.isDesktop(context) ? null : FloatingActionButton(
          elevation: 5,
          backgroundColor: _pageIndex == 2 ?Color(0xFF009f67) : Theme.of(context).cardColor,
          onPressed: () => _setPage(2),
          child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/

        bottomNavigationBar:
        ResponsiveHelper.isDesktop(context)
            ? SizedBox()
            : BottomAppBar(
                color: AppColors.primarycolor,
                elevation: 5,
                notchMargin: 5,
                clipBehavior: Clip.antiAlias,
                shape: CircularNotchedRectangle(),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    BottomNavItem(
                        iconData: Icons.home,
                        isSelected: _pageIndex == 0,
                        onTap: () => _setPage(0)),
                    BottomNavItem(
                        iconData: Icons.bookmarks_sharp,
                        isSelected: _pageIndex == 1,
                        onTap: () => _setPage(1)),
                    // Expanded(child: SizedBox()),
                    BottomNavItem(
                        iconData: Icons.shopping_cart,
                        isSelected: _pageIndex == 2,
                        onTap: () => _setPage(2)),
                    BottomNavItem(

                        iconData: Icons.favorite_outlined,
                        isSelected: _pageIndex == 3,
                        onTap: () => _setPage(3)),
                    BottomNavItem(
                        iconData: Icons.menu,
                        isSelected: _pageIndex == 4,
                        onTap: () {
                          Get.bottomSheet(MenuScreen(),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true);
                          // Get.bottomSheet(MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                        }),
                  ]),
                ),
              ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
