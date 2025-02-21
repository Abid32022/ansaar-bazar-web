import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.find<WishListController>().removeWishes();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    }else {
      showCustomSnackBar(response.statusText);
    }
  }
}
