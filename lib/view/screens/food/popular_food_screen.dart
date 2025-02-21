import 'package:ansarbazzarweb/controller/product_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:ansarbazzarweb/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodScreen extends StatelessWidget {
  final bool isPopular;
  PopularFoodScreen({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    if(isPopular) {
      Get.find<ProductController>().getPopularProductList(true, Get.find<ProductController>().popularType, false);
    }else {
      Get.find<ProductController>().getReviewedProductList(true, Get.find<ProductController>().reviewType, false);
    }

    return Scaffold(
      appBar: CustomAppBar(title: isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr, showCart: true),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<ProductController>(builder: (productController) {
          return ProductView(
            isRestaurant: false, restaurants: null, type: isPopular ? productController.popularType : productController.reviewType,
            products: isPopular ? productController.popularProductList : productController.reviewedProductList,
            onVegFilterTap: (String type) {
              if(isPopular) {
                productController.getPopularProductList(true, type, true);
              }else {
                productController.getReviewedProductList(true, type, true);
              }
            },
          );
        }),
      )))),
    );
  }
}
