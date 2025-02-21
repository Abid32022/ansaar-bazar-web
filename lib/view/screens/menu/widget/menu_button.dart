import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/cart_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/user_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/data/model/response/menu_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/confirmation_dialog.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../util/app_colors.dart';

class MenuButton extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;

  MenuButton(
      {@required this.menu, @required this.isProfile, @required this.isLogout});

  @override
  Widget build(BuildContext context) {
    int _count = ResponsiveHelper.isDesktop(context)
        ? 8
        : ResponsiveHelper.isTab(context)
            ? 6
            : 4;
    double _size = ((context.width > Dimensions.WEB_MAX_WIDTH
                ? Dimensions.WEB_MAX_WIDTH
                : context.width) /
            _count) -
        Dimensions.PADDING_SIZE_DEFAULT;

    return InkWell(
      onTap: () async {
        if (isLogout) {
          Get.back();
          if (Get.find<AuthController>().isLoggedIn()) {
            Get.dialog(
                ConfirmationDialog(
                    icon: Images.support,
                    description: 'are_you_sure_to_logout'.tr,
                    isLogOut: true,
                    onYesPressed: () {
                      Get.find<AuthController>().clearSharedData();
                      Get.find<CartController>().clearCartList();
                      Get.find<WishListController>().removeWishes();
                      Get.offAllNamed(
                          RouteHelper.getSignInRoute(RouteHelper.splash));
                    }),
                useSafeArea: false);
          } else {
            Get.find<WishListController>().removeWishes();
            Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
          }
        } else if (menu.route.startsWith('http')) {
          if (await canLaunch(menu.route)) {
            launch(menu.route);
          }
        } else {
          Get.offNamed(menu.route);
        }
      },
      child: Column(children: [
        Container(
          height: _size - (_size * 0.2),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          margin:
              EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: isLogout
                ? Get.find<AuthController>().isLoggedIn()
                    ? Colors.red
                    : Colors.green
                : AppColors.primarycolor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 200 : 200],
                  spreadRadius: 1,
                  blurRadius: 5,
              )
            ],
          ),
          alignment: Alignment.center,
          child: isProfile
              ? ProfileImageWidget(size: _size)
              : Image.asset(menu.icon,
                  width: _size, height: _size, color: Colors.white),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        Text(menu.title,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;

  ProfileImageWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImage(
            image:
                '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                '/${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel.image ?? '' : ''}',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
