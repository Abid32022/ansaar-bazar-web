import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/coupon_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/no_data_screen.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      Get.find<CouponController>().getCouponList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'coupon'.tr),
      body: _isLoggedIn
          ? GetBuilder<CouponController>(builder: (couponController) {
              return couponController.couponList != null
                  ? couponController.couponList.length > 0
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await couponController.getCouponList();
                          },
                          child: Scrollbar(
                              child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                                child: SizedBox(
                                    width: Dimensions.WEB_MAX_WIDTH,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ResponsiveHelper
                                                .isDesktop(context)
                                            ? 3
                                            : ResponsiveHelper.isTab(context)
                                                ? 2
                                                : 1,
                                        mainAxisSpacing:
                                            Dimensions.PADDING_SIZE_SMALL,
                                        crossAxisSpacing:
                                            Dimensions.PADDING_SIZE_SMALL,
                                        childAspectRatio:
                                            ResponsiveHelper.isMobile(context)
                                                ? 2.6
                                                : 2.4,
                                      ),
                                      itemCount:
                                          couponController.couponList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_LARGE),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: couponController
                                                    .couponList[index].code));
                                            showCustomSnackBar(
                                                'coupon_code_copied'.tr,
                                                isError: false);
                                          },
                                          child: Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              child: Image.asset(
                                                Images.coupon_bg,
                                                height: ResponsiveHelper
                                                        .isMobilePhone()
                                                    ? 120
                                                    : 140,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              height: ResponsiveHelper
                                                      .isMobilePhone()
                                                  ? 120
                                                  : 140,
                                              alignment: Alignment.center,
                                              child: Row(children: [
                                                SizedBox(width: 30),
                                                Image.asset(Images.coupon,
                                                    height: 50,
                                                    width: 50,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                SizedBox(width: 40),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${couponController.couponList[index].code} (${couponController.couponList[index].title})',
                                                          style: robotoRegular
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL),
                                                        Text(
                                                          '${couponController.couponList[index].discount}${couponController.couponList[index].discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} off',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor),
                                                        ),
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL),
                                                        Row(children: [
                                                          Text(
                                                            '${'valid_until'.tr}:',
                                                            style: robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          Text(
                                                            couponController
                                                                .couponList[
                                                                    index]
                                                                .expireDate,
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ]),
                                                        Row(children: [
                                                          Text(
                                                            '${'type'.tr}:',
                                                            style: robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          Flexible(
                                                              child: Text(
                                                            couponController
                                                                    .couponList[
                                                                        index]
                                                                    .couponType
                                                                    .tr +
                                                                '${couponController.couponList[index].couponType == 'restaurant_wise' ? ' (${couponController.couponList[index].data})' : ''}',
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        ]),
                                                        Row(children: [
                                                          Text(
                                                            '${'min_purchase'.tr}:',
                                                            style: robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          Text(
                                                            PriceConverter.convertPrice(
                                                                couponController
                                                                    .couponList[
                                                                        index]
                                                                    .minPurchase),
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ]),
                                                        Row(children: [
                                                          Text(
                                                            '${'max_discount'.tr}:',
                                                            style: robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          Text(
                                                            PriceConverter.convertPrice(
                                                                couponController
                                                                    .couponList[
                                                                        index]
                                                                    .maxDiscount),
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ]),
                                                      ]),
                                                ),
                                              ]),
                                            ),
                                          ]),
                                        );
                                      },
                                    ))),
                          )),
                        )
                      : NoDataScreen(text: 'no_coupon_found'.tr)
                  : Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(),
    );
  }
}
