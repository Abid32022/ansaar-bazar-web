import 'dart:async';
import 'dart:io';
import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/cart_controller.dart';
import 'package:ansarbazzarweb/controller/localization_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/theme_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/helper/notification_helper.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/theme/light_theme.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/messages.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if(ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = new MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  Map<String, Map<String, String>> _languages = await di.init();

  int _orderID;

  // try {
  //   if (GetPlatform.isMobile) {
  //     // final RemoteMessage remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
  //     // if (remoteMessage != null) {
  //     //   _orderID = remoteMessage.notification.titleLocKey != null ? int.parse(remoteMessage.notification.titleLocKey) : null;
  //     // }
  //     await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  //     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  //   }
  // }catch(e) {}

  runApp(MyApp(languages: _languages, orderID: _orderID));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final int orderID;
  MyApp({@required this.languages, @required this.orderID});

  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<WishListController>().getWishList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      Get.find<CartController>().getCartData();
      _route();
    }

    /// web 1.2
    ///

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null) ? SizedBox() :
          GetMaterialApp(
            title: AppConstants.APP_NAME,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            theme: themeController.darkTheme ? light : light,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            // fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),

            initialRoute: GetPlatform.isWeb ?RouteHelper.getSplashRoute(orderID) : RouteHelper.getSplashRoute(orderID),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 500),
          );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
