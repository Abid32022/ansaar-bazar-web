import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/user_controller.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
import 'package:ansarbazzarweb/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:ansarbazzarweb/view/screens/profile/widget/profile_button.dart';
import 'package:ansarbazzarweb/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Colors.white,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
                backButton: true,
                circularImage: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: ClipOval(
                      child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                        '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
                ),
                mainWidget: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Center(
                        child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      color: Colors.white,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Column(children: [
                        Text(
                          _isLoggedIn
                              ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}'
                              : 'guest'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                        ),
                        SizedBox(height: 30),
                        _isLoggedIn
                            ? Row(children: [
                                ProfileCard(
                                    title: 'since_joining'.tr,
                                    data:
                                        '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                ProfileCard(
                                    title: 'total_order'.tr,
                                    data: userController
                                        .userInfoModel.orderCount
                                        .toString()),
                              ])
                            : SizedBox(),
                        SizedBox(height: _isLoggedIn ? 30 : 0),
/*
              ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
*/
                        _isLoggedIn
                            ? GetBuilder<AuthController>(
                                builder: (authController) {
                                return ProfileButton(
                                  icon: Icons.notifications,
                                  title: 'notification'.tr,
                                  isButtonActive: authController.notification,
                                  onTap: () {
                                    ///recent comment
                                    // authController.setNotificationActive(
                                    //     !authController.notification);
                                  },
                                );
                              })
                            : SizedBox(),
                        SizedBox(
                            height: _isLoggedIn
                                ? Dimensions.PADDING_SIZE_SMALL
                                : 0),
                        _isLoggedIn
                            ? ProfileButton(
                                icon: Icons.lock,
                                title: 'change_password'.tr,
                                onTap: () {
                                  Get.toNamed(RouteHelper.getResetPasswordRoute(
                                      '', '', 'password-change'));
                                })
                            : SizedBox(),
                        SizedBox(
                            height: _isLoggedIn
                                ? Dimensions.PADDING_SIZE_SMALL
                                : 0),
                        ProfileButton(
                            icon: Icons.edit,
                            title: 'edit_profile'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getUpdateProfileRoute());
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      ]),
                    ))),
              );
      }),
    );
  }
}
