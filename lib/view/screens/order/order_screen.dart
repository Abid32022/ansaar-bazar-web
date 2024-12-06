import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/order_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/no_data_screen.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:ansarbazzarweb/view/screens/order/widget/order_shimmer.dart';
import 'package:ansarbazzarweb/view/screens/order/widget/order_view.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/response/order_model.dart';
import '../../../helper/date_converter.dart';
import '../../../util/app_colors.dart';
import '../../../util/images.dart';
import 'order_details_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;
  bool isRunning = false;
  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Get.find<OrderController>().getRunningOrders(1);
      Get.find<OrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: 'my_orders'.tr,
          isBackButtonExist: ResponsiveHelper.isDesktop(context)),
      body: _isLoggedIn
          ? SingleChildScrollView(
        child: GetBuilder<OrderController>(
          builder: (orderController) {
            return Column(children: [
              GetBuilder<OrderController>(builder: (orderController) {
                List<OrderModel> orderList;
                bool paginate = false;
                int pageSize = 1;
                int offset = 1;
                if (orderController.runningOrderList != null &&
                    orderController.historyOrderList != null) {
                  orderList = isRunning
                      ? orderController.runningOrderList
                      : orderController.historyOrderList;
                  paginate = isRunning
                      ? orderController.runningPaginate
                      : orderController.historyPaginate;
                  pageSize = isRunning
                      ? (orderController.runningPageSize / 10).ceil()
                      : (orderController.historyPageSize / 10).ceil();
                  offset = isRunning
                      ? orderController.runningOffset
                      : orderController.historyOffset;
                }
                scrollController?.addListener(() {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent &&
                      orderList != null &&
                      !paginate) {
                    if (offset < pageSize) {
                      Get.find<OrderController>().setOffset(offset + 1, isRunning);
                      print('end of the page');
                      Get.find<OrderController>().showBottomLoader(isRunning);
                      if (isRunning) {
                        Get.find<OrderController>().getRunningOrders(offset + 1);
                      } else {
                        Get.find<OrderController>().getHistoryOrders(offset + 1);
                      }
                    }
                  }
                });

                return orderList != null
                    ? orderList.length > 0
                    ? RefreshIndicator(
                  onRefresh: () async {
                    if (isRunning) {
                      await orderController.getRunningOrders(1);
                    } else {
                      await orderController.getHistoryOrders(1);
                    }
                  },
                  child: Container(
                    // color: Colors.red,
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(
                      children: [
                        Container(
                          // height: 500,
                          child: ListView.builder(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: orderList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // Get.to(()=> RestaurantScreen());
                                  Get.to(()=> OrderDetailsScreen(orderId:orderList[index].id ,orderModel: orderList[index] ),
                                  // Get.toNamed(RouteHelper.getOrderDetailsRoute(orderList[index].id), arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                                  );
                                },
                                child: Container(
                                  padding: ResponsiveHelper.isDesktop(context)
                                      ? EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL)
                                      : null,
                                  margin: ResponsiveHelper.isDesktop(context)
                                      ? EdgeInsets.only(
                                      bottom:
                                      Dimensions.PADDING_SIZE_SMALL)
                                      : null,
                                  decoration: ResponsiveHelper.isDesktop(
                                      context)
                                      ? BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                          Get.isDarkMode
                                              ? 700
                                              : 300],
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                  )
                                      : null,
                                  child: Column(children: [
                                    Row(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        child: CustomImage(
                                          image:
                                          '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                                              '/${orderList[index].restaurant.logo}',
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                          Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Text('${'order_id'.tr}:',
                                                    style: robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall)),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                Text(
                                                    '#${orderList[index].id}',
                                                    style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall)),
                                              ]),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              Text(
                                                DateConverter
                                                    .dateTimeStringToDateTime(
                                                    orderList[index]
                                                        .createdAt),
                                                style: robotoRegular.copyWith(
                                                    color:  Colors.black,
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                          width:
                                          Dimensions.PADDING_SIZE_SMALL),
                                      Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    Dimensions
                                                        .RADIUS_SMALL),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                  orderList[index]
                                                      .orderStatus
                                                      .tr,
                                                  style:
                                                  robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                  )),
                                            ),
                                            SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            ///Track order
                                            ///Track order
                                            ///Track order
                                            isRunning
                                                ? InkWell(
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getOrderTrackingRoute(
                                                      orderList[
                                                      index]
                                                          .id)),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_SMALL,
                                                    vertical: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                      .RADIUS_SMALL),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(
                                                          context)
                                                          .primaryColor),
                                                ),
                                                child: Row(children: [
                                                  Image.asset(
                                                      Images.tracking,
                                                      height: 15,
                                                      width: 15,
                                                      color: Theme.of(
                                                          context)
                                                          .primaryColor),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  Text('track_order'.tr,
                                                      style:
                                                      robotoMedium
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(
                                                            context)
                                                            .primaryColor,
                                                      )),
                                                ]),
                                              ),
                                            )
                                                : Text(
                                              '${orderList[index].detailsCount} ${orderList[index].detailsCount > 1 ? 'items'.tr : 'item'.tr}',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall),
                                            ),
                                          ]),
                                    ]),
                                    (index == orderList.length - 1 ||
                                        ResponsiveHelper.isDesktop(
                                            context))
                                        ? SizedBox()
                                        : Padding(
                                      padding:
                                      EdgeInsets.only(left: 70),
                                      child: Divider(
                                        color: Theme.of(context)
                                            .disabledColor,
                                        height: Dimensions
                                            .PADDING_SIZE_LARGE,
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
                        ),
                        paginate
                            ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: CircularProgressIndicator(),
                            ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                )
                    : NoDataScreen(text: 'no_order_found'.tr)
                    : Container(
                  height: 500,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
                // OrderShimmer(orderController: orderController);
              }),
              // Center(
              //   child:
              //   Container(
              //     width: Dimensions.WEB_MAX_WIDTH,
              //     color: Colors.white,
              //     child: TabBar(
              //       controller: _tabController,
              //       indicatorColor:AppColors.primarycolor,
              //       indicatorWeight: 3,
              //       labelColor:AppColors.primarycolor,
              //       unselectedLabelColor: Colors.grey,
              //       unselectedLabelStyle: robotoRegular.copyWith(
              //           color: Colors.grey,
              //           fontSize: Dimensions.fontSizeSmall),
              //       labelStyle: robotoBold.copyWith(
              //           fontSize: Dimensions.fontSizeSmall,
              //           color:Color(0xFF009f67)),
              //       tabs: [
              //         Tab(text: 'running'.tr),
              //         Tab(text: 'history'.tr),
              //       ],
              //     ),
              //   ),
              // ),
              // OrderView(isRunning: false),
              // Expanded(
              //     child: TabBarView(
              //   controller: _tabController,
              //   children: [
              //     OrderView(isRunning: true),
              //     OrderView(isRunning: false),
              //   ],
              // )),
            ]);
          },
        ),
      )
          : NotLoggedInScreen(),
    );
  }
}

