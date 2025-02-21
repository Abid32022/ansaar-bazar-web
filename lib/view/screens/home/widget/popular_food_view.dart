import 'package:ansarbazzarweb/controller/product_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/theme_controller.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/discount_tag.dart';
import 'package:ansarbazzarweb/view/base/not_available_widget.dart';
import 'package:ansarbazzarweb/view/base/product_bottom_sheet.dart';
import 'package:ansarbazzarweb/view/base/rating_bar.dart';
import 'package:ansarbazzarweb/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularFoodView extends StatelessWidget {
  final bool isPopular;
  final ProductController productController;
  PopularFoodView({@required this.productController, @required this.isPopular});

  @override
  Widget build(BuildContext context) {
    List<Product> _foodList = isPopular ? productController.popularProductList : productController.reviewedProductList;
    ScrollController _scrollController = ScrollController();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: TitleWidget(
            title: isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr,
            onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
          ),
        ),

        SizedBox(
          height: 90,
          child: _foodList != null ? ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
            itemCount: _foodList.length > 10 ? 10 : _foodList.length,
            itemBuilder: (context, index){
              double _startingPrice;
              if (_foodList[index].choiceOptions.length != 0) {
                List<double> _priceList = [];
                _foodList[index].variations.forEach((variation) => _priceList.add(variation.price));
                _priceList.sort((a, b) => a.compareTo(b));
                _startingPrice = _priceList[0];
              } else {
                _startingPrice = _foodList[index].price;
              }
              bool _isAvailable = DateConverter.isAvailable(
                _foodList[index].availableTimeStarts,
                _foodList[index].availableTimeEnds,
              ) && DateConverter.isAvailable(
                _foodList[index].restaurantOpeningTime,
                _foodList[index].restaurantClosingTime,
              );

              return Padding(
                padding: EdgeInsets.fromLTRB(2, 2, Dimensions.PADDING_SIZE_SMALL, 2),
                child: InkWell(
                  onTap: () {
                    ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                      ProductBottomSheet(product: _foodList[index], isCampaign: false),
                      backgroundColor: Colors.transparent, isScrollControlled: true,
                    ) : Get.dialog(
                      Dialog(child: ProductBottomSheet(product: _foodList[index])),
                    );
                  },
                  child: Container(
                    height: 90, width: 250,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(
                        color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                        blurRadius: 5, spreadRadius: 1,
                      )],
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                '/${_foodList[index].image}',
                            height: 80, width: 70, fit: BoxFit.cover,
                          ),
                        ),
                        DiscountTag(
                          discount: _foodList[index].discount,
                          discountType: _foodList[index].discountType,
                        ),
                        _isAvailable ? SizedBox() : NotAvailableWidget(),
                      ]),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              _foodList[index].name,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Text(
                              _foodList[index].restaurantName,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),

                            RatingBar(
                              rating: _foodList[index].avgRating, size: 12,
                              ratingCount: _foodList[index].ratingCount,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(
                                      PriceConverter.convertPrice(
                                        _startingPrice, asFixed: 1, discount: _foodList[index].discount,
                                        discountType: _foodList[index].discountType,
                                      ),
                                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                    SizedBox(width: _foodList[index].discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                                    _foodList[index].discount > 0 ? Flexible(child: Text(
                                      PriceConverter.convertPrice(_startingPrice, asFixed: 1),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )) : SizedBox(),
                                  ]),
                                ),
                                Icon(Icons.add, size: 20),
                              ],
                            ),
                          ]),
                        ),
                      ),

                    ]),
                  ),
                ),
              );
            },
          ) : PopularFoodShimmer(enabled: _foodList == null),
        ),
      ],
    );
  }
}

class PopularFoodShimmer extends StatelessWidget {
  final bool enabled;
  PopularFoodShimmer({@required this.enabled});

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
          height: 80, width: 200,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)],
          ),
          child: Shimmer(
            duration: Duration(seconds: 1),
            interval: Duration(seconds: 1),
            enabled: enabled,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 10, width: 30, color: Colors.grey[300]),
                      RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                    ]),
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

