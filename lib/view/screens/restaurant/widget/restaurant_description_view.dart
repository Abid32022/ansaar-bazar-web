import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/data/model/response/address_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantDescriptionView extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantDescriptionView({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Color _textColor = ResponsiveHelper.isDesktop(context) ? Colors.white : Colors.black;
    return Column(
        children: [

      // Row(children: [
      //   ClipRRect(
      //     borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      //     child: CustomImage(
      //       image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${restaurant.logo}',
      //       height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 100 : 70, fit: BoxFit.cover,
      //     ),
      //   ),
      //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
      //   Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //     Text(
      //       restaurant.name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: _textColor),
      //       maxLines: 1, overflow: TextOverflow.ellipsis,
      //     ),
      //     SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
      //     Text(
      //       restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
      //       style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      //     ),
      //     SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
      //     restaurant.openingTime != null ? Row(children: [
      //       Text('daily_time'.tr, style: robotoRegular.copyWith(
      //         fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
      //       )),
      //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //       Text(
      //         '${DateConverter.convertTimeToTime(restaurant.openingTime)}'
      //             ' - ${DateConverter.convertTimeToTime(restaurant.closeingTime)}',
      //         style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color:Color(0xFF009f67)),
      //       ),
      //     ]) : SizedBox(),
      //     SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
      //     Row(children: [
      //       Text('minimum_order'.tr, style: robotoRegular.copyWith(
      //         fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
      //       )),
      //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //       Text(
      //         PriceConverter.convertPrice(restaurant.minimumOrder),
      //         style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color:Color(0xFF009f67)),
      //       ),
      //     ]),
      //   ])),
      //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
      //   GetBuilder<WishListController>(builder: (wishController) {
      //     bool _isWished = wishController.wishRestIdList.contains(restaurant.id);
      //     return InkWell(
      //       onTap: () {
      //         if(Get.find<AuthController>().isLoggedIn()) {
      //           _isWished ? wishController.removeFromWishList(restaurant.id, true)
      //               : wishController.addToWishList(null, restaurant, true);
      //         }else {
      //           showCustomSnackBar('you_are_not_logged_in'.tr);
      //         }
      //       },
      //       child: Icon(
      //         _isWished ? Icons.favorite : Icons.favorite_border,
      //         color: _isWished ?Color(0xFF009f67) : Theme.of(context).disabledColor,
      //       ),
      //     );
      //   }),
      //
      // ]),
      // SizedBox(height: ResponsiveHelper.isDesktop(context) ? 30 : Dimensions.PADDING_SIZE_SMALL),
      //
      // Row(children: [
      //   Expanded(child: SizedBox()),
      //   InkWell(
      //     onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant.id)),
      //     child: Column(children: [
      //       Row(children: [
      //         Icon(Icons.star, color:AppColors.primarycolor size: 20),
      //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //         Text(
      //           restaurant.avgRating.toStringAsFixed(1),
      //           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor),
      //         ),
      //       ]),
      //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //       Text(
      //         '${restaurant.ratingCount} ${'ratings'.tr}',
      //         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor),
      //       ),
      //     ]),
      //   ),
      //   Expanded(child: SizedBox()),
      //   InkWell(
      //     onTap: () => Get.toNamed(RouteHelper.getMapRoute(
      //       AddressModel(
      //         id: restaurant.id, address: restaurant.address, latitude: restaurant.latitude,
      //         longitude: restaurant.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
      //       ), 'restaurant',
      //     )),
      //     child: Column(children: [
      //       Icon(Icons.location_on, color:AppColors.primarycolor size: 20),
      //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //       Text('location'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor)),
      //     ]),
      //   ),
      //   Expanded(child: SizedBox()),
      //   Column(children: [
      //     Row(children: [
      //       Icon(Icons.timer, color:AppColors.primarycolor size: 20),
      //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //       Text(
      //         '${restaurant.deliveryTime} ${'min'.tr}',
      //         style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor),
      //       ),
      //     ]),
      //     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //     Text('delivery_time'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor)),
      //   ]),
      //   (restaurant.delivery && restaurant.freeDelivery) ? Expanded(child: SizedBox()) : SizedBox(),
      //   (restaurant.delivery && restaurant.freeDelivery) ? Column(children: [
      //     Icon(Icons.money_off, color:AppColors.primarycolor size: 20),
      //     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //     Text('free_delivery'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _textColor)),
      //   ]) : SizedBox(),
      //   Expanded(child: SizedBox()),
      // ]),

    ]);
  }
}
