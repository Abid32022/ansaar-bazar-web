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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../util/app_colors.dart';

class WebPopularFoodView extends StatelessWidget {
  final bool isPopular;
  final ProductController productController;
  WebPopularFoodView({@required this.productController, @required this.isPopular});

  @override
  Widget build(BuildContext context) {
    List<Product> _foodList = isPopular ? productController.popularProductList : productController.reviewedProductList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr, style: robotoMedium.copyWith(fontSize: 24)),
        ),

        _foodList != null ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: (1/0.35),
            crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          itemCount: _foodList.length > 5 ? 6 : _foodList.length,
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

            if(index == 5) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color:AppColors.primarycolor
                    ,borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+${_foodList.length-5}\n${'more'.tr}', textAlign: TextAlign.center,
                    style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                  ),
                ),
              );
            }

            return InkWell(
              onTap: () {
                ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                  ProductBottomSheet(product: _foodList[index], isCampaign: false),
                  backgroundColor: Colors.transparent, isScrollControlled: true,
                ) : Get.dialog(
                  Dialog(child: ProductBottomSheet(product: _foodList[index], isCampaign: false)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Row(children: [

                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                            '/${_foodList[index].image}',
                        height: 90, width: 90, fit: BoxFit.cover,
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
                          rating: _foodList[index].avgRating, size: 15,
                          ratingCount: _foodList[index].ratingCount,
                        ),

                        Row(
                          children: [
                            Text(
                              PriceConverter.convertPrice(
                                _foodList[index].price, asFixed: 1, discount: _foodList[index].discount, discountType: _foodList[index].discountType,
                              ),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                            SizedBox(width: _foodList[index].discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                            _foodList[index].discount > 0 ? Expanded(child: Text(
                              PriceConverter.convertPrice(_startingPrice, asFixed: 1),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )) : Expanded(child: SizedBox()),
                            Icon(Icons.add, size: 25),
                          ],
                        ),
                      ]),
                    ),
                  ),

                ]),
              ),
            );
          },
        ) : WebCampaignShimmer(enabled: _foodList == null),
      ],
    );
  }
}

class WebCampaignShimmer extends StatelessWidget {
  final bool enabled;
  WebCampaignShimmer({@required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: (1/0.35),
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      itemCount: 6,
      itemBuilder: (context, index){
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: enabled,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 90,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.grey[300]),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                    SizedBox(height: 5),

                    Container(height: 10, width: 30, color: Colors.grey[300]),
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

