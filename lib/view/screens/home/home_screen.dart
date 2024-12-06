import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/banner_controller.dart';
import 'package:ansarbazzarweb/controller/category_controller.dart';
import 'package:ansarbazzarweb/controller/location_controller.dart';
import 'package:ansarbazzarweb/controller/notification_controller.dart';
import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/user_controller.dart';
import 'package:ansarbazzarweb/data/model/response/config_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
import 'package:ansarbazzarweb/view/screens/home/web_home_screen.dart';
import 'package:ansarbazzarweb/view/screens/home/widget/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/product_controller.dart';
import '../../../util/app_colors.dart';

class HomeScreen extends StatelessWidget {

  static Future<void> loadData(bool reload) async {
    Get.find<BannerController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    // Get.find<RestaurantController>().getPopularRestaurantList(reload, 'all', false);
    // Get.find<CampaignController>().getItemCampaignList(reload);
     Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    //  Get.find<RestaurantController>().getLatestRestaurantList(reload, 'all', false);
    //  Get.find<ProductController>().getReviewedProductList(reload, 'all', false);
    Get.find<RestaurantController>().getRestaurantList('1', reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    loadData(false);
    ConfigModel _configModel = Get.find<SplashController>().configModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      // backgroundColor: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // await Get.find<BannerController>().getBannerList(true);
            await Get.find<CategoryController>().getCategoryList(true);
            //  await Get.find<RestaurantController>().getPopularRestaurantList(true, 'all', false);
            //   await Get.find<CampaignController>().getItemCampaignList(true);
            //   await Get.find<ProductController>().getPopularProductList(true, 'all', false);
            //   await Get.find<RestaurantController>().getLatestRestaurantList(true, 'all', false);
            //   await Get.find<ProductController>().getReviewedProductList(true, 'all', false);
            // await Get.find<RestaurantController>().getRestaurantList('1', true);

            if (Get.find<AuthController>().isLoggedIn()) {
              await Get.find<UserController>().getUserInfo();
              await Get.find<NotificationController>()
                  .getNotificationList(true);
            }
          },
          child: ResponsiveHelper.isDesktop(context)
              ? WebHomeScreen(scrollController: _scrollController)
              : CustomScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      floating: true,
                      elevation: 1,
                      automaticallyImplyLeading: false,
                      backgroundColor: ResponsiveHelper.isDesktop(context)
                          ? Colors.transparent
                          : AppColors.primarycolor,
                      title: Center(
                          child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        height: 50,
                        color: AppColors.primarycolor,
                        child: Row(children: [
                          Expanded(
                              child: InkWell(
                            onTap: () => Get.toNamed(
                                RouteHelper.getAccessLocationRoute('home')),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL,
                                horizontal: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0,
                              ),
                              // child: GetBuilder<LocationController>(
                              //     builder: (locationController) {
                              //   return Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Icon(
                              //         locationController
                              //                     .getUserAddress()
                              //                     .addressType ==
                              //                 'home'
                              //             ? Icons.home_filled
                              //             : locationController
                              //                         .getUserAddress()
                              //                         .addressType ==
                              //                     'office'
                              //                 ? Icons.work
                              //                 : Icons.location_on,
                              //         size: 20,
                              //         color: Colors.white,
                              //       ),
                              //       SizedBox(width: 10),
                              //       Flexible(
                              //         child: Text(
                              //           locationController
                              //               .getUserAddress()
                              //               .address,
                              //           style: robotoRegular.copyWith(
                              //             color: Colors.white,
                              //             fontSize: Dimensions.fontSizeSmall,
                              //           ),
                              //           maxLines: 1,
                              //           overflow: TextOverflow.ellipsis,
                              //         ),
                              //       ),
                              //       // Icon(Icons.arrow_drop_down,
                              //       //     color: Colors.white),
                              //     ],
                              //   );
                              // }),
                            ),
                          )),
                          InkWell(
                            child: GetBuilder<NotificationController>(
                                builder: (notificationController) {
                              bool _hasNewNotification = false;
                              if (notificationController.notificationList !=
                                  null) {
                                _hasNewNotification = notificationController
                                        .notificationList.length !=
                                    notificationController
                                        .getSeenNotificationCount();
                              }
                              return Stack(children: [
                                Icon(Icons.notifications,
                                    size: 25, color: Colors.white),
                                _hasNewNotification
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color:
                                               AppColors.primarycolor
                                            ,shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1, color: Colors.black),
                                          ),
                                        ))
                                    : SizedBox(),
                              ]);
                            }),
                            onTap: () =>
                                Get.toNamed(RouteHelper.getNotificationRoute()),
                          ),
                        ]),
                      )),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                          child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/image/image2.png",
                                      width: 340,
                                      height: 200,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: GetBuilder<RestaurantController>(
                                          builder: (restaurantController) {
                                        return Row(children: [
                                          Expanded(
                                              child: Text('all_restaurants'.tr,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge))),
                                        ]);
                                      }),
                                    ),
                                    SizedBox(height: 20),

                                    RestaurantView(
                                        scrollController: _scrollController),

                                  ]))),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
