import 'package:ansarbazzarweb/controller/banner_controller.dart';
import 'package:ansarbazzarweb/controller/category_controller.dart';
import 'package:ansarbazzarweb/controller/localization_controller.dart';
import 'package:ansarbazzarweb/controller/product_controller.dart';
import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
import 'package:ansarbazzarweb/data/model/response/category_model.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_colors.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/my_size.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/cart_widget.dart';
import 'package:ansarbazzarweb/view/base/product_view.dart';
import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
import 'package:ansarbazzarweb/view/screens/chat_screen.dart';
import 'package:ansarbazzarweb/view/screens/home/widget/banner_view.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/detail_category_screen.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/product_detail_screen.dart';
import 'package:ansarbazzarweb/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../data/model/response/all_product_model.dart';
import '../../../data/model/response/config_model.dart';
import '../category/category_product_screen.dart';
//1.1 update

class RestaurantScreen extends StatefulWidget {

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  final PageController controller = PageController();
  ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().getAllProductList();
    Get.find<ProductController>().getListenerPaginationCall();

    Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: 1));
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>().getRestaurantProductList(1, 1, false);
    Get.find<ProductController>().getPopularProductList(true, 'all', false);

  }


  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
    controller.dispose();
  }

  // scrollController?.addListener(() {
  //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
  //       Get.find<ProductController>().allproductList != null &&
  //       !Get.find<RestaurantController>().foodPaginate) {
  //       int pageSize =
  //         (Get.find<RestaurantController>().foodPageSize / 10).ceil();
  //     if (Get.find<RestaurantController>().foodOffset < pageSize) {
  //       Get.find<RestaurantController>()
  //           .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
  //       print('end of the page');
  //       Get.find<RestaurantController>().showFoodBottomLoader();
  //       Get.find<RestaurantController>().getRestaurantProductList(
  //         // widget.restaurant.id,
  //         1,
  //         Get.find<RestaurantController>().foodOffset,
  //         false,
  //       );
  //     }
  //   }
  // });
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar:   WebMenuBar(),
      // appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,

      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // await Get.find<BannerController>().getBannerList(true);
          // await Get.find<CategoryController>().getCategoryList(true);
          // await Get.find<RestaurantController>().getPopularRestaurantList(true, 'all', false);
          // await Get.find<CampaignController>().getItemCampaignList(true);
          await Get.find<ProductController>().getPopularProductList(true, 'all', false);
          //   await Get.find<RestaurantController>().getLatestRestaurantList(true, 'all', false);
          //   await Get.find<ProductController>().getReviewedProductList(true, 'all', false);
          // await Get.find<RestaurantController>().getRestaurantList('1', true);
          // if (Get.find<AuthController>().isLoggedIn()) {
          //   await Get.find<UserController>().getUserInfo();
          //   await Get.find<NotificationController>()
          //       .getNotificationList(true);
          // }
        },
        child: GetBuilder<RestaurantController>(builder: (restController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {
            Restaurant _restaurant;
            if (restController.restaurant != null &&
                restController.restaurant.name != null &&
                categoryController.categoryList != null) {
              _restaurant = restController.restaurant;
            }
            restController.setCategoryList();

            return (restController.restaurant != null &&
                restController.restaurant.name != null &&
                categoryController.categoryList != null)
                ? CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              // controller: productController.scrollController,
              slivers: [

                // ResponsiveHelper.isDesktop(context)
                //     ?
                // SliverToBoxAdapter(
                //   child: Container(
                //     color: Color(0xFF171A29),
                //     padding:
                //     EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                //     alignment: Alignment.center,
                //     child: Center(
                //         child: SizedBox(
                //             width: Dimensions.WEB_MAX_WIDTH,
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal:
                //                   Dimensions.PADDING_SIZE_SMALL),
                //               child: Row(children: [
                //
                //                 //   Expanded(
                //                 // child: CustomImage(
                //                 // fit: BoxFit.cover, placeholder: Images.restaurant_cover, height: 220,
                //                 //  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                //                 // ),
                //                 // ),
                //                 // ),
                //                 // SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                //
                //                 Expanded(
                //                     child: RestaurantDescriptionView(
                //                         restaurant: _restaurant)),
                //               ]),
                //             ))),
                //   ),
                // )
                //     : SliverAppBar(
                //   expandedHeight: 50,
                //   toolbarHeight: 50,
                //   pinned: true,
                //   floating: false,
                //   backgroundColor: AppColors.primarycolor,
                //   leading: Container(
                //     color: AppColors.primarycolor,
                //     height: 50,
                //     width: 100,
                //     child: Row(
                //       children: [
                //         SizedBox(
                //           width: 10,
                //         ),
                //
                //       ],
                //     ),
                //   ),
                //
                //
                //
                //   actions: [
                //     GestureDetector(
                //         onTap: () {
                //           Get.toNamed(
                //               RouteHelper.getNotificationRoute());
                //         },
                //         child: Icon(Icons.notifications,
                //             color: Colors.white)),
                //     IconButton(
                //       onPressed: () =>
                //           Get.toNamed(RouteHelper.getCartRoute()),
                //       icon: Container(
                //         height: 50,
                //         width: 50,
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Color(0xFF009f67)),
                //         alignment: Alignment.center,
                //         child: CartWidget(
                //             color: Theme.of(context).cardColor,
                //             size: 15,
                //             fromRestaurant: true),
                //       ),
                //     ),
                //     GestureDetector(
                //         onTap: (){
                //           Get.to(()=> ChatScreen2());
                //         },
                //         child: Icon(Icons.message)),
                //     SizedBox(
                //       width: 12,
                //     ),
                //   ],
                // ),

                SliverToBoxAdapter(
                    child: Center(
                        child: Container(
                          width: Dimensions.WEB_MAX_WIDTH,
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          color: Colors.white,
                          child: Column(children: [

                            // GetBuilder<BannerController>(
                            //     builder: (bannerController) {
                            //       return bannerController.bannerImageList == null
                            //           ? BannerView(bannerController: bannerController)
                            //           : bannerController.bannerImageList.length == 0
                            //           ? SizedBox()
                            //           : BannerView(
                            //           bannerController: bannerController);
                            //     }),
                            // ResponsiveHelper.isDesktop(context)
                            //     ? SizedBox()
                            //     : RestaurantDescriptionView(
                            //     restaurant: _restaurant),

                            // GetBuilder<ProductController>(builder: (product) {
                            //   return SizedBox(
                            //     height: 45,
                            //     width: 368,
                            //     child: TextField(
                            //       controller: _controller,
                            //       style: TextStyle(color: Colors.black),
                            //       decoration: InputDecoration(
                            //           enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide.none,
                            //               borderRadius: BorderRadius.circular(28)),
                            //           suffixIcon: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: SvgPicture.asset(
                            //               "assets/image/searchicon.svg",
                            //             ),
                            //           ),
                            //           fillColor:
                            //           Color(0xff3734910F).withOpacity(0.06),
                            //           filled: true,
                            //           border: OutlineInputBorder(
                            //               borderSide: BorderSide.none,
                            //               borderRadius: BorderRadius.circular(28)),
                            //           hintText: 'Serach  Product ',
                            //           hintStyle: TextStyle(
                            //               color: Colors.grey,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w400)),
                            //       onChanged: (value) {
                            //         setState(() {});
                            //       },
                            //     ),
                            //   );
                            // }),

                            _restaurant.discount != null
                                ? Container(
                              width: context.width,
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  color: Color(0xFF009f67)),
                              padding: EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _restaurant.discount.discountType ==
                                          'percent'
                                          ? '${_restaurant.discount.discount}% OFF'
                                          : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Theme.of(context).cardColor),
                                    ),
                                    Text(
                                      _restaurant.discount.discountType ==
                                          'percent'
                                          ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                          : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                          ' ${'off_on_all_categories'.tr}',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).cardColor),
                                    ),
                                    SizedBox(
                                        height: (_restaurant.discount
                                            .minPurchase !=
                                            0 ||
                                            _restaurant.discount
                                                .maxDiscount !=
                                                0)
                                            ? 5
                                            : 0),
                                    _restaurant.discount.minPurchase != 0
                                        ? Text(
                                      '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .cardColor),
                                    )
                                        : SizedBox(),
                                    _restaurant.discount.maxDiscount != 0
                                        ? Text(
                                      '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .cardColor),
                                    )
                                        : SizedBox(),
                                    Text(
                                      '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
                                          '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context).cardColor),
                                    ),
                                  ]),
                            )
                                : SizedBox(),
                          ]),
                        ))),

                /// category tabs
                /// category tabs


                SliverToBoxAdapter(child: Center(
                  child: GetBuilder<ProductController>(
                    builder: (productcontroller) {
                      List<Product> filteredProducts = productcontroller.allproductList ?? [];
                      filteredProducts = filteredProducts.where((product) => _controller.text.isEmpty || product.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();

                      // Reorder the list to place matching items at the beginning
                      filteredProducts.sort((a, b) {
                        bool containsSearchA = a.name.toLowerCase().contains(_controller.text.toLowerCase());
                        bool containsSearchB = b.name.toLowerCase().contains(_controller.text.toLowerCase());

                        if (containsSearchA && !containsSearchB) {
                          return -1; // Place A before B
                        } else if (!containsSearchA && containsSearchB) {
                          return 1; // Place B before A
                        } else if (containsSearchA && containsSearchB) {
                          return 0; // Maintain the existing order for items that both contain the search text
                        } else {
                          return 0; // Maintain the existing order for items that don't contain the search text
                        }
                      });

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        width: Dimensions.WEB_MAX_WIDTH,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              Image.asset('assets/image/banner.png'),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Categories'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize:
                                      Dimensions.fontSizeLarge + 2,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: MySize.size15,
                              ),
                              Container(
                                // width: Get.width,
                                height:GetPlatform.isAndroid|| GetPlatform.isIOS ? MySize.scaleFactorHeight*200: MediaQuery.of(context).size.height* 0.3,
                                child: ListView.builder(
                                    itemCount: restController.categoryList.length,
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: () {
                                          // print("this is category list ${restController.categoryList[index].name}");
                                          Get.to(
                                                () => CategoryProductScreen(
                                              categoryID: restController.categoryList[index].id.toString(),
                                              categoryName: restController.categoryList[index].name,
                                              deliveryfee: categoryController.categoryList != null && categoryController.categoryList.isNotEmpty && index < categoryController.categoryList.length
                                                  ? [double.tryParse(categoryController.categoryList[index].deliverycharges ?? '50.0')]
                                                  : [50.0],

                                              // deliveryfee: productcontroller.allproductList.isNotEmpty && index < productcontroller.allproductList.length
                                              //     ? [double.parse(categoryController.categoryList[index].deliverycharges)]
                                              //     : [], // Start with an empty list

                                            ),
                                          );
                                          //
                                          //
                                          // CategoryProductScreen(categoryID: restController.categoryList[index].id.toString(),categoryName: restController.categoryList[index].name,));
                                          // restController.setCategoryIndex(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [

                                              Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  // color: Colors.white,
                                                  image: DecorationImage(
                                                      image: NetworkImage("https://ansaarbazar.com/api/storage/app/public/category/${restController.categoryList[index].image}",),fit: BoxFit.fill
                                                  ),

                                                  borderRadius: BorderRadius.circular(10),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       color: Colors.black
                                                  //           .withOpacity(0.25),
                                                  //       spreadRadius: 0,
                                                  //       blurRadius: 23,
                                                  //       offset: Offset(0, 1)),
                                                  // ]
                                                ),
                                                child: Column(
                                                  children: [

                                                    Spacer(),
                                                    Container(
                                                      // color: Colors.blue.withOpacity(0.25),
                                                      // height: 120,
                                                      // color: Colors.red,
                                                      width: Get.width,
                                                      // child: Center(
                                                      //   child: Text(
                                                      //       restController
                                                      //           .categoryList[
                                                      //       index]
                                                      //           .name,
                                                      //       textAlign:
                                                      //       TextAlign.center,
                                                      //       style: robotoMedium
                                                      //           .copyWith(
                                                      //         fontSize: Dimensions.fontSizeExtraLarge,
                                                      //         color: Colors.white,
                                                      //       )),
                                                      // ),

                                                      // child: Column(
                                                      //   children: [
                                                      //     SizedBox(
                                                      //       height: 17,
                                                      //     ),
                                                      //     // Image.asset("assets/image/img_5.png",height: 85,width: 88,),
                                                      //     Expanded(
                                                      //       child: Container(
                                                      //         decoration: BoxDecoration(
                                                      //           borderRadius: BorderRadius.circular(10),
                                                      //
                                                      //         ),
                                                      //         //   height: 88,
                                                      //         //   width: 88,
                                                      //         //   decoration: BoxDecoration(
                                                      //         //       borderRadius:
                                                      //         //           BorderRadius
                                                      //         //               .circular(
                                                      //         //                   10)),
                                                      //         //   child: ClipRRect(
                                                      //         //       borderRadius:
                                                      //         //           BorderRadius
                                                      //         //               .circular(
                                                      //         //                   10),
                                                      //         //       child: Image
                                                      //         //           .network(
                                                      //         //         // "https://s3bits.com/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                                                      //         //         // "http://23.108.96.28/~s3bitsdev/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                                                      //         //         "https://ansaarbazar.com/api/storage/app/public/category/${restController.categoryList[index].image}",
                                                      //         //         height: 85,
                                                      //         //         width: 88,
                                                      //         //         fit: BoxFit
                                                      //         //             .fill,
                                                      //         //       ))
                                                      //         child:
                                                      //       ),
                                                      //     )
                                                      //   ],
                                                      // ),
                                                    ),
                                                    SizedBox(height: 10,),

                                                  ],
                                                ),
                                              ),



                                              Container(
                                                decoration: BoxDecoration(

                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.15),
                                                          Colors.black.withOpacity(0.25),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                right: 0,
                                                left:0,
                                                child: Center(
                                                  child: Text(
                                                      restController
                                                          .categoryList[
                                                      index]
                                                          .name,
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: robotoMedium
                                                          .copyWith(
                                                        fontSize: Dimensions.fontSizeExtraLarge,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                              // Container(
                              //   width: Get.width,
                              //   height:GetPlatform.isAndroid||GetPlatform.isIOS? MySize.scaleFactorHeight *210:MediaQuery.of(context).size.height* 0.5,
                              //   child: ListView.builder(
                              //       itemCount: restController.categoryList.length,
                              //       scrollDirection: Axis.horizontal,
                              //       physics: AlwaysScrollableScrollPhysics(),
                              //       itemBuilder: (context,index){
                              //         return Padding(
                              //           padding: const EdgeInsets.all(4.0),
                              //           child: GestureDetector(
                              //             onTap: () {
                              //               if(kDebugMode){
                              //
                              //                 print(
                              //                     "this is category list ${restController.categoryList[index].name}");
                              //               }
                              //               Get.to(() =>
                              //                   CategoryProductScreen(
                              //                     categoryID: restController.categoryList[index].id.toString(),
                              //                     categoryName: restController.categoryList[index].name,
                              //                     deliveryfee: categoryController.categoryList != null && categoryController.categoryList.isNotEmpty && index < categoryController.categoryList.length
                              //                         ? [double.tryParse(categoryController.categoryList[index].deliverycharges ?? '50.0')]
                              //                         : [50.0],
                              //
                              //                     // deliveryfee: productcontroller.allproductList.isNotEmpty && index < productcontroller.allproductList.length
                              //                     //     ? [double.parse(categoryController.categoryList[index].deliverycharges)]
                              //                     //     : [], // Start with an empty list
                              //
                              //                   ),);
                              //
                              //               restController.setCategoryIndex(index);
                              //
                              //             },
                              //             child: Container(
                              //               padding: EdgeInsets.all(10),
                              //               width: GetPlatform.isAndroid || GetPlatform.isIOS? MySize.scaleFactorWidth*160:MySize.scaleFactorWidth*140,
                              //               decoration: BoxDecoration(
                              //                   color: Color(0xFF009f67),
                              //                   borderRadius:
                              //                   BorderRadius.circular(6),
                              //                   boxShadow: [
                              //                     BoxShadow(
                              //                         color: Colors.black
                              //                             .withOpacity(0.10),
                              //                         spreadRadius: 0,
                              //                         blurRadius: 23,
                              //                         offset: Offset(0, 1)),
                              //                   ]),
                              //               child: Column(
                              //                 children: [
                              //                   Container(
                              //                     height: MySize.scaleFactorHeight*120,
                              //                     // color: Colors.red,
                              //                     width: Get.width,
                              //                     child: Column(
                              //                       children: [
                              //                         SizedBox(
                              //                           height: MySize.scaleFactorHeight*17,
                              //                         ),
                              //                         // Image.asset("assets/image/img_5.png",height: 85,width: 88,),
                              //                         Container(
                              //                             height: GetPlatform.isAndroid || GetPlatform.isIOS? MySize.scaleFactorWidth*100:MySize.scaleFactorWidth*88,
                              //                             width: GetPlatform.isAndroid || GetPlatform.isIOS? MySize.scaleFactorWidth*100:MySize.scaleFactorWidth*88,
                              //                             decoration: BoxDecoration(
                              //                                 borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(
                              //                                     10)),
                              //                             child: ClipRRect(
                              //                                 borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(
                              //                                     10),
                              //                                 child: Image
                              //                                     .network(
                              //                                   // "https://s3bits.com/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                              //                                   // "http://23.108.96.28/~s3bitsdev/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                              //                                   "https://ansaarbazar.com/api/storage/app/public/category/${restController.categoryList[index].image}",
                              //                                   height: GetPlatform.isAndroid || GetPlatform.isIOS? MySize.scaleFactorWidth*100:MySize.scaleFactorWidth*88,
                              //                                   width: GetPlatform.isAndroid || GetPlatform.isIOS? MySize.scaleFactorWidth*100:MySize.scaleFactorWidth*85,
                              //                                   fit: BoxFit
                              //                                       .fill,
                              //                                 )))
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   // SizedBox(height: MySize.size15,),
                              //                   Text(
                              //                       restController
                              //                           .categoryList[index]
                              //                           .name,
                              //                       textAlign:
                              //                       TextAlign.center,
                              //                       style: robotoMedium
                              //                           .copyWith(
                              //                         fontSize: Dimensions
                              //                             .fontSizeDefault,
                              //                         color: Colors.white,
                              //                       )),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         );
                              //       }),
                              // )

                              // Container(
                              //
                              //   height: MediaQuery.of(context).size.height*0.9,
                              //   child: GridView.builder(
                              //       itemCount:
                              //       restController.categoryList.length,
                              //       scrollDirection: Axis.horizontal,
                              //       padding: EdgeInsets.zero,
                              //
                              //       physics: NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       gridDelegate:
                              //       SliverGridDelegateWithFixedCrossAxisCount(
                              //         childAspectRatio: 8 / 7,
                              //         crossAxisCount: 3,
                              //         crossAxisSpacing: 8,
                              //         mainAxisExtent: 160,
                              //         mainAxisSpacing: 6,
                              //       ),
                              //       itemBuilder: (context, index) {
                              //         return
                              //       }),
                              // ),


                              ///under tabs products
                              ///under tabs products



                              ,SizedBox(
                                height: MySize.size20,
                              ),
                              Text('Recomended Products',
                                  style: robotoMedium.copyWith(
                                      fontSize:
                                      Dimensions.fontSizeLarge + 2,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: MySize.size15,
                              ),

                              ///
                              // productcontroller.allproductList == null ||
                              //     productcontroller.isLoading
                              //     ? Center(
                              //     child: CircularProgressIndicator())
                              //     : productcontroller
                              //     .allproductList.length >
                              //     0
                              //     ? _controller.text
                              //     .toString()
                              //     .isEmpty
                              //     ?

                              Container(
                                height: MySize.scaleFactorWidth*200,
                                // color: Colors.red,
                                width: Get.width,
                                child: GridView.builder(
                                  // itemCount: getUserNotificationData.isLoadingMore
                                  //     ? data!.length + 1
                                  //     : data!.length,
                                  itemCount: productcontroller.isLoadingMore? productController.allproductList.length+1
                                      :
                                  productController.allproductList.length,
                                  scrollDirection:
                                  Axis.vertical,
                                  padding: EdgeInsets.zero,
                                  controller: productController.scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 8 / 7,
                                    crossAxisCount: GetPlatform.isAndroid ||  GetPlatform.isIOS? 2 :4,
                                    crossAxisSpacing: 14,
                                    mainAxisExtent: 230,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder:
                                      (context, index) {
                                    // print("All products length ${productcontroller.allproductList.length}");
                                    if(index < productController.allproductList.length){
                                      // print("product Delivery fee is  ${productcontroller.allproductList[index].delivery_price}");
                                      return

                                        Stack(
                                          children: [
                                            Container(
                                              width: Get.width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 2),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              // height: 202,
                                              // width: 163,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),

                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.black
                                                //         .withOpacity(0.24),
                                                //     spreadRadius: 0,
                                                //     blurRadius: 23,
                                                //     offset: Offset(0, 1),
                                                //   ),
                                                //
                                                // ],

                                                image: DecorationImage(
                                                    image: NetworkImage("https://ansaarbazar.com/api/storage/app/public/product/${productcontroller.allproductList[index].image}",),
                                                    fit: BoxFit.fill
                                                ),

                                                // Container(
                                                //   height: 120,
                                                //   width:
                                                //   double.infinity,
                                                //   decoration:
                                                //   BoxDecoration(
                                                //     borderRadius:
                                                //     BorderRadius
                                                //         .circular(
                                                //         10),
                                                //   ),
                                                //   child: ClipRRect(
                                                //     borderRadius:
                                                //     BorderRadius
                                                //         .circular(
                                                //         4),
                                                //     child: CustomImage(
                                                //       height: 120,
                                                //       width: 120,
                                                //       fit: BoxFit.fill,
                                                //
                                                //       // placeholder: "assets/image/placeholderiages.png",
                                                //       image:
                                                //       "https://ansaarbazar.com/api/storage/app/public/product/${productcontroller.allproductList[index].image}",
                                                //     ),
                                                //   ),
                                                // ),

                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Spacer(),
                                                  SizedBox(
                                                    height: 8,
                                                  ),


                                                  // Stack(
                                                  //   clipBehavior: Clip.none,
                                                  //   children: [
                                                  //     Container(
                                                  //       height: 120,
                                                  //       width:
                                                  //       double.infinity,
                                                  //       decoration:
                                                  //       BoxDecoration(
                                                  //         borderRadius:
                                                  //         BorderRadius
                                                  //             .circular(
                                                  //             10),
                                                  //       ),
                                                  //       child: ClipRRect(
                                                  //         borderRadius:
                                                  //         BorderRadius
                                                  //             .circular(
                                                  //             4),
                                                  //         child: CustomImage(
                                                  //           height: 120,
                                                  //           width: 120,
                                                  //           fit: BoxFit.fill,
                                                  //
                                                  //           // placeholder: "assets/image/placeholderiages.png",
                                                  //           image:
                                                  //           "https://ansaarbazar.com/api/storage/app/public/product/${productcontroller.allproductList[index].image}",
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //

                                                  //     DiscountTag(
                                                  //         discount: productcontroller.allproductList[index].discount,
                                                  //         discountType: productcontroller.allproductList[index].discountType,
                                                  //         freeDelivery: false
                                                  //     ),
                                                  //   ],
                                                  // ),

                                                  // SizedBox(
                                                  //   height: 8,
                                                  // ),



                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                // color: Colors.white,
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.white.withOpacity(0.25),
                                                      Colors.black.withOpacity(0.25),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() =>
                                                    ProductDetailScreen(
                                                        deliveryCharges: [
                                                          double.parse(productcontroller.allproductList[index].delivery_price)
                                                        ],
                                                        // deliveryCharges: [double.parse(productcontroller.allproductList[index].delivery_price)],
                                                        product:
                                                        productcontroller
                                                            .allproductList[
                                                        index],
                                                        inRestaurantPage:
                                                        true,
                                                        isCampaign:
                                                        false));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration:
                                                    BoxDecoration(
                                                      shape: BoxShape
                                                          .circle,
                                                      color: AppColors
                                                          .primarycolor,
                                                      // color: Color(0xff189084),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                      Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Positioned(
                                              bottom: 10,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          productcontroller
                                                              .allproductList[index]
                                                              .name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "${productcontroller.allproductList[index].unit} , RS: ${productcontroller.allproductList[index].price.toString()}",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            // color: Color(0xff373491),
                                                            color: Colors.white,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),


                                                  // SizedBox(width: 8,),
                                                ],
                                              ),
                                            )

                                          ],
                                        );


                                    }else{
                                      Center(child: CircularProgressIndicator(color: Colors.blue,));
                                    }
                                  },
                                ),
                              ),
                              //     : GridView.builder(
                              //   itemCount:
                              //   filteredProducts.length,
                              //   scrollDirection:
                              //   Axis.vertical,
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   physics:
                              //   NeverScrollableScrollPhysics(),
                              //   shrinkWrap: true,
                              //   gridDelegate:
                              //   SliverGridDelegateWithFixedCrossAxisCount(
                              //     childAspectRatio: 8 / 7,
                              //     crossAxisCount: 5,
                              //     crossAxisSpacing: 14,
                              //     mainAxisExtent: 210,
                              //     mainAxisSpacing: 10,
                              //   ),
                              //   itemBuilder:
                              //       (context, index) {
                              //     if(kDebugMode){
                              //       print(
                              //           "Filtered products are ${filteredProducts.length}");
                              //     }
                              //
                              //     return GestureDetector(
                              //       onTap: () {
                              //         Get.dialog(
                              //           Dialog(
                              //             child:
                              //             ProductDetailScreen(
                              //               deliveryCharges: [double.parse(filteredProducts[index].delivery_price)],
                              //               product:
                              //               filteredProducts[
                              //               index],
                              //               inRestaurantPage:
                              //               true,
                              //               isCampaign:
                              //               false,
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //       child: Container(
                              //         padding: EdgeInsets.symmetric(horizontal: 16),
                              //         height: 202,
                              //         width: 163,
                              //         decoration:
                              //         BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //           BorderRadius
                              //               .circular(
                              //               6),
                              //           boxShadow: [
                              //             BoxShadow(
                              //               color: Colors
                              //                   .black
                              //                   .withOpacity(
                              //                   0.24),
                              //               spreadRadius: 0,
                              //               blurRadius: 23,
                              //               offset: Offset(
                              //                   0, 1),
                              //             ),
                              //           ],
                              //         ),
                              //         child: Column(
                              //           crossAxisAlignment:
                              //           CrossAxisAlignment
                              //               .start,
                              //           children: [
                              //             SizedBox(
                              //               height: 8,
                              //             ),
                              //             Container(
                              //               height: 98,
                              //               width: 112,
                              //               decoration:
                              //               BoxDecoration(
                              //                 borderRadius: BorderRadius.circular(10),
                              //                 image:
                              //                 DecorationImage(
                              //                   image:
                              //                   NetworkImage(
                              //                     "https://ansaarbazar.com/storage/app/public/product/${filteredProducts[index].image}",
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             SizedBox(
                              //               height: 8,
                              //             ),
                              //             Text(
                              //               filteredProducts[
                              //               index]
                              //                   .name,
                              //               style:
                              //               TextStyle(
                              //                 fontSize: 14,
                              //                 overflow:
                              //                 TextOverflow
                              //                     .ellipsis,
                              //                 fontWeight:
                              //                 FontWeight
                              //                     .w500,
                              //                 color: Colors
                              //                     .white,
                              //               ),
                              //             ),
                              //             SizedBox(
                              //               height: 4,
                              //             ),
                              //             Text(
                              //               filteredProducts[
                              //               index]
                              //                   .price
                              //                   .toString(),
                              //               style:
                              //               TextStyle(
                              //                 overflow:
                              //                 TextOverflow
                              //                     .ellipsis,
                              //                 fontSize: 13,
                              //                 fontWeight:
                              //                 FontWeight
                              //                     .w600,
                              //                 color: Colors.white,
                              //                 // color: Color(0xff373491),
                              //               ),
                              //             ),
                              //             Row(
                              //               mainAxisAlignment:
                              //               MainAxisAlignment
                              //                   .end,
                              //               children: [
                              //                 Container(
                              //                   height: 36,
                              //                   width: 36,
                              //                   decoration:
                              //                   BoxDecoration(
                              //                     shape: BoxShape
                              //                         .circle,
                              //                     color: Colors.white,
                              //                     // color: Color(0xff189084),
                              //                   ),
                              //                   child: Icon(
                              //                     Icons.add,
                              //                     color: Colors
                              //                         .black,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // )
                              //     : SizedBox(),






                              SizedBox(
                                height: 40,
                              )
                            ]),
                      );

                      ///
                    },
                  ),
                ))
              ],
            )
                : Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }

// Widget buildItem() {
//   return Stack(
//     clipBehavior: Clip.none,
//     children: [
//       Container(
//
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.only(left: 25,),
//         height: 147,
//         width: 335,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.25),
//               blurRadius: 24,
//               spreadRadius: 4,
//               offset: Offset(4, 4),
//             )
//           ],
//           image: DecorationImage(
//             image: AssetImage("assets/image/banner.png"),
//             fit: BoxFit.fill,
//           ),
//           borderRadius: BorderRadius.circular(15),
//           color: AppColors.primarycolor,
//         ),
//       ),
//     ],
//   );
// }

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

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}
