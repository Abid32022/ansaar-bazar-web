import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/cart_controller.dart';
import 'package:ansarbazzarweb/controller/location_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/no_internet_screen.dart';
import 'package:ansarbazzarweb/view/screens/dashboard/dashboard_screen.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/banner_controller.dart';
import '../../../controller/category_controller.dart';
import '../../../controller/notification_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../data/model/response/restaurant_model.dart';
import '../../base/web_menu_bar.dart';

class SplashScreen extends StatefulWidget {
  final Restaurant restaurant;
  final String orderID;
  SplashScreen({@required this.orderID,   @required this.restaurant,});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();
  }
  static Future<void> loadData(bool reload) async {
    // Get.find<BannerController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    // Get.find<RestaurantController>().getPopularRestaurantList(reload, 'all', false);
    // Get.find<CampaignController>().getItemCampaignList(reload);
    //  Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    //  Get.find<RestaurantController>().getLatestRestaurantList(reload, 'all', false);
    //  Get.find<ProductController>().getReviewedProductList(reload, 'all', false);
    Get.find<RestaurantController>().getRestaurantList('1', reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {

    Get.find<SplashController>().getConfigData().then((isSuccess) {
      print("confiw is suuuuuss");
      if (isSuccess) {
        Timer(Duration(seconds: 0), () async {
          int _minimumVersion = 0;
          if (GetPlatform.isAndroid) {_minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            _minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionIos;
          }
          if (AppConstants.APP_VERSION < _minimumVersion ||
              Get.find<SplashController>().configModel.maintenanceMode) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.APP_VERSION < _minimumVersion));
          } else {
            if (widget.orderID != null) {
              Get.offNamed(RouteHelper.getOrderDetailsRoute(int.parse(widget.orderID)));
            } else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<WishListController>().getWishList();

                if (Get.find<LocationController>().getUserAddress() != null) {
                  // Get.toNamed(RouteHelper.getRestaurantRoute(1), arguments: RestaurantScreen(restaurant: widget.restaurant));
                //
                //   // Get.offNamed(RouteHelper.getInitialRoute());
                  Get.to(()=> RestaurantScreen());
                } else {
                  Get.to(()=> RestaurantScreen());
                //   // Get.offNamed(RouteHelper.getInitialRoute());
                //   // Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                Get.to(()=> RestaurantScreen());
                // Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.restaurant));
                // if (Get.find<SplashController>().showIntro()) {
                //   Get.offNamed(RouteHelper.getOnBoardingRoute());
                //   // if (AppConstants.languages.length > 1) {
                //   //   Get.offNamed(RouteHelper.getLanguageRoute('language'));
                //   // } else {
                //   //   Get.offNamed(RouteHelper.getOnBoardingRoute());
                //   // }
                // } else {
                //   Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                // }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData(false);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.logo, width: 200),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              //  Image.asset(Images.logo_name, width: 150),
              // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              // Text(
              //   AppConstants.APP_NAME,
              //   style: robotoMedium.copyWith(
              //       fontSize:
              //           26), // style1: robotoMedium.copyWith(fontSize: 25)
              // ),

            ],
          )
              : NoInternetScreen(child: SplashScreen(orderID: widget.orderID)),
        );
      }),
    );
  }
}





// import 'dart:async';
// import 'package:connectivity/connectivity.dart';
// import 'package:ansarbazzarweb/controller/auth_controller.dart';
// import 'package:ansarbazzarweb/controller/cart_controller.dart';
// import 'package:ansarbazzarweb/controller/location_controller.dart';
// import 'package:ansarbazzarweb/controller/splash_controller.dart';
// import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
// import 'package:ansarbazzarweb/helper/route_helper.dart';
// import 'package:ansarbazzarweb/util/app_constants.dart';
// import 'package:ansarbazzarweb/util/dimensions.dart';
// import 'package:ansarbazzarweb/util/images.dart';
// import 'package:ansarbazzarweb/util/styles.dart';
// import 'package:ansarbazzarweb/view/base/no_internet_screen.dart';
// import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controller/banner_controller.dart';
// import '../../../controller/category_controller.dart';
// import '../../../controller/notification_controller.dart';
// import '../../../controller/restaurant_controller.dart';
// import '../../../controller/user_controller.dart';
// import '../../../data/model/response/restaurant_model.dart';
//
// class SplashScreen extends StatefulWidget {
//   final Restaurant restaurant;
//   final String orderID;
//   SplashScreen({@required this.orderID,   @required this.restaurant,});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   GlobalKey<ScaffoldState> _globalKey = GlobalKey();
//   StreamSubscription<ConnectivityResult> _onConnectivityChanged;
//
//   @override
//   void initState() {
//     super.initState();
//
//     bool _firstTime = true;
//     _onConnectivityChanged = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (!_firstTime) {
//         bool isNotConnected = result != ConnectivityResult.wifi &&
//             result != ConnectivityResult.mobile;
//         isNotConnected
//             ? SizedBox()
//             : ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 6000 : 3),
//           content: Text(
//             isNotConnected ? 'no_connection'.tr : 'connected'.tr,
//             textAlign: TextAlign.center,
//           ),
//         ));
//         if (!isNotConnected) {
//           _route();
//         }
//       }
//       _firstTime = false;
//     });
//
//     Get.find<SplashController>().initSharedData();
//     Get.find<CartController>().getCartData();
//     _route();
//   }
//   static Future<void> loadData(bool reload) async {
//     // Get.find<BannerController>().getBannerList(reload);
//     Get.find<CategoryController>().getCategoryList(reload);
//     // Get.find<RestaurantController>().getPopularRestaurantList(reload, 'all', false);
//     // Get.find<CampaignController>().getItemCampaignList(reload);
//     //  Get.find<ProductController>().getPopularProductList(reload, 'all', false);
//     //  Get.find<RestaurantController>().getLatestRestaurantList(reload, 'all', false);
//     //  Get.find<ProductController>().getReviewedProductList(reload, 'all', false);
//     Get.find<RestaurantController>().getRestaurantList('1', reload);
//     if (Get.find<AuthController>().isLoggedIn()) {
//       Get.find<UserController>().getUserInfo();
//       Get.find<NotificationController>().getNotificationList(reload);
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _onConnectivityChanged.cancel();
//   }
//
//   void _route() {
//
//     Get.find<SplashController>().getConfigData().then((isSuccess) {
//       if (isSuccess) {
//         Timer(Duration(seconds: 1), () async {
//           int _minimumVersion = 0;
//           if (GetPlatform.isAndroid) {_minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionAndroid;
//           } else if (GetPlatform.isIOS) {
//             _minimumVersion =
//                 Get.find<SplashController>().configModel.appMinimumVersionIos;
//           }
//           if (AppConstants.APP_VERSION < _minimumVersion ||
//               Get.find<SplashController>().configModel.maintenanceMode) {
//             Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.APP_VERSION < _minimumVersion));
//           } else {
//             if (widget.orderID != null) {
//               Get.offNamed(RouteHelper.getOrderDetailsRoute(int.parse(widget.orderID)));
//             } else {
//               if (Get.find<AuthController>().isLoggedIn()) {
//                 Get.find<AuthController>().updateToken();
//                 await Get.find<WishListController>().getWishList();
//                 // if (Get.find<LocationController>().getUserAddress() != null) {
//                 //   // Get.toNamed(RouteHelper.getRestaurantRoute(1), arguments: RestaurantScreen(restaurant: widget.restaurant));
//                 //
//                 //   // Get.offNamed(RouteHelper.getInitialRoute());
//                 //   Get.to(()=> RestaurantScreen());
//                 // } else {
//                 //   Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
//                 // }
//               } else {
//                 if (Get.find<SplashController>().showIntro()) {
//                   Get.offNamed(RouteHelper.getOnBoardingRoute());
//                   // if (AppConstants.languages.length > 1) {
//                   //   Get.offNamed(RouteHelper.getLanguageRoute('language'));
//                   // } else {
//                   //   Get.offNamed(RouteHelper.getOnBoardingRoute());
//                   // }
//                 } else {
//                   Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
//                 }
//               }
//             }
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     loadData(false);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: _globalKey,
//       body: GetBuilder<SplashController>(builder: (splashController) {
//         return Center(
//           child: splashController.hasConnection
//               ? Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(Images.logo, width: 200),
//                     SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//
//                     //  Image.asset(Images.logo_name, width: 150),
//                     // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
//                     // Text(
//                     //   AppConstants.APP_NAME,
//                     //   style: robotoMedium.copyWith(
//                     //       fontSize:
//                     //           26), // style1: robotoMedium.copyWith(fontSize: 25)
//                     // ),
//
//                   ],
//                 )
//               : NoInternetScreen(child: SplashScreen(orderID: widget.orderID)),
//         );
//       }),
//     );
//   }
// }
