import 'package:ansarbazzarweb/util/app_colors.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/view/base/confirmation_dialog.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../data/model/response/product_model.dart';
import '../../../data/model/response/restaurant_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_image.dart';
import '../../base/quantity_button.dart';
import '../checkout/checkout_screen.dart';


class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inRestaurantPage;
  final dynamic deliveryCharges;

  ProductDetailScreen({
    @required this.restaurant,
    @required this.product,
    @required this.isRestaurant, // Added this line
    @required this.deliveryCharges,
    this.isCampaign,
    this.cart,
    this.cartIndex,
    this.inRestaurantPage = false,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  int selectedIndex = -1;
  String  sizesID = '';

  // void initState() {
  //   super.initState();
  //   Get.find<ProductController>().initData(widget.product, widget.cart);
  //   // Set default sizeId if sizes list is not empty
  //   if (widget.product.size != null && widget.product.size.isNotEmpty) {
  //     selectedIndex = 0;
  //     sizesID = widget.product.size[0];
  //     AppConstants.sizeId = sizesID;
  //     print("sizes id is ${AppConstants.sizeId}");
  //   }
  //
  // }

  bool _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    Get.find<ProductController>().initData(widget.product, widget.cart);
    // _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    // if (_isLoggedIn) {
    //   // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    //   // Get.find<OrderController>().getRunningOrders(1);
    //   // Get.find<OrderController>().getHistoryOrders(1);
    // }

    if(widget.product.size=='null'){
      widget.product.size = ' ';
      AppConstants.sizeId = '0';
    }
      ///
    List<String> sizes = (widget.product?.size ?? "")
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(",")
        ?.map((e) => e.trim().replaceAll('"', ''))
        ?.where((e) => e.isNotEmpty) // Filter out empty strings
        ?.toList() ?? [];

// Set default sizeId if sizes list is not empty
    if (sizes.isNotEmpty) {
      selectedIndex = 0;
      sizesID = sizes[0];
      AppConstants.sizeId = sizesID;

      print("sizes id is ${AppConstants.sizeId}");
    }
  }

  @override
  Widget build(BuildContext context) {


    print("Product size is ${widget.product.size}");
    print("Product id  is ${widget.product.id}");
    print("Delivery charges  is ${widget.deliveryCharges}");

/// good one only null coming
     List<String> sizes = (widget.product?.size ?? "")
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(",")
        ?.map((e) => e.trim().replaceAll('"', ''))
        ?.where((e) => e.isNotEmpty) // Filter out empty strings
        ?.toList() ?? [];

    print("Sizes are in intial ${AppConstants.sizeId}");

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      _isLoggedIn?

      SingleChildScrollView(
          child:

          // GetBuilder<ProductController>(builder: (productController) {
          //
          //   return
          // });
      GetBuilder<ProductController>(
        builder: (productController) {
          double _startingPrice;
          double _endingPrice;
          if (widget.product.choiceOptions.length != 0) {
            List<double> _priceList = [];
            widget.product.variations
                .forEach((variation) => _priceList.add(variation.price));
            _priceList.sort((a, b) => a.compareTo(b));
            _startingPrice = _priceList[0];
            if (_priceList[0] < _priceList[_priceList.length - 1]) {
              _endingPrice = _priceList[_priceList.length - 1];
            }
          } else {
            _startingPrice = widget.product.price;
          }

          List<String> _variationList = [];
          for (int index = 0;
              index < widget.product.choiceOptions.length;
              index++) {
            _variationList.add(widget.product.choiceOptions[index]
                .options[productController.variationIndex[index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          _variationList.forEach((variation) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          });

          double price = widget.product.price;
          Variation _variation;
          for (Variation variation in widget.product.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              break;
            }
          }

          double _discount =
              (widget.isCampaign || widget.product.restaurantDiscount == 0)
                  ? widget.product.discount
                  : widget.product.restaurantDiscount;
          String _discountType =
              (widget.isCampaign || widget.product.restaurantDiscount == 0)
                  ? widget.product.discountType
                  : 'percent';
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              price, _discount, _discountType);
          double priceWithQuantity =
              priceWithDiscount * productController.quantity;
          double addonsCost = 0;
          List<AddOn> _addOnIdList = [];
          List<AddOns> _addOnsList = [];
          for (int index = 0; index < widget.product.addOns.length; index++) {
            if (productController.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (widget.product.addOns[index].price *
                      productController.addOnQtyList[index]);
              _addOnIdList.add(AddOn(
                  id: widget.product.addOns[index].id,
                  quantity: productController.addOnQtyList[index]));
              _addOnsList.add(widget.product.addOns[index]);
            }
          }
          double priceWithAddons = priceWithQuantity + addonsCost;
          bool _isRestAvailable = DateConverter.isAvailable(
              widget.product.restaurantOpeningTime,
              widget.product.restaurantClosingTime);
          bool _isFoodAvailable = DateConverter.isAvailable(
              widget.product.availableTimeStarts,
              widget.product.availableTimeEnds);
          bool _isAvailable = _isRestAvailable && _isFoodAvailable;

          CartModel _cartModel = CartModel(
            price,
            priceWithDiscount,
            _variation != null ? [_variation] : [],
            (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)),
            productController.quantity,
            _addOnIdList,
            _addOnsList,
            widget.isCampaign,
            widget.product,
            widget.deliveryCharges,
            [AppConstants.sizeId],

            // widget.deliveryCharges[0],
          );
          double screnWidth = MediaQuery.of(context).size.width;
          //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

          return GetPlatform.isIOS || GetPlatform.isAndroid?
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 300,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Color(0xffF3F3F8),
                  ),
                  child: Column(
                    children: [

                      // SizedBox(
                      //   height: 40,
                      // ),


                      SizedBox(
                        height: 38,
                      ),
                      Stack(
                        children: [

                          Container(
                            height: 300,
                            width: Get.width,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/image/placeholder.jpg', // Path to your placeholder image
                                  fit: BoxFit.fill,
                                ),
                                Image.network(
                                  '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Image has loaded
                                    } else {
                                      return Image.asset(
                                        'assets/image/placeholder.jpg', // Path to your placeholder image
                                        fit: BoxFit.fill,
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace stackTrace) {
                                    return Image.asset(
                                      'assets/image/placeholderiages.png', // Path to your placeholder image
                                      fit: BoxFit.fill,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 10,
                            // righ,
                            top: 10,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    )),
                                SizedBox(width: 80,),
                                Text(
                                  "Product detail",
                                  style: robotoRegular.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),

                        ],
                      ),

                      ///
                      ///
                      // Container(
                      //   height: 300,
                      //   width: Get.width,
                      //   decoration: BoxDecoration(
                      //     // color: Colors.red,
                      //     image: DecorationImage(
                      //       image: NetworkImage('${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',),
                      //     fit: BoxFit.fill
                      //     ),
                      //   ),
                      // ),
                      ///
                      ///
                      // Image.network('${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',),


                      // ClipRRect(
                      //   borderRadius:
                      //   BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      // child: Image.network('${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',),
                      // child: CustomImage(
                      //   image:
                      //   '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                      //   width:
                      //   ResponsiveHelper.isMobile(context) ? 300 : 270,
                      //   height:
                      //   ResponsiveHelper.isMobile(context) ? 180 : 200,
                      //   fit: BoxFit.fill,
                      // ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 44,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: robotoRegular.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                QuantityButton(
                                  onTap: () {
                                    if (productController.quantity > 1) {
                                      productController.setQuantity(false);
                                    }
                                  },
                                  isIncrement: false,
                                ),
                                Text(productController.quantity.toString(),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                                QuantityButton(
                                  onTap: () =>
                                      productController.setQuantity(true),
                                  isIncrement: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      Text(
                        '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount, discountType: _discountType)}' : ''}',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      price > priceWithDiscount
                          ? Text(
                        '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(
                            color: Theme.of(context).disabledColor,
                            decoration: TextDecoration.lineThrough),
                      )
                          : SizedBox(),
                      // Text("Rs .100 per kg",style: robotoRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: Color(0xff373491)),),
                      SizedBox(
                        height: 18,
                      ),

                      Row(children: [
                        Text('${'total_amount'.tr}:', style: robotoMedium),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text(PriceConverter.convertPrice(priceWithAddons),
                            style:
                            robotoBold.copyWith(color: Color(0xFF009f67))),
                      ]),
                      SizedBox(height: 10,),

                      Row(children: [
                        Text('${'Delivery fee'.tr}:', style: robotoMedium),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text('${widget.deliveryCharges}',
                            style:
                            robotoBold.copyWith(color: Color(0xFF009f67))),
                      ]),
                      SizedBox(height: 10,),
                      sizes.isNotEmpty ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Sizes:'),

                          Wrap(
                            spacing: 8.0, // Adjust spacing as needed
                            runSpacing: 10,
                            children: List.generate(
                              sizes.length,
                                  (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    sizesID = sizes[index];
                                    AppConstants.sizeId = sizesID; // Update AppConstants.sizeId
                                    print("sizes id is ${AppConstants.sizeId}");
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  color:
                                  selectedIndex == index ? Colors.blue : Colors.grey,
                                  child: Text(sizes[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),



                      SizedBox(
                        height: 18,
                      ),

                      // Row(
                      //   children: [
                      //     // Icon(
                      //     //   Icons.star,
                      //     //   color: AppColors.primarycolor,
                      //     // ),
                      //     // SizedBox(
                      //     //   width: 10,
                      //     // ),
                      //     // RichText(
                      //     //   text: TextSpan(children: [
                      //     //     TextSpan(
                      //     //         text: "4.8",
                      //     //         style: TextStyle(
                      //     //             fontWeight: FontWeight.w400,
                      //     //             fontSize: 12,
                      //     //             color: Colors.black)),
                      //     //     WidgetSpan(
                      //     //         child: SizedBox(
                      //     //       width: 5,
                      //     //     )),
                      //     //     TextSpan(
                      //     //         text: "rating",
                      //     //         style: TextStyle(
                      //     //             fontWeight: FontWeight.w400,
                      //     //             fontSize: 12,
                      //     //             color: Colors.black)),
                      //     //   ]),
                      //     // ),
                      //     SizedBox(
                      //       width: 60,
                      //     ),
                      //     // Row(
                      //     //   children: [
                      //     //     Icon(Icons.message,color: AppColors.primarycolor,),
                      //     //     SizedBox(width: 10,),
                      //     //     // RichText(text: TextSpan(
                      //     //     //     children: [
                      //     //     //       TextSpan(
                      //     //     //           text: "7",
                      //     //     //           style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: Colors.black)
                      //     //     //       ),
                      //     //     //       WidgetSpan(child: SizedBox(width: 5,)),
                      //     //     //       TextSpan(
                      //     //     //           text: "comments",
                      //     //     //           style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: Colors.black)
                      //     //     //       ),
                      //     //     //     ]
                      //     //     // ),
                      //     //     // ),
                      //     //   ],
                      //     // ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 18,
                      ),

                      // Text("Description",style: robotoRegular.copyWith(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black),),
                      (widget.product.description != null && widget.product.description.isNotEmpty)
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: robotoRegular.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                              height:
                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(widget.product.description,
                              style: robotoRegular),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        ],
                      )
                          : SizedBox(),

                      // SizedBox(height: 9,),
                      // Text("Ginger contains over 100 active compounds, including gingerols, shogaols, and paradols, which are thought to be responsible for its health benefits. When taken as a supplement, ginger has been associated with a number of health benefits, including reducing inflammation and improving outcomes in people",style: robotoRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black.withOpacity(0.70),letterSpacing: 1,height: 1.4),),
                      SizedBox(
                        height: 37,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      // Spacer(),
                      //
                      // _isAvailable
                      //     ? SizedBox()
                      //     : Container(
                      //         alignment: Alignment.center,
                      //         padding:
                      //             EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      //         margin: EdgeInsets.only(
                      //             bottom: Dimensions.PADDING_SIZE_SMALL),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               Dimensions.RADIUS_SMALL),
                      //           color: Color(0xFF009f67).withOpacity(0.1),
                      //         ),
                      //         child: !_isRestAvailable
                      //             ? Text(
                      //                 'restaurant_is_closed_now'.tr,
                      //                 style: robotoMedium.copyWith(
                      //                   color: AppColors.primarycolor,
                      //                   fontSize: Dimensions.fontSizeLarge,
                      //                 ),
                      //               )
                      //             : Column(children: [
                      //                 Text('not_available_now'.tr,
                      //                     style: robotoMedium.copyWith(
                      //                       color: AppColors.primarycolor,
                      //                       fontSize: Dimensions.fontSizeLarge,
                      //                     )),
                      //                 Text(
                      //                   '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                      //                   '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                      //                   style: robotoRegular,
                      //                 ),
                      //               ]),
                      //       ),

                      ///if widget.product isavalaible Or Not
                      // (!widget.product.scheduleOrder && !_isAvailable)
                      //     ? SizedBox()
                      //     :

                      Row(children: [
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                            child: CustomButton(
                              radius: Dimensions.RADIUS_LARGE + 15,
                              width: ResponsiveHelper.isDesktop(context)
                                  ? MediaQuery.of(context).size.width / 2.0
                                  : null,
                              /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                        ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                              buttonText: widget.isCampaign
                                  ? 'order_now'.tr
                                  : widget.cart != null
                                  ? 'update_in_cart'.tr
                                  : 'add_to_cart'.tr,
                              onPressed: () {
                                Get.back();
                                if (widget.isCampaign) {
                                  Get.toNamed(RouteHelper.getCheckoutRoute('campaign',), arguments: CheckoutScreen(fromCart: false, cartList: [_cartModel],));

                                } else {
                                  print("the size is ${AppConstants.sizeId}");
                                  Get.find<CartController>().addToCart(deliveryfee:widget.deliveryCharges[0] ,cartModel:_cartModel ,index: widget.cartIndex ,sizes:AppConstants.sizeId );
                                  // Get.find<CartController>().addToCart(_cartModel, widget.cartIndex,widget.deliveryCharges[0],AppConstants.sizeId);

                                  // AppConstants.sizeId == ''? AppConstants.sizeId = '0':AppConstants.sizeId = '0';
                                  _showCartSnackBar(context);
                                  // if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                                  //   Get.dialog(
                                  //       ConfirmationDialog(
                                  //         icon: Images.warning,
                                  //         title: 'are_you_sure_to_reset'.tr,
                                  //         description: 'if_you_continue'.tr,
                                  //         onYesPressed: () {
                                  //           Get.back();
                                  //           Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                                  //           _showCartSnackBar(context);
                                  //         },
                                  //       ),
                                  //       barrierDismissible: false);
                                  // } else {
                                  //   Get.find<CartController>().addToCart(_cartModel, widget.cartIndex,widget.deliveryCharges[0]);
                                  //   _showCartSnackBar(context);
                                  // }
                                }
                              },

                              /*onPressed: (!isExistInCart) ? () {
                      if (!isExistInCart) {
                        Get.back();
                        if(isCampaign) {
                          Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                            fromCart: false, cartList: [_cartModel],
                          ));
                        }else {
                          if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                            Get.dialog(ConfirmationDialog(
                              icon: Images.warning,
                              title: 'are_you_sure_to_reset'.tr,
                              description: 'if_you_continue'.tr,
                              onYesPressed: () {
                                Get.back();
                                Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                                _showCartSnackBar(context);
                              },
                            ), barrierDismissible: false);
                          } else {
                            Get.find<CartController>().addToCart(_cartModel, cartIndex);
                            _showCartSnackBar(context);
                          }
                        }
                      }
                    } : null,*/

                            )),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ):
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.primarycolor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            Text(
                              "Product detail",
                              style: robotoRegular.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                            SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        ///clip Image
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.yellow,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 250,
                              width: screnWidth > 600 ? 300.0 : 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.red,
                                image: DecorationImage(
                                    image: NetworkImage( '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                                    ),
                                    fit: BoxFit.fill
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 270,
                            ),
                            // SizedBox(),

                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height*0.1,),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 44,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.product.name,
                                            style: robotoRegular.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black),
                                          ),
                                        ),
                                        ///
                                        /// buttons
                                      ],
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),

                                    Text(
                                      '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount, discountType: _discountType)}' : ''}',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge),
                                    ),
                                    price > priceWithDiscount
                                        ? Text(
                                      '${PriceConverter.convertPrice(_startingPrice)}'
                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                                      style: robotoMedium.copyWith(
                                          color: Theme.of(context).disabledColor,
                                          decoration: TextDecoration.lineThrough),
                                    )
                                        : SizedBox(),
                                    // Text("Rs .100 per kg",style: robotoRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: Color(0xff373491)),),
                                    SizedBox(
                                      height: 18,
                                    ),

                                    Row(children: [
                                      Text('${'total_amount'.tr}:', style: robotoMedium),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(PriceConverter.convertPrice(priceWithAddons),
                                          style:
                                          robotoBold.copyWith(color: Color(0xFF009f67))),
                                    ]),
                                    SizedBox(height: 10,),

                                    Row(children: [
                                      Text('${'Delivery fee'.tr}:', style: robotoMedium),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text('${widget.deliveryCharges}',
                                          style:
                                          robotoBold.copyWith(color: Color(0xFF009f67))),
                                    ]),
                                    SizedBox(height: 10,),
                                    sizes.isNotEmpty ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Product Sizes:'),

                                        Wrap(
                                          spacing: 8.0, // Adjust spacing as needed
                                          runSpacing: 10,
                                          children: List.generate(
                                            sizes.length,
                                                (index) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                  sizesID = sizes[index];
                                                  AppConstants.sizeId = sizesID; // Update AppConstants.sizeId
                                                  print("sizes id is ${AppConstants.sizeId}");
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                color:
                                                selectedIndex == index ? Colors.blue : Colors.grey,
                                                child: Text(sizes[index]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                        : SizedBox(),



                                    SizedBox(
                                      height: 18,
                                    ),



                                    SizedBox(
                                      height: 18,
                                    ),

                                    // Text("Description",style: robotoRegular.copyWith(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black),),
                                    (widget.product.description != null && widget.product.description.isNotEmpty)
                                        ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description",
                                          style: robotoRegular.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        SizedBox(
                                            height:
                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        Text(widget.product.description,
                                            style: robotoRegular),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    )
                                        : SizedBox(),

                                    // SizedBox(height: 9,),
                                    // Text("Ginger contains over 100 active compounds, including gingerols, shogaols, and paradols, which are thought to be responsible for its health benefits. When taken as a supplement, ginger has been associated with a number of health benefits, including reducing inflammation and improving outcomes in people",style: robotoRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black.withOpacity(0.70),letterSpacing: 1,height: 1.4),),
                                    SizedBox(
                                      height: 37,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 180,
                                // color: Colors.red,
                                child: Column(
                                  children: [


                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 140,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              QuantityButton(
                                                onTap: () {
                                                  if (productController.quantity > 1) {
                                                    productController.setQuantity(false);
                                                  }
                                                },
                                                isIncrement: false,
                                              ),
                                              Text(productController.quantity.toString(),
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions.fontSizeLarge)),
                                              QuantityButton(
                                                onTap: () =>
                                                    productController.setQuantity(true),
                                                isIncrement: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // _isLoggedIn = Get.find<AuthController>().isLoggedIn();
                                        // if (_isLoggedIn) {
                                        //   // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
                                        //   // Get.find<OrderController>().getRunningOrders(1);
                                        //   // Get.find<OrderController>().getHistoryOrders(1);
                                        // }
                                        CustomButton(
                                          radius: Dimensions.RADIUS_LARGE + 15,
                                          width: 200,
                                          /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                              ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                                          buttonText: widget.isCampaign
                                              ? 'order_now'.tr
                                              : widget.cart != null
                                              ? 'update_in_cart'.tr
                                              : 'add_to_cart'.tr,
                                          onPressed: () {
                                            Get.back();
                                            _isLoggedIn = Get.find<AuthController>().isLoggedIn();

                                            if(_isLoggedIn){


                                            }
                                            if (widget.isCampaign) {
                                              Get.toNamed(RouteHelper.getCheckoutRoute('campaign',), arguments: CheckoutScreen(fromCart: false, cartList: [_cartModel],));

                                            } else {
                                              print("the size is ${AppConstants.sizeId}");
                                              Get.find<CartController>().addToCart(deliveryfee:widget.deliveryCharges[0] ,cartModel:_cartModel ,index: widget.cartIndex ,sizes:AppConstants.sizeId );

                                              // AppConstants.sizeId == ''? AppConstants.sizeId = '0':AppConstants.sizeId = '0';
                                              _showCartSnackBar(context);
                                              // if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                                              //   Get.dialog(
                                              //       ConfirmationDialog(
                                              //         icon: Images.warning,
                                              //         title: 'are_you_sure_to_reset'.tr,
                                              //         description: 'if_you_continue'.tr,
                                              //         onYesPressed: () {
                                              //           Get.back();
                                              //           Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                                              //           _showCartSnackBar(context);
                                              //         },
                                              //       ),
                                              //       barrierDismissible: false);
                                              // } else {
                                              //   Get.find<CartController>().addToCart(_cartModel, widget.cartIndex,widget.deliveryCharges[0]);
                                              //   _showCartSnackBar(context);
                                              // }
                                            }


                                          },

                                          /*onPressed: (!isExistInCart) ? () {
                              if (!isExistInCart) {
                              Get.back();
                              if(isCampaign) {
                                Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                              fromCart: false, cartList: [_cartModel],
                                ));
                              }else {
                                if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                              Get.dialog(ConfirmationDialog(
                                icon: Images.warning,
                                title: 'are_you_sure_to_reset'.tr,
                                description: 'if_you_continue'.tr,
                                onYesPressed: () {
                                  Get.back();
                                  Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                                  _showCartSnackBar(context);
                                },
                              ), barrierDismissible: false);
                                } else {
                              Get.find<CartController>().addToCart(_cartModel, cartIndex);
                              _showCartSnackBar(context);
                                }
                              }
                              }
                        } : null,*/

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      ///another container


                      // ClipRRect(
                      //   borderRadius:
                      //   BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      //   child: CustomImage(
                      //     image:
                      //     '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                      //     width:
                      //     ResponsiveHelper.isMobile(context) ? 200 : 270,
                      //     height:
                      //     ResponsiveHelper.isMobile(context) ? 140 : 200,
                      //     fit: BoxFit.fill,
                      //   ),
                    ],
                  ),
                ),

              ],
            ),
          );
        },
      )):NotLoggedInScreen(),
    );
  }

  void _showCartSnackBar(BuildContext context) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green,
      message: 'item_added_to_cart'.tr,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        child: Text('view_cart'.tr,
            style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
      ),
      onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
      duration: Duration(seconds: 3),
      maxWidth: Dimensions.WEB_MAX_WIDTH,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}
