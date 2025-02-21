import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/theme_controller.dart';
import 'package:ansarbazzarweb/controller/wishlist_controller.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/discount_tag.dart';
import 'package:ansarbazzarweb/view/base/not_available_widget.dart';
import 'package:ansarbazzarweb/view/base/rating_bar.dart';
import 'package:ansarbazzarweb/view/base/title_widget.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class PopularRestaurantView extends StatelessWidget {
  final RestaurantController restController;
  final bool isPopular;
  PopularRestaurantView({@required this.restController, @required this.isPopular});

  @override
  Widget build(BuildContext context) {
    List<Restaurant> _restaurantList = isPopular ? restController.popularRestaurantList : restController.latestRestaurantList;
    ScrollController _scrollController = ScrollController();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, isPopular ? 2 : 15, 10, 10),
          child: TitleWidget(
            title: isPopular ? 'popular_restaurants'.tr : '${'new_on'.tr} ${AppConstants.APP_NAME}',
            onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isPopular ? 'popular' : 'latest')),
          ),
        ),

        SizedBox(
          height: 150,
          child: _restaurantList != null ? ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
            itemCount: _restaurantList.length > 10 ? 10 : _restaurantList.length,
            itemBuilder: (context, index){
              bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(
                true, _restaurantList[index].active, _restaurantList[index].offDay,
              );
              bool _isAvailable = DateConverter.isAvailable(
                _restaurantList[index].openingTime,
                _restaurantList[index].closeingTime,
              ) && _restaurantList[index].active && !_isClosedToday;

              return Padding(
                padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.getRestaurantRoute(_restaurantList[index].id),
                      // arguments: RestaurantScreen(restaurant: _restaurantList[index]),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(
                        color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                        blurRadius: 5, spreadRadius: 1,
                      )],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}'
                                '/${_restaurantList[index].coverPhoto}',
                            height: 90, width: 200, fit: BoxFit.cover,
                          ),
                        ),
                        DiscountTag(
                          discount: _restaurantList[index].discount != null
                              ? _restaurantList[index].discount.discount : 0,
                          discountType: 'percent', freeDelivery: _restaurantList[index].freeDelivery,
                        ),
                        _isAvailable ? SizedBox() : NotAvailableWidget(isRestaurant: true),
                        Positioned(
                          top: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          child: GetBuilder<WishListController>(builder: (wishController) {
                            bool _isWished = wishController.wishRestIdList.contains(_restaurantList[index].id);
                            return InkWell(
                              onTap: () {
                                if(Get.find<AuthController>().isLoggedIn()) {
                                  _isWished ? wishController.removeFromWishList(_restaurantList[index].id, true)
                                      : wishController.addToWishList(null, _restaurantList[index], true);
                                }else {
                                  showCustomSnackBar('you_are_not_logged_in'.tr);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                ),
                                child: Icon(
                                  _isWished ? Icons.favorite : Icons.favorite_border,  size: 15,
                                  color: _isWished ?Color(0xFF009f67) : Theme.of(context).disabledColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ]),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              _restaurantList[index].name,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),

                            Text(
                              _restaurantList[index].address,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),

                            RatingBar(
                              rating: _restaurantList[index].avgRating,
                              ratingCount: _restaurantList[index].ratingCount,
                              size: 12,
                            ),
                          ]),
                        ),
                      ),

                    ]),
                  ),
                ),
              );
            },
          ) : PopularRestaurantShimmer(restController: restController),
        ),
      ],
    );
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  final RestaurantController restController;
  PopularRestaurantShimmer({@required this.restController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index){
        return Container(
          height: 150,
          width: 200,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 10, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

