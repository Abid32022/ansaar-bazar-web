import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/view/base/no_data_screen.dart';
import 'package:ansarbazzarweb/view/base/product_shimmer.dart';
import 'package:ansarbazzarweb/view/base/product_widget.dart';
import 'package:ansarbazzarweb/view/base/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;

  // final String deliveryCharges;
  // final dynamic deliveryfee ;
  final Function(String type) onVegFilterTap;
  ProductView(
      {@required this.restaurants,
        @required this.products,
        @required this.isRestaurant,
        // @required this.deliveryfee,
        this.isScrollable = false,
        this.shimmerLength = 0,
        this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        this.noDataText,
        this.isCampaign = false,
        this.inRestaurantPage = false,
        this.type,
        this.onVegFilterTap});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isRestaurant) {
      _isNull = restaurants == null;
      if (!_isNull) {
        _length = restaurants.length;
      }
    } else {
      _isNull = products == null;
      if (!_isNull) {
        _length = products.length;
      }
    }

    return Container(
      width: Get.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            type != null

                ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
                : SizedBox(),

            _length > 0
                ? GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.PADDING_SIZE_LARGE
                    : 10,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? 4
                    : isRestaurant
                    ? 4
                    : 0.56,
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? isRestaurant
                    ? 1
                    : 2
                    : 2,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),

              shrinkWrap: isScrollable ? false : true,
              itemCount: _length,
              padding: padding,
              itemBuilder: (context, index) {
                return isRestaurant
                    ? ProductWidget(
                  deliveryCharges:  products[index].delivery_price,
                  isRestaurant: isRestaurant,
                  product: isRestaurant ? null : products[index],
                  restaurant: isRestaurant ? restaurants[index] : null,
                  index: index,
                  length: _length,
                  isCampaign: isCampaign,
                  inRestaurant: inRestaurantPage,
                )
                    : Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.24),
                            spreadRadius: 0,
                            blurRadius: 23,
                            offset: Offset(0,1)
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ProductWidget(
                    deliveryCharges: [double.parse(products[index].delivery_price)],
                    isRestaurant: isRestaurant,
                    product: isRestaurant ? null : products[index],
                    restaurant: isRestaurant ? restaurants[index] : null,
                    index: index,
                    length: _length,
                    isCampaign: isCampaign,
                    inRestaurant: inRestaurantPage,
                  ),
                );
              },
            )

            ///No Data Found

                : !_isNull

                ?  GridView.builder(

              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.PADDING_SIZE_LARGE
                    : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,

              padding: padding,
              itemBuilder: (context, index) {
                return ProductShimmer(
                    isEnabled: _isNull,
                    isRestaurant: isRestaurant,
                    hasDivider: index != shimmerLength - 1);
              },
            )
                :
            ///circular indicator
            Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                )),

            // NoDataScreen(
            //   text: noDataText != null
            //       ? noDataText
            //       : isRestaurant
            //           ? 'no_restaurant_available'.tr
            //           : 'no_food_available'.tr,
            // ),



          ]
      ),
    );
  }
}
