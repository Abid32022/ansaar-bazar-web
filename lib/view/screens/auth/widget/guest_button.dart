import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/screens/dashboard/dashboard_screen.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(

      style: TextButton.styleFrom(
        minimumSize: Size(1, 40),
      ),
      onPressed: () {
        Get.to(()=> RestaurantScreen());
        // Get.to(()=> DashboardScreen(pageIndex: 0, id: 1));
        // Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'continue_as'.tr} ', style: robotoRegular.copyWith(color: Colors.blue)),
        TextSpan(text: 'guest'.tr, style: robotoMedium.copyWith(color: Colors.black)),
      ])),
    );
  }
}
