import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/data/model/response/menu_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _ratio = ResponsiveHelper.isDesktop(context)
        ? 1.1
        : ResponsiveHelper.isTab(context)
            ? 1.1
            : 1.2;

    final List<MenuModel> _menuList = [
      MenuModel(
          icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: Images.location,
          title: 'my_address'.tr,
          route: RouteHelper.getAddressRoute()),
      // MenuModel(
      //     icon: Images.language,
      //     title: 'language'.tr,
      //     route: RouteHelper.getLanguageRoute('menu')),
      // MenuModel(
      //     icon: Images.coupon,
      //     title: 'coupon'.tr,
      //     route: RouteHelper.getCouponRoute()),
      // MenuModel(
      //     icon: Images.support,
      //     title: 'help_support'.tr,
      //     route: RouteHelper.getSupportRoute()),
      MenuModel(
          icon: Images.policy,
          title: 'privacy_policy'.tr,
          route: RouteHelper.getHtmlRoute('privacy-policy')),
      //MenuModel(icon: Images.policy, title: 'language'.tr, route: RouteHelper.getHtmlRoute('language-policy')),
      // MenuModel(
      //     icon: Images.about_us,
      //     title: 'about_us'.tr,
      //     route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(
          icon: Images.terms,
          title: 'terms_conditions'.tr,
          route: RouteHelper.getHtmlRoute('terms-and-condition')),
    ];
    // if (Get.find<SplashController>().configModel.toggleDmRegistration &&
    //     !ResponsiveHelper.isDesktop(context)) {
    //   _menuList.add(MenuModel(
    //     icon: Images.delivery_man_join,
    //     title: 'join_as_a_delivery_man'.tr,
    //     route: '${AppConstants.BASE_URL}/deliveryman/apply',
    //   ));
    // }
    // if (Get.find<SplashController>().configModel.toggleRestaurantRegistration &&
    //     !ResponsiveHelper.isDesktop(context)) {
    //   _menuList.add(MenuModel(
    //     icon: Images.restaurant_join,
    //     title: 'join_as_a_restaurant'.tr,
    //     route: '${AppConstants.BASE_URL}/restaurant/apply',
    //   ));
    // }
    _menuList.add(MenuModel(
        icon: Images.log_out,
        title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
        route: ''));

    return PointerInterceptor(
      child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context)
                  ? 8
                  : ResponsiveHelper.isTab(context)
                      ? 6
                      : 4,
              childAspectRatio: (1 / _ratio),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(
                  menu: _menuList[index],
                  isProfile: index == 0,
                  isLogout: index == _menuList.length - 1);
            },
          ),
          SizedBox(
              height: ResponsiveHelper.isMobile(context)
                  ? Dimensions.PADDING_SIZE_SMALL
                  : 0),
        ]),
      ),
    );
  }
}
