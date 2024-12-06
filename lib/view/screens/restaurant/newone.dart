// import 'package:ansarbazzarweb/controller/banner_controller.dart';
// import 'package:ansarbazzarweb/controller/category_controller.dart';
// import 'package:ansarbazzarweb/controller/localization_controller.dart';
// import 'package:ansarbazzarweb/controller/product_controller.dart';
// import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
// import 'package:ansarbazzarweb/data/model/response/category_model.dart';
// import 'package:ansarbazzarweb/data/model/response/product_model.dart';
// import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
// import 'package:ansarbazzarweb/helper/date_converter.dart';
// import 'package:ansarbazzarweb/helper/price_converter.dart';
// import 'package:ansarbazzarweb/helper/responsive_helper.dart';
// import 'package:ansarbazzarweb/helper/route_helper.dart';
// import 'package:ansarbazzarweb/util/app_colors.dart';
// import 'package:ansarbazzarweb/util/dimensions.dart';
// import 'package:ansarbazzarweb/util/styles.dart';
// import 'package:ansarbazzarweb/view/base/cart_widget.dart';
// import 'package:ansarbazzarweb/view/base/product_view.dart';
// import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
// import 'package:ansarbazzarweb/view/screens/home/widget/banner_view.dart';
// import 'package:ansarbazzarweb/view/screens/restaurant/detail_category_screen.dart';
// import 'package:ansarbazzarweb/view/screens/restaurant/product_detail_screen.dart';
// import 'package:ansarbazzarweb/view/screens/restaurant/widget/restaurant_description_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
//
// import '../../../data/model/response/all_product_model.dart';
// import '../category/category_product_screen.dart';
//
// class RestaurantScreen extends StatefulWidget {
//   final Restaurant restaurant;
//
//   RestaurantScreen({@required this.restaurant});
//
//   @override
//   State<RestaurantScreen> createState() => _RestaurantScreenState();
// }
//
// class _RestaurantScreenState extends State<RestaurantScreen> {
//   final ScrollController scrollController = ScrollController();
//   final bool _ltr = Get.find<LocalizationController>().isLtr;
//   final PageController controller = PageController();
//
//   final List<Map<String, dynamic>> items = [
//     {
//       'image': "assets/image/img_1.png",
//       'discount': "50",
//       'offerText': "Order any item and get a discount",
//     },
//     // Add more items as needed
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     Get.find<ProductController>().getAllProductList();
//
//     // Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: 1));
//
//     if (Get.find<CategoryController>().categoryList == null) {
//       Get.find<CategoryController>().getCategoryList(true);
//     }
//
//     Get.find<RestaurantController>().getRestaurantProductList(1, 1, false);
//
//     // Get.find<ProductController>().getPopularProductList(true, 'all', false);
//
//     // scrollController?.addListener(() {
//     //   if (scrollController.position.pixels ==
//     //           scrollController.position.maxScrollExtent &&
//     //       Get.find<RestaurantController>().restaurantProducts != null &&
//     //       !Get.find<RestaurantController>().foodPaginate) {
//     //     int pageSize =
//     //         (Get.find<RestaurantController>().foodPageSize / 10).ceil();
//     //     if (Get.find<RestaurantController>().foodOffset < pageSize) {
//     //       Get.find<RestaurantController>()
//     //           .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
//     //       print('end of the page');
//     //       Get.find<RestaurantController>().showFoodBottomLoader();
//     //       Get.find<RestaurantController>().getRestaurantProductList(
//     //         widget.restaurant.id,
//     //         Get.find<RestaurantController>().foodOffset,
//     //         false,
//     //       );
//     //     }
//     //   }
//     // });
//
//
//   }
//
//   TextEditingController _controller = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     scrollController?.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
//       backgroundColor: Colors.white,
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // await Get.find<BannerController>().getBannerList(true);
//           // await Get.find<CategoryController>().getCategoryList(true);
//           //  await Get.find<RestaurantController>().getPopularRestaurantList(true, 'all', false);
//           //   await Get.find<CampaignController>().getItemCampaignList(true);
//           await Get.find<ProductController>().getPopularProductList(true, 'all', false);
//           //   await Get.find<RestaurantController>().getLatestRestaurantList(true, 'all', false);
//           //   await Get.find<ProductController>().getReviewedProductList(true, 'all', false);
//           // await Get.find<RestaurantController>().getRestaurantList('1', true);
//           // if (Get.find<AuthController>().isLoggedIn()) {
//           //   await Get.find<UserController>().getUserInfo();
//           //   await Get.find<NotificationController>()
//           //       .getNotificationList(true);
//           // }
//         },
//         child: GetBuilder<RestaurantController>(builder: (restController) {
//           return GetBuilder<CategoryController>(builder: (categoryController) {
//             Restaurant _restaurant;
//             if (restController.restaurant != null && restController.restaurant.name != null && categoryController.categoryList != null) {_restaurant = restController.restaurant;
//             }
//             restController.setCategoryList();
//             return (restController.restaurant != null && restController.restaurant.name != null && categoryController.categoryList != null)
//                 ?
//
//
//
//             CustomScrollView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: scrollController,
//               slivers: [
//                 ResponsiveHelper.isDesktop(context)
//                     ? SliverToBoxAdapter(
//                   child: Container(
//                     color: Color(0xFF171A29),
//                     padding:
//                     EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                     alignment: Alignment.center,
//                     child: Center(
//                         child: SizedBox(
//                             width: Dimensions.WEB_MAX_WIDTH,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal:
//                                   Dimensions.PADDING_SIZE_SMALL),
//                               child: Row(children: [
//                                 //   Expanded(
//
//                                 // child: CustomImage(
//                                 // fit: BoxFit.cover, placeholder: Images.restaurant_cover, height: 220,
//                                 //  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
//                                 // ),
//                                 // ),
//                                 // ),
//                                 // SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
//
//                                 Expanded(
//                                     child: RestaurantDescriptionView(
//                                         restaurant: _restaurant)),
//                               ]),
//                             ))),
//                   ),
//                 )
//                     : SliverAppBar(
//                   expandedHeight: 50,
//                   toolbarHeight: 50,
//                   pinned: true,
//                   floating: false,
//                   backgroundColor: AppColors.primarycolor,
//                   leading: Container(
//                     color: AppColors.primarycolor,
//                     height: 50,
//                     width: 100,
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         // Icon(Icons.arrow_back,color: Colors.white,)
//                         // RichText(text: TextSpan(
//                         //     children: [
//                         //       TextSpan(
//                         //           text: "Hi,",
//                         //           style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400)
//                         //       ),
//                         //       TextSpan(
//                         //           text: "Ali",
//                         //           style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600)
//                         //       ),
//                         //
//                         //     ]
//                         // ))
//                       ],
//                     ),
//                   ),
//
//                   // leading: IconButton(
//                   //   icon: ),
//                   // title: Container(
//                   //   color: Colors.red,
//                   //   height: 50,
//                   //   width: 100,
//                   //   child: Row(
//                   //     children: [
//                   //       RichText(text: TextSpan(
//                   //           children: [
//                   //             TextSpan(
//                   //                 text: "Hi",
//                   //                 style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400)
//                   //             ),
//                   //             TextSpan(
//                   //                 text: "Ali",
//                   //                 style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400)
//                   //             ),
//                   //
//                   //           ]
//                   //       ))
//                   //     ],
//                   //   ),
//                   // ),
//
//                   actions: [
//                     GestureDetector(
//                         onTap: () {
//                           Get.toNamed(
//                               RouteHelper.getNotificationRoute());
//                         },
//                         child: Icon(Icons.notifications,
//                             color: Colors.white)),
//                     IconButton(
//                       onPressed: () =>
//                           Get.toNamed(RouteHelper.getCartRoute()),
//                       icon: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFF009f67)),
//                         alignment: Alignment.center,
//                         child: CartWidget(
//                             color: Theme.of(context).cardColor,
//                             size: 15,
//                             fromRestaurant: true),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 12,
//                     ),
//                   ],
//                 ),
//
//                 SliverToBoxAdapter(
//                     child: Center(
//                         child: Container(
//                           width: Dimensions.WEB_MAX_WIDTH,
//                           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                           color: Colors.white,
//                           child: Column(children: [
//                             // GetBuilder<BannerController>(
//                             //     builder: (bannerController) {
//                             //   return bannerController.bannerImageList == null
//                             //       ? BannerView(bannerController: bannerController)
//                             //       : bannerController.bannerImageList.length == 0
//                             //           ? SizedBox()
//                             //           : BannerView(
//                             //               bannerController: bannerController);
//                             // }),
//                             ResponsiveHelper.isDesktop(context)
//                                 ? SizedBox()
//                                 : RestaurantDescriptionView(
//                                 restaurant: _restaurant),
//                             GetBuilder<ProductController>(builder: (product) {
//                               return SizedBox(
//                                 height: 45,
//                                 width: 368,
//                                 child: TextField(
//                                   controller: _controller,
//                                   style: TextStyle(color: Colors.black),
//                                   decoration: InputDecoration(
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius: BorderRadius.circular(28)),
//                                       suffixIcon: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: SvgPicture.asset(
//                                           "assets/image/searchicon.svg",
//                                         ),
//                                       ),
//                                       fillColor: Color(0xff3734910F).withOpacity(0.06),
//                                       filled: true,
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius: BorderRadius.circular(28)),
//                                       hintText: 'Serach  Product ',
//                                       hintStyle: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400)),
//                                   onChanged: (value) {
//                                     setState(() {});
//                                   },
//                                 ),
//                               );
//                             }),
//                             _restaurant.discount != null
//                                 ? Container(
//                               width: context.width,
//                               margin: EdgeInsets.symmetric(
//                                   vertical: Dimensions.PADDING_SIZE_SMALL),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                       Dimensions.RADIUS_SMALL),
//                                   color: Color(0xFF009f67)),
//                               padding: EdgeInsets.all(
//                                   Dimensions.PADDING_SIZE_SMALL),
//                               child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       _restaurant.discount.discountType ==
//                                           'percent'
//                                           ? '${_restaurant.discount.discount}% OFF'
//                                           : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
//                                       style: robotoMedium.copyWith(
//                                           fontSize: Dimensions.fontSizeLarge,
//                                           color: Theme.of(context).cardColor),
//                                     ),
//                                     Text(
//                                       _restaurant.discount.discountType ==
//                                           'percent'
//                                           ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
//                                           : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
//                                           ' ${'off_on_all_categories'.tr}',
//                                       style: robotoMedium.copyWith(
//                                           fontSize: Dimensions.fontSizeSmall,
//                                           color: Theme.of(context).cardColor),
//                                     ),
//                                     SizedBox(
//                                         height: (_restaurant.discount
//                                             .minPurchase !=
//                                             0 ||
//                                             _restaurant.discount
//                                                 .maxDiscount !=
//                                                 0)
//                                             ? 5
//                                             : 0),
//                                     _restaurant.discount.minPurchase != 0
//                                         ? Text(
//                                       '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
//                                       style: robotoRegular.copyWith(
//                                           fontSize: Dimensions
//                                               .fontSizeExtraSmall,
//                                           color: Theme.of(context)
//                                               .cardColor),
//                                     )
//                                         : SizedBox(),
//                                     _restaurant.discount.maxDiscount != 0
//                                         ? Text(
//                                       '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
//                                       style: robotoRegular.copyWith(
//                                           fontSize: Dimensions
//                                               .fontSizeExtraSmall,
//                                           color: Theme.of(context)
//                                               .cardColor),
//                                     )
//                                         : SizedBox(),
//                                     Text(
//                                       '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
//                                           '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
//                                       style: robotoRegular.copyWith(
//                                           fontSize:
//                                           Dimensions.fontSizeExtraSmall,
//                                           color: Theme.of(context).cardColor),
//                                     ),
//                                   ]),
//                             )
//                                 : SizedBox(),
//                           ]),
//                         ))),
//
//
//                 SliverToBoxAdapter(child: Center(
//                   child: GetBuilder<ProductController>(
//                     builder: (productcontroller) {
//                       List<Product> filteredProducts = productcontroller.allproductList ?? [];
//                       filteredProducts = filteredProducts.where((product) => _controller.text.isEmpty || product.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();
//
//                       // Reorder the list to place matching items at the beginning
//
//                       filteredProducts.sort((a, b) {
//                         bool containsSearchA = a.name.toLowerCase().contains(_controller.text.toLowerCase());
//                         bool containsSearchB = b.name.toLowerCase().contains(_controller.text.toLowerCase());
//
//                         if (containsSearchA && !containsSearchB) {
//                           return -1; // Place A before B
//                         } else if (!containsSearchA && containsSearchB) {
//                           return 1; // Place B before A
//                         } else if (containsSearchA && containsSearchB) {
//                           return 0; // Maintain the existing order for items that both contain the search text
//                         } else {
//                           return 0; // Maintain the existing order for items that don't contain the search text
//                         }
//                       });
//
//                       return Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: Dimensions.PADDING_SIZE_DEFAULT),
//                         width: Dimensions.WEB_MAX_WIDTH,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                         ),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 17,
//                               ),
//                               Container(
//                                   height: 180,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   child: buildItem()),
//
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Text('Categories'.tr,
//                                   style: robotoMedium.copyWith(
//                                       fontSize:
//                                       Dimensions.fontSizeLarge + 2,
//                                       fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 15,
//                               ),
//
//                               GridView.builder(
//                                   itemCount: restController
//                                       .categoryList.length,
//                                   scrollDirection: Axis.vertical,
//                                   padding: EdgeInsets.zero,
//                                   physics:
//                                   NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                     childAspectRatio: 8 / 7,
//                                     crossAxisCount: 3,
//                                     crossAxisSpacing: 8,
//                                     mainAxisExtent: 160,
//                                     mainAxisSpacing: 6,
//                                   ),
//                                   itemBuilder: (context, index) {
//                                     return GestureDetector(
//                                       onTap: () {
//                                         print("this is category list ${restController.categoryList[index].name}");
//                                         Get.to(() => CategoryProductScreen(categoryID: restController.categoryList[index].id.toString(),categoryName: restController.categoryList[index].name,));
//                                         restController.setCategoryIndex(index);
//                                         print("category id is ${ restController.categoryList[index].id}");
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(6),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color: Colors
//                                                       .black
//                                                       .withOpacity(
//                                                       0.10),
//                                                   spreadRadius: 0,
//                                                   blurRadius: 23,
//                                                   offset:
//                                                   Offset(0, 1)),
//                                             ]),
//                                         child: Column(
//                                           children: [
//                                             Container(
//                                               height: 120,
//                                               // color: Colors.red,
//                                               width: Get.width,
//                                               child: Column(
//                                                 children: [
//                                                   SizedBox(
//                                                     height: 17,
//                                                   ),
//                                                   // Image.asset("assets/image/img_5.png",height: 85,width: 88,),
//                                                   Container(
//                                                       height: 88,
//                                                       width: 88,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.circular(
//                                                               10)),
//                                                       child: ClipRRect(
//                                                           borderRadius: BorderRadius.circular(10),
//                                                           child: Image.network(
//                                                             // "https://s3bits.com/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
//                                                             // "http://23.108.96.28/~s3bitsdev/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
//                                                             "https://ansaarbazar.com/storage/app/public/category/${restController.categoryList[index].image}",
//                                                             height:
//                                                             85,
//                                                             width:
//                                                             88,
//                                                             fit: BoxFit
//                                                                 .fill,
//                                                           )))
//                                                 ],
//                                               ),
//                                             ),
//                                             Center(
//                                               child: Text(
//                                                   restController
//                                                       .categoryList[
//                                                   index]
//                                                       .name,
//                                                   textAlign:
//                                                   TextAlign
//                                                       .center,
//                                                   style:
//                                                   robotoMedium
//                                                       .copyWith(
//                                                     fontSize: Dimensions
//                                                         .fontSizeDefault,
//                                                     color: Colors
//                                                         .black,
//                                                   )),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }),
//
//
//                               ///under tabs products
//                               ///under tabs products
//
//                               // SizedBox(
//                               //   height: 15,
//                               // ),
//                               // ProductView(
//                               //   isRestaurant: false,
//                               //   restaurants: null,
//                               //   products: restController.categoryList.length > 0
//                               //       ? restController.restaurantProducts
//                               //       : null,
//                               //   inRestaurantPage: true,
//                               //   type: restController.type,
//                               //   onVegFilterTap: (String type) {
//                               //     restController.getRestaurantProductList(
//                               //         restController.restaurant.id, 1, type, true);
//                               //   },
//                               //   padding: EdgeInsets.symmetric(
//                               //     horizontal: Dimensions.PADDING_SIZE_SMALL,
//                               //     vertical: ResponsiveHelper.isDesktop(context)
//                               //         ? Dimensions.PADDING_SIZE_SMALL
//                               //         : 0,
//                               //   ),
//                               // ),
//                               ///
//                               //
//                               // : restController.foodPaginate
//                               //     ? Center(
//                               //         child: Padding(
//                               //         padding: EdgeInsets.all(Dimensions
//                               //             .PADDING_SIZE_SMALL),
//                               //         child:
//                               //             CircularProgressIndicator(),
//                               //       ))
//                               //     : SizedBox(),
//
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Text('Recomended Products',
//                                   style: robotoMedium.copyWith(
//                                       fontSize:
//                                       Dimensions.fontSizeLarge + 2,
//                                       fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 15,
//                               ),
//
//                               ///
//                               productcontroller.allproductList == null
//                                   ? Center(child: CircularProgressIndicator())
//                                   : productcontroller.allproductList.length > 0
//                                   ? _controller.text.toString().isEmpty
//                                   ? GridView.builder(
//                                 itemCount: productcontroller.allproductList.length,
//                                 scrollDirection: Axis.vertical,
//                                 padding: EdgeInsets.zero,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                   childAspectRatio: 8 / 7,
//                                   crossAxisCount: 2,
//                                   crossAxisSpacing: 14,
//                                   mainAxisExtent: 210,
//                                   mainAxisSpacing: 10,
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   // print("All products length ${productcontroller.allproductList.length}");
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.to(() => ProductDetailScreen(
//                                           product: productcontroller.allproductList[index],
//                                           inRestaurantPage: true,
//                                           isCampaign: false));
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 16),
//                                       height: 202,
//                                       width: 163,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(6),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.24),
//                                             spreadRadius: 0,
//                                             blurRadius: 23,
//                                             offset: Offset(0, 1),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Container(
//                                             height: 98,
//                                             width: 112,
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                   "https://ansaarbazar.com/storage/app/public/product/${productcontroller.allproductList[index].image}",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Text(
//                                             productcontroller.allproductList[index].name,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               overflow: TextOverflow.ellipsis,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black,
//                                             ),
//                                             maxLines: 2,
//                                           ),
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//                                           Text(
//                                             "${productcontroller.allproductList[index].unit} , RS: ${productcontroller.allproductList[index].price.toString()}",
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                               color: Color(0xff373491),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             children: [
//                                               Container(
//                                                 height: 36,
//                                                 width: 36,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: Color(0xff189084),
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.add,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                                   : GridView.builder(
//                                 itemCount: filteredProducts.length,
//                                 scrollDirection: Axis.vertical,
//                                 padding: EdgeInsets.zero,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                   childAspectRatio: 8 / 7,
//                                   crossAxisCount: 2,
//                                   crossAxisSpacing: 14,
//                                   mainAxisExtent: 210,
//                                   mainAxisSpacing: 10,
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   print("Filtered products are ${filteredProducts.length}");
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.dialog(
//                                         Dialog(
//                                           child: ProductDetailScreen(
//                                             product: filteredProducts[index],
//                                             inRestaurantPage: true,
//                                             isCampaign: false,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 16),
//                                       height: 202,
//                                       width: 163,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(6),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.24),
//                                             spreadRadius: 0,
//                                             blurRadius: 23,
//                                             offset: Offset(0, 1),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Container(
//                                             height: 98,
//                                             width: 112,
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                   "https://ansaarbazar.com/storage/app/public/product/${filteredProducts[index].image}",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Text(
//                                             filteredProducts[index].name,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               overflow: TextOverflow.ellipsis,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//                                           Text(
//                                             filteredProducts[index].price.toString(),
//                                             style: TextStyle(
//                                               overflow: TextOverflow.ellipsis,
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                               color: Color(0xff373491),
//                                             ),
//                                           ),
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             children: [
//                                               Container(
//                                                 height: 36,
//                                                 width: 36,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: Color(0xff189084),
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.add,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                                   : SizedBox(),
//
//
//
//
//                               SizedBox(
//                                 height: 40,
//                               )
//                             ]),
//                       );
//
//                       ///
//                     },
//                   ),
//                 ))
//               ],
//             )
//                 : Center(child: CircularProgressIndicator());
//           });
//         }),
//       ),
//     );
//   }
//
//   Widget buildItem() {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           margin: EdgeInsets.all(10),
//           padding: EdgeInsets.only(
//             left: 25,
//           ),
//           height: 147,
//           width: 335,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
//                 blurRadius: 24,
//                 spreadRadius: 4,
//                 offset: Offset(4, 4),
//               )
//             ],
//             image: DecorationImage(
//               image: AssetImage("assets/image/img_13.png"),
//               fit: BoxFit.fill,
//             ),
//             borderRadius: BorderRadius.circular(15),
//             color: AppColors.primarycolor,
//           ),
//
//           // child: Row(
//           //   children: [
//           //     Image.asset("assets/image/img_1.png",fit: BoxFit.fill,),
//           //
//           //     // Column(
//           //     //   children: [
//           //     //     SizedBox(height: 10,),
//           //     //     Row(
//           //     //       children: [
//           //     //         SizedBox(width: 0,),
//           //     //         Text("50",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 56),),
//           //     //         SizedBox(width: 8,),
//           //     //         Column(
//           //     //           children: [
//           //     //             Text("off",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 15),),
//           //     //             Text("%",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 22),),
//           //     //             SizedBox(height: 3,),
//           //     //
//           //     //           ],
//           //     //         ),
//           //     //
//           //     //       ],
//           //     //     ),
//           //     //     Container(
//           //     //       padding: EdgeInsets.only(left: 20),
//           //     //       width: 150,
//           //     //       child:Text("Order any item from and get the discount",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 14),),
//           //     //
//           //     //     )
//           //     //
//           //     //   ],
//           //     // ),
//           //   ],
//           // ),
//         ),
//         // Positioned(
//         //     bottom:27,
//         //     right: 0,
//         //     left: 0,
//         //     child: buildIndicators()),
//       ],
//     );
//   }
//
//   Widget buildIndicators() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List<Widget>.generate(3, (index) {
//         return Container(
//           width: 8,
//           height: 8,
//           margin: EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: (index == controller.page) ? Colors.white : Colors.grey,
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class SliverDelegate extends SliverPersistentHeaderDelegate {
//   Widget child;
//
//   SliverDelegate({@required this.child});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }
//
//   @override
//   double get maxExtent => 50;
//
//   @override
//   double get minExtent => 50;
//
//   @override
//   bool shouldRebuild(SliverDelegate oldDelegate) {
//     return oldDelegate.maxExtent != 50 ||
//         oldDelegate.minExtent != 50 ||
//         child != oldDelegate.child;
//   }
// }
//
// class CategoryProduct {
//   CategoryModel category;
//   List<Product> products;
//   CategoryProduct(this.category, this.products);
// }
