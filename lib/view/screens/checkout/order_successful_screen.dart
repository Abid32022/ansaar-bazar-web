import 'dart:async';

import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_button.dart';
import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
import 'package:ansarbazzarweb/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(PaymentFailedDialog(orderID: orderID),
            barrierDismissible: false);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: Center(
          child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(status == 1 ? Images.checked : Images.warning,
                        width: 100, height: 100),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Text(
                      status == 1
                          ? 'you_placed_the_order_successfully'.tr
                          : 'your_order_is_failed_to_place'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE,
                          vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Text(
                        status == 1
                            ? 'your_order_is_placed_successfully'.tr
                            : 'your_order_is_failed_to_place_because'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                          buttonText: 'back_to_home'.tr,
                          onPressed: () =>
                              Get.to(()=> RestaurantScreen())
                              // Get.offAllNamed(RouteHelper.getInitialRoute())),
                    ),
                    )]))),
    );
  }
}
