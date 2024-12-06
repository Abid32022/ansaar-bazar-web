import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/data/model/response/config_model.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/discount_tag.dart';
import 'package:ansarbazzarweb/view/base/not_available_widget.dart';
import 'package:ansarbazzarweb/view/base/product_bottom_sheet.dart';
import 'package:ansarbazzarweb/view/base/rating_bar.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

import '../screens/restaurant/product_detail_screen.dart';

class ProductWidget extends StatelessWidget {

  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int RestaurantID;
  final dynamic deliveryCharges;

  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;

  ProductWidget(

      {@required this.product,
        @required this.deliveryCharges,
        @required this.RestaurantID,
      @required this.isRestaurant,
      @required this.restaurant,
      @required this.index,
      @required this.length,
      this.inRestaurant = false,
      this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    if(kDebugMode){
      // print("${widge}")
    }
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    // BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    if (isRestaurant) {
      bool _isClosedToday = false;
      _discount =
          restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null
          ? restaurant.discount.discountType
          : 'percent';
      _isAvailable = true;
    } else {
      _discount = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discount
          : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discountType
          : 'percent';
      _isAvailable =true;
    }

    return InkWell(
      onTap: () {
        if (isRestaurant) {

          // Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen());
          // Get.to(()=>ProductDetailScreen(
          //   deliveryCharges: ,
          // ));
        } else {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
            ProductDetailScreen(
              deliveryCharges: deliveryCharges,
                      // deliveryCharges: deliveryCharges,
                      product: product,
                      inRestaurantPage: inRestaurant,
                      isCampaign: isCampaign),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                )
              : Get.dialog(
                  Dialog(
                      child: ProductDetailScreen(

                          deliveryCharges: deliveryCharges,
                          product: product,
                          inRestaurantPage: inRestaurant,
                          isCampaign: isCampaign)),
                );
        }
      },

      child: Container(
        /// How to make a vertical padding for mobile ??

        padding: ResponsiveHelper.isDesktop(context)
            ? EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL,
              )
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),

          color: ResponsiveHelper.isDesktop(context)
              ? Theme.of(context).cardColor
              : Colors.white,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300],
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(2,2)
                  )
                ]
              : [
            BoxShadow(color: Colors.black.withOpacity(0.10),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0,1)
            ),
          ],
        ),

        /// Restaurant items display widget
        /// RestaurantScreen
        /// restaurant detail container RestaurantDescriptionView
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: 5
                  ),
                  child: isRestaurant
                      ? Row(children: [
                          Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              child: CustomImage(
                                image:
                                    '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                    '/${isRestaurant ? restaurant.logo : product.image}',
                                height: _desktop ? 120 : 65,
                                width: _desktop ? 120 : 80,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            DiscountTag(
                              discount: _discount,
                              discountType: _discountType,
                              freeDelivery: isRestaurant
                                  ? restaurant.freeDelivery
                                  : false,
                            ),
                            _isAvailable
                                ? SizedBox()
                                : NotAvailableWidget(
                                    isRestaurant: isRestaurant),
                          ]),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isRestaurant
                                        ? restaurant.name
                                        : product.name,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                    maxLines: _desktop ? 2 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      height: isRestaurant
                                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                          : 0),
                                  Text(
                                    isRestaurant
                                        ? restaurant.address
                                        : //product.restaurantName ??
                                        '',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      height:
                                          (_desktop || isRestaurant) ? 5 : 0),
                                  !isRestaurant
                                      ? RatingBar(
                                          rating: isRestaurant
                                              ? restaurant.avgRating
                                              : product.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: isRestaurant
                                              ? restaurant.ratingCount
                                              : product.ratingCount,
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                      height: (!isRestaurant && _desktop)
                                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                          : 0),
                                  isRestaurant
                                      ? RatingBar(
                                          rating: isRestaurant
                                              ? restaurant.avgRating
                                              : product.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: isRestaurant
                                              ? restaurant.ratingCount
                                              : product.ratingCount,
                                        )
                                      : Row(children: [
                                          Text(
                                            PriceConverter.convertPrice(
                                                product.price,
                                                discount: _discount,
                                                discountType: _discountType),
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                          SizedBox(
                                              width: _discount > 0
                                                  ? Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL
                                                  : 0),
                                          _discount > 0
                                              ? Text(
                                                  PriceConverter.convertPrice(
                                                      product.price),
                                                  style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ]),
                                ]),
                          ),
                          Column(
                              mainAxisAlignment: isRestaurant
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                !isRestaurant
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: _desktop
                                                ? Dimensions.PADDING_SIZE_SMALL
                                                : 0),
                                        child: Icon(
                                          Icons.add,
                                          size: _desktop ? 30 : 25,
                                          color: Colors.black,
                                        ),
                                      )
                                    : SizedBox(),

                                GetBuilder<WishListController>(
                                    builder: (wishController) {
                                  bool _isWished = isRestaurant
                                      ? wishController.wishRestIdList
                                          .contains(restaurant.id)
                                      : wishController.wishProductIdList
                                          .contains(product.id);
                                  return InkWell(
                                    onTap: () {
                                      if (Get.find<AuthController>()
                                          .isLoggedIn()) {
                                        _isWished
                                            ? wishController.removeFromWishList(
                                                isRestaurant
                                                    ? restaurant.id
                                                    : product.id,
                                                isRestaurant)
                                            : wishController.addToWishList(
                                                product,
                                                restaurant,
                                                isRestaurant);
                                      } else {
                                        showCustomSnackBar(
                                            'you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: _desktop
                                              ? Dimensions.PADDING_SIZE_SMALL
                                              : 0),
                                      child: Icon(
                                        _isWished
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: _desktop ? 30 : 25,
                                        color: _isWished
                                            ? Color(0xFF009f67)
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }),
                              ]),
                        ])
                      : Column(children: [
                          Stack(children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  child: CustomImage(
                                    image: '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                        '/${isRestaurant ? restaurant.logo : product.image}',
                                    height: _desktop ? 120 : 140,
                                    width: _desktop ? 120 : 170,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 6,
                                  child: GetBuilder<WishListController>(
                                      builder: (wishController) {
                                        bool _isWished = isRestaurant
                                            ? wishController.wishRestIdList
                                            .contains(restaurant.id)
                                            : wishController.wishProductIdList
                                            .contains(product.id);
                                        return InkWell(
                                          onTap: () {
                                            if (Get.find<AuthController>()
                                                .isLoggedIn()) {
                                              _isWished
                                                  ? wishController.removeFromWishList(
                                                  isRestaurant
                                                      ? restaurant.id
                                                      : product.id,
                                                  isRestaurant)
                                                  : wishController.addToWishList(
                                                  product,
                                                  restaurant,
                                                  isRestaurant);
                                            } else {
                                              showCustomSnackBar(
                                                  'you_are_not_logged_in'.tr);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: _desktop
                                                    ? Dimensions.PADDING_SIZE_SMALL
                                                    : 0),
                                            child: Icon(
                                              _isWished
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: _desktop ? 30 : 25,
                                              color: _isWished
                                                  ?Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                            DiscountTag(
                              discount: _discount,
                              discountType: _discountType,
                              freeDelivery: isRestaurant
                                  ? restaurant.freeDelivery
                                  : false,
                            ),
                            _isAvailable
                                ? SizedBox()
                                : NotAvailableWidget(
                                    isRestaurant: isRestaurant),
                          ]),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isRestaurant
                                        ? restaurant.name
                                        : product.name,
                                    style: robotoMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                        fontSize: Dimensions.fontSizeDefault),
                                    maxLines: _desktop ? 2 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4,),
                                  //////////////////////////////////////////////////////////////////////

                                  // if (product.size != null && product.size.isNotEmpty)
                                  //   Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text('Product Sizes:'),
                                  //       for (var size in product.size) Text('- $size'),
                                  //     ],
                                  //   ),

                                  isRestaurant
                                      ? SizedBox()
                                      : Text(
                                          "${product.unit}",
                                          // product.kg == null
                                          //     ? ""
                                          //     : "${product.kg}kg",
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),

                                  Text(
                                    isRestaurant
                                        ? restaurant.address
                                        : //product.restaurantName ??
                                        '',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      height:
                                          (_desktop || isRestaurant) ? 5 : 0),
                                  ///rating code
                                  ///rating code
                                  ///rating code
                                  !isRestaurant
                                      ? RatingBar(
                                          rating: isRestaurant
                                              ? restaurant.avgRating
                                              : product.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: isRestaurant
                                              ? restaurant.ratingCount
                                              : product.ratingCount,
                                        )
                                      : SizedBox(),
                                  ///rating code
                                  ///rating code
                                  ///rating code
                                  SizedBox(
                                      height: (!isRestaurant && _desktop)
                                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                          : 0),
                                  isRestaurant
                                      ? RatingBar(
                                          rating: isRestaurant
                                              ? restaurant.avgRating
                                              : product.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: isRestaurant
                                              ? restaurant.ratingCount
                                              : product.ratingCount,
                                        )

                                      : Row(children: [
                                          Text(
                                            PriceConverter.convertPrice(
                                                product.price,
                                                discount: _discount,
                                                discountType: _discountType),
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                          SizedBox(
                                              width: _discount > 0
                                                  ? Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL
                                                  : 0),
                                          _discount > 0
                                              ? Text(
                                                  PriceConverter.convertPrice(
                                                      product.price),
                                                  style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ]),
                                ]),
                          ),
                          Row(
                              mainAxisAlignment: isRestaurant
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                !isRestaurant
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: _desktop
                                                ? Dimensions.PADDING_SIZE_SMALL
                                                : 0),
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Color(0xff2bad63),
                                            shape: BoxShape.circle
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              size: _desktop ? 30 : 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),

                             ///previous favorite icon place
                             ///previous favorite icon place

                              ]),
                          SizedBox(
                            height: 8,
                          ),
                        ]))),
          _desktop
              ? SizedBox()
              : isRestaurant
                  ? Padding(
                      padding: EdgeInsets.only(left: _desktop ? 130 : 90),
                      child: Divider(
                          color: index == length - 1
                              ? Colors.transparent
                              : Theme.of(context).disabledColor),
                    )
                  : SizedBox(),
        ]),
      ),
    );
  }
}
