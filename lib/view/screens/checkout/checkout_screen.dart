import 'dart:convert';
import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/cart_controller.dart';
import 'package:ansarbazzarweb/controller/coupon_controller.dart';
import 'package:ansarbazzarweb/controller/localization_controller.dart';
import 'package:ansarbazzarweb/controller/location_controller.dart';
import 'package:ansarbazzarweb/controller/order_controller.dart';
import 'package:ansarbazzarweb/controller/restaurant_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/controller/user_controller.dart';
import 'package:ansarbazzarweb/data/model/body/place_order_body.dart';
import 'package:ansarbazzarweb/data/model/response/address_model.dart';
import 'package:ansarbazzarweb/data/model/response/cart_model.dart';
import 'package:ansarbazzarweb/data/model/response/order_model.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/my_size.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:ansarbazzarweb/view/base/custom_button.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/custom_text_field.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:ansarbazzarweb/view/screens/address/widget/address_widget.dart';
import 'package:ansarbazzarweb/view/screens/checkout/widget/payment_button.dart';
import 'package:ansarbazzarweb/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:ansarbazzarweb/view/screens/checkout/widget/slot_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final OrderModel orderModel;
  final bool fromCart;
  final double deliveryfee;
  final dynamic onlydeliverfee;
  final String address;
  CheckoutScreen(
      {@required this.fromCart,
        @required this.address,
        @required this.deliveryfee,
        @required this.cartList,
        @required this.onlydeliverfee,
        @required this.orderModel});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool is_user_charged = false;
  var _tabTextIconIndexSelected = 0;
  Map<String, dynamic> paymentIntentData;
  bool _show = false;
  int paymentMethodIndex = 0;
  OrderController orderController;
  // LocationController locationController;
  List<Cart> carts;
  RestaurantController restController;
  DateTime _scheduleDate;
  double _total;
  double _discount;
  double _tax;
  double isCharge_value = 0;
  bool isFree_value = false;
  String delivery_pickup_value = "";

  var _listIconTabToggle = [
    Icons.delivery_dining,
    Icons.person,
  ];
  var _listGenderText = ["Delivery", "Pick-Up"];

  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double _taxPercent = 0;
  double _totalToPay = 0;
  // bool confirmOrderTabbed = false;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      if (Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      // if (Get.find<LocationController>().addressList == null) {
      //   Get.find<LocationController>().getAddressList();
      // }
      _isCashOnDeliveryActive =
          Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive =
          Get.find<SplashController>().configModel.digitalPayment;
      _cartList = [];
      widget.fromCart
          ? _cartList.addAll(Get.find<CartController>().cartList)
          : _cartList.addAll(widget.cartList);
      Get.find<RestaurantController>()
          .initCheckoutData(_cartList[0].product.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    if(kDebugMode){
      // print("delivery fee is ${widget.deliveryfee}");
      print("delivery fee is ${widget.onlydeliverfee}");
      print("address  is ${widget.address}");
      print("size is   is ${AppConstants.sizeId}");
    }
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: 'checkout'.tr),
          body:
          // _isLoggedIn
          //     ?




          GetBuilder<CartController>(
            builder: (cartController){
              return GetBuilder<RestaurantController>(builder: (restController) {
                bool _todayClosed = false;
                bool _tomorrowClosed = false;
                if (restController.restaurant != null) {
                  _todayClosed = restController.isRestaurantClosed(
                      true,
                      restController.restaurant.active,
                      restController.restaurant.offDay);
                  _tomorrowClosed = restController.isRestaurantClosed(
                      false,
                      restController.restaurant.active,
                      restController.restaurant.offDay);
                  _taxPercent = restController.restaurant.tax;
                }
                return GetBuilder<CouponController>(builder: (couponController) {
                  return
                    GetBuilder<OrderController>(builder: (orderController) {
                      double _deliveryCharge = 0;
                      double _charge = 0;
                      if (restController.restaurant != null &&
                          restController.restaurant.selfDeliverySystem == 1) {
                        _deliveryCharge = restController.restaurant.deliveryCharge;
                        _charge = restController.restaurant.deliveryCharge;

                        print(" 0 setting actual delivery cost $_deliveryCharge ");
                      } else if (restController.restaurant != null &&
                          orderController.distance != null) {
                        _deliveryCharge = orderController.distance *
                            Get.find<SplashController>()
                                .configModel
                                .perKmShippingCharge;
                        print(" 1 setting actual delivery cost $_deliveryCharge ");
                        _charge = orderController.distance *
                            Get.find<SplashController>()
                                .configModel
                                .perKmShippingCharge;
                        if (_deliveryCharge <
                            Get.find<SplashController>()
                                .configModel
                                .minimumShippingCharge) {
                          _deliveryCharge = Get.find<SplashController>()
                              .configModel
                              .minimumShippingCharge;
                          print(" 2 setting actual delivery cost $_deliveryCharge ");
                          //   setState(() {
                          _deliveryCharge = _deliveryCharge;
                          //  });
                          _charge = Get.find<SplashController>()
                              .configModel
                              .minimumShippingCharge;
                        }
                      }

                      double _price = 0;
                      double _discount = 0;
                      double _couponDiscount = couponController.discount;
                      // double _tax = 0;
                      double _addOns = 0;
                      double _subTotal = 0;
                      double _orderAmount = 0;
                      if (restController.restaurant != null) {
                        _cartList.forEach((cartModel) {
                          List<AddOns> _addOnList = [];
                          cartModel.addOnIds.forEach((addOnId) {
                            for (AddOns addOns in cartModel.product.addOns) {
                              if (addOns.id == addOnId.id) {
                                _addOnList.add(addOns);
                                break;
                              }
                            }
                          });

                          for (int index = 0; index < _addOnList.length; index++) {
                            _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
                          }
                          _price = _price + (cartModel.price * cartModel.quantity);
                          double _dis = (restController.restaurant.discount != null &&
                              DateConverter.isAvailable(
                                  restController.restaurant.discount.startTime,
                                  restController.restaurant.discount.endTime))
                              ? restController.restaurant.discount.discount
                              : cartModel.product.discount;
                          String _disType = (restController.restaurant.discount !=
                              null &&
                              DateConverter.isAvailable(
                                  restController.restaurant.discount.startTime,
                                  restController.restaurant.discount.endTime))
                              ? 'percent'
                              : cartModel.product.discountType;
                          _discount = _discount +
                              ((cartModel.price -
                                  PriceConverter.convertWithDiscount(
                                      cartModel.price, _dis, _disType)) *
                                  cartModel.quantity);
                        });
                        if (restController.restaurant != null &&
                            restController.restaurant.discount != null) {
                          if (restController.restaurant.discount.maxDiscount != 0 &&
                              restController.restaurant.discount.maxDiscount <
                                  _discount) {
                            _discount =
                                restController.restaurant.discount.maxDiscount;
                          }
                          if (restController.restaurant.discount.minPurchase != 0 &&
                              restController.restaurant.discount.minPurchase > (_price + _addOns)) {
                            _discount = 0;
                          }
                        }
                        _subTotal = _price + _addOns;
                        _orderAmount = (_price - _discount) + _addOns - _couponDiscount;
                        print("order type  ${orderController.orderType} ");
                        print(
                            "resturan freedelivery  ${restController.restaurant.freeDelivery} ");
                        print(
                            "free delivery over >  ${Get.find<SplashController>().configModel.freeDeliveryOver} ");
                        print("order amount $_orderAmount ");

                        print(
                            "counpon freedelivery  ${couponController.freeDelivery} ");
                        if (orderController.orderType == 'take_away' ||
                            restController.restaurant.freeDelivery ||
                            (Get.find<SplashController>()
                                .configModel
                                .freeDeliveryOver !=
                                null &&
                                _orderAmount >=
                                    Get.find<SplashController>()
                                        .configModel
                                        .freeDeliveryOver) ||
                            couponController.freeDelivery) {
                          // _deliveryCharge = 0;
                          print("setting delivery charges .... $_deliveryCharge ");
                        }
                      }

                      // @ asrar - tax removed
                      //  _tax = PriceConverter.calculation(
                      //     _orderAmount, _taxPercent, 'percent', 1);
                      // _tax = 0;
                    // double  _deliveryfee = double.parse(cartController.cartList[0].deliverycharges);

                      // double _total = _subTotal + 100 - 0 - 0;

                      print("deliveryyyyy ${widget.onlydeliverfee }");
                      double _total = _subTotal + double.parse(widget.onlydeliverfee) - _discount - _couponDiscount;
                      // _totalToPay = _total+widget.deliveryfee;
                      // _total = _total+widget.deliveryfee;
                      return GetPlatform.isIOS|| GetPlatform.isAndroid?
                      Column(
                        children: [
                          Expanded(
                              child: Scrollbar(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                    EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: Center(
                                        child: SizedBox(
                                          width: Dimensions.WEB_MAX_WIDTH,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                    onTap: (){
                                                      Get.back();
                                                    },
                                                    child: Icon(Icons.arrow_back,color: Colors.black,)),
                                                // Order type
                                                //    Text('delivery_option'.tr, style: robotoMedium),
                                                // Center(
                                                //   child: FlutterToggleTab(
                                                //     width: 75,
                                                //     borderRadius: 25,
                                                //     selectedTextStyle: TextStyle(
                                                //         color: Colors.black,
                                                //         fontSize: 14,
                                                //         fontWeight: FontWeight.w600),
                                                //     unSelectedTextStyle: TextStyle(
                                                //       color: Colors.blue,
                                                //       fontSize: 14,
                                                //       fontWeight: FontWeight.w400,
                                                //     ),
                                                //     labels: _listGenderText,
                                                //     begin: Alignment.centerLeft,
                                                //     icons: _listIconTabToggle,
                                                //     selectedIndex:
                                                //     _tabTextIconIndexSelected,
                                                //     selectedLabelIndex: (index) {
                                                //       setState(() {
                                                //         _tabTextIconIndexSelected = index;
                                                //
                                                //         if (index == 0) {
                                                //           delivery_pickup_value =
                                                //           "delivery";
                                                //           isFree_value = restController
                                                //               .restaurant.freeDelivery;
                                                //           isCharge_value = _deliveryCharge;
                                                //           print(
                                                //               "showing delivery charge cost $_deliveryCharge ");
                                                //         } else {
                                                //           delivery_pickup_value =
                                                //           "take_away";
                                                //           isFree_value = true;
                                                //           isCharge_value = _charge;
                                                //         }
                                                //       });
                                                //
                                                //       print("toogle index -- $index ");
                                                //       print(
                                                //           "-- is charge ${restController.restaurant.freeDelivery}");
                                                //       print(
                                                //           "-- is delivery_pickup_value ?  ${delivery_pickup_value}");
                                                //     },
                                                //   ),
                                                // ),
                                                // restController.restaurant.delivery ? DeliveryOptionButton(
                                                //   value: 'delivery', title: 'home_delivery'.tr, charge: _charge, isFree: restController.restaurant.freeDelivery,
                                                // ) : SizedBox(),
                                                // restController.restaurant.takeAway ? DeliveryOptionButton(
                                                //   value: 'take_away', title: 'take_away'.tr, charge: _deliveryCharge, isFree: true,
                                                // ) : SizedBox(),
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_LARGE),

                                                // _tabTextIconIndexSelected == 0 ?
                                                // restController.restaurant.delivery ?
                                                // Text(
                                                //   '(${(delivery_pickup_value == 'delivery' && isFree_value) ? 'free'.tr : PriceConverter.convertPrice(isCharge_value)})',
                                                //   style: robotoMedium,
                                                // ): SizedBox()
                                                // : restController.restaurant.takeAway ?
                                                // Text(
                                                //   '(${(delivery_pickup_value == 'take_away' && isFree_value) ? 'free'.tr : PriceConverter.convertPrice(isCharge_value)})',
                                                //   style: robotoMedium,
                                                // ): SizedBox(),

                                                _tabTextIconIndexSelected != 1
                                                    ? Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            // Text('deliver_to'.tr,
                                                            //     style: robotoMedium),
                                                            // TextButton.icon(
                                                            //   onPressed: () => Get
                                                            //       .toNamed(RouteHelper
                                                            //       .getAddAddressRoute(
                                                            //       true)),
                                                            //   icon: Icon(Icons.add,
                                                            //       size: 20),
                                                            //   label: Text('add'.tr,
                                                            //       style: robotoMedium
                                                            //           .copyWith(
                                                            //           fontSize:
                                                            //           Dimensions
                                                            //               .fontSizeSmall)),
                                                            // ),

                                                          ]),
                                                      // DropdownButton(
                                                      //   value: orderController
                                                      //       .addressIndex,
                                                      //   items: _addressList,
                                                      //   itemHeight:
                                                      //       ResponsiveHelper.isMobile(
                                                      //               context)
                                                      //           ? 70
                                                      //           : 85,
                                                      //   elevation: 0,
                                                      //   iconSize: 30,
                                                      //   iconEnabledColor:
                                                      //       Colors.black,
                                                      //   underline: SizedBox(),
                                                      //   onChanged: (int index) =>
                                                      //       orderController
                                                      //           .setAddressIndex(
                                                      //               index),
                                                      // ),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE),
                                                    ])
                                                    : SizedBox(),

                                                // Time Slot
                                                // restController.restaurant.scheduleOrder
                                                //     ? Column(
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment.start,
                                                //         children: [
                                                //             _tabTextIconIndexSelected != 1
                                                //                 ? Text('delivery_time'.tr,
                                                //                     style: robotoMedium)
                                                //                 : Text('pickup_time'.tr,
                                                //                     style: robotoMedium),
                                                //             SizedBox(
                                                //                 height: Dimensions
                                                //                     .PADDING_SIZE_SMALL),
                                                //             SizedBox(
                                                //               height: 50,
                                                //               child: ListView.builder(
                                                //                 scrollDirection:
                                                //                     Axis.horizontal,
                                                //                 shrinkWrap: true,
                                                //                 physics:
                                                //                     BouncingScrollPhysics(),
                                                //                 itemCount: 2,
                                                //                 itemBuilder:
                                                //                     (context, index) {
                                                //                   return SlotWidget(
                                                //                     title: index == 0
                                                //                         ? 'today'.tr
                                                //                         : 'tomorrow'.tr,
                                                //                     isSelected: orderController
                                                //                             .selectedDateSlot ==
                                                //                         index,
                                                //                     onTap: () =>
                                                //                         orderController
                                                //                             .updateDateSlot(
                                                //                                 index),
                                                //                   );
                                                //                 },
                                                //               ),
                                                //             ),
                                                //             SizedBox(
                                                //                 height: Dimensions
                                                //                     .PADDING_SIZE_SMALL),
                                                //             SizedBox(
                                                //               height: 50,
                                                //               child: ((orderController
                                                //                                   .selectedDateSlot ==
                                                //                               0 &&
                                                //                           _todayClosed) ||
                                                //                       (orderController
                                                //                                   .selectedDateSlot ==
                                                //                               1 &&
                                                //                           _tomorrowClosed))
                                                //                   ? Center(
                                                //                       child: Text(
                                                //                           'restaurant_is_closed'
                                                //                               .tr))
                                                //                   : orderController
                                                //                               .timeSlots !=
                                                //                           null
                                                //                       ? orderController
                                                //                                   .timeSlots
                                                //                                   .length >
                                                //                               0
                                                //                           ? ListView
                                                //                               .builder(
                                                //                               scrollDirection:
                                                //                                   Axis.horizontal,
                                                //                               shrinkWrap:
                                                //                                   true,
                                                //                               physics:
                                                //                                   BouncingScrollPhysics(),
                                                //                               itemCount:
                                                //                                   orderController
                                                //                                       .timeSlots
                                                //                                       .length,
                                                //                               itemBuilder:
                                                //                                   (context,
                                                //                                       index) {
                                                //                                 return SlotWidget(
                                                //                                   title: (index == 0 &&
                                                //                                           orderController.selectedDateSlot == 0 &&
                                                //                                           DateConverter.isAvailable(
                                                //                                             restController.restaurant.openingTime,
                                                //                                             restController.restaurant.closeingTime,
                                                //                                           ))
                                                //                                       ? 'now'.tr
                                                //                                       : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                                //                                           '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                                                //                                   isSelected:
                                                //                                       orderController.selectedTimeSlot ==
                                                //                                           index,
                                                //                                   onTap: () =>
                                                //                                       orderController
                                                //                                           .updateTimeSlot(index),
                                                //                                 );
                                                //                               },
                                                //                             )
                                                //                           : Center(
                                                //                               child: Text(
                                                //                                   'no_slot_available'
                                                //                                       .tr))
                                                //                       : Center(
                                                //                           child:
                                                //                               CircularProgressIndicator()),
                                                //             ),
                                                //             SizedBox(
                                                //                 height: Dimensions
                                                //                     .PADDING_SIZE_LARGE),
                                                //           ])
                                                //     : SizedBox(),

                                                CustomTextField(
                                                  controller: _noteController,
                                                  hintText: 'additional_note'.tr,
                                                  maxLines: 3,
                                                  inputType: TextInputType.multiline,
                                                  inputAction: TextInputAction.newline,
                                                  capitalization:
                                                  TextCapitalization.sentences,
                                                ),
                                                // Coupon
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_LARGE),

                                                Text('choose_payment_method'.tr,
                                                    style: robotoMedium),
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_SMALL),
                                                // _isCashOnDeliveryActive
                                                //     ? PaymentButton(
                                                //   icon: Images.cash_on_delivery,
                                                //   title: 'cash_on_delivery'.tr,
                                                //   subtitle:
                                                //   'pay_your_payment_after_getting_food'
                                                //       .tr,
                                                //   index: 0,
                                                // )
                                                //     : SizedBox(),




                                                //    Image.asset('assets/image/gpay.png'),
                                                // adding google pay
                                                //,

                                                //    previous digital payment button
                                                // _isDigitalPaymentActive
                                                //     ?
                                                // ? Row(children: [
                                                //     PaymentBox(
                                                //       icon: Images.googlepay,
                                                //       index:
                                                //           _isCashOnDeliveryActive
                                                //               ? 1
                                                //               : 0,
                                                //     ),
                                                //     SizedBox(
                                                //       width: 10,
                                                //     ),
                                                //     PaymentBox(
                                                //       icon: Images.stripe,
                                                //       index:
                                                //           _isCashOnDeliveryActive
                                                //               ? 2
                                                //               : 0,
                                                //     ),
                                                //     SizedBox(
                                                //       width: 10,
                                                //     ),
                                                //     PaymentBox(
                                                //       icon: Images.paypal,
                                                //       index:
                                                //           _isCashOnDeliveryActive
                                                //               ? 3
                                                //               : 0,
                                                //     ),
                                                //   ])
                                                // : SizedBox(),
                                                // GestureDetector(
                                                //     onTap: () {
                                                //       print("hello");
                                                //     },
                                                //     child: PaymentButton(
                                                //       icon:
                                                //           Images.digital_payment,
                                                //       title: 'digital_payment'.tr,
                                                //       subtitle:
                                                //           'faster_and_safe_way'
                                                //               .tr,
                                                //       index:
                                                //           1, //_isCashOnDeliveryActive ? 1 : 0
                                                //     ),
                                                //   )
                                                // : SizedBox(),

                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_LARGE),

                                                GetBuilder<CouponController>(
                                                  builder: (couponController) {
                                                    return Row(children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 50,
                                                          child: TextField(
                                                            controller: _couponController,
                                                            style: robotoRegular.copyWith(
                                                                height: ResponsiveHelper
                                                                    .isMobile(context)
                                                                    ? null
                                                                    : 2),
                                                            decoration: InputDecoration(
                                                              hintText:
                                                              'enter_promo_code'.tr,
                                                              hintStyle:
                                                              robotoRegular.copyWith(
                                                                  color:
                                                                  Theme.of(context)
                                                                      .hintColor),
                                                              isDense: true,
                                                              filled: true,
                                                              enabled: couponController
                                                                  .discount ==
                                                                  0,
                                                              fillColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.horizontal(
                                                                  left: Radius.circular(
                                                                      Get.find<LocalizationController>()
                                                                          .isLtr
                                                                          ? 10
                                                                          : 1),
                                                                  right: Radius.circular(
                                                                      Get.find<LocalizationController>()
                                                                          .isLtr
                                                                          ? 1
                                                                          : 10),
                                                                ),
                                                                borderSide: BorderSide(
                                                                    style: BorderStyle.none,
                                                                    width: 1),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          String _couponCode =
                                                          _couponController.text.trim();
                                                          if (couponController.discount <
                                                              1 &&
                                                              !couponController
                                                                  .freeDelivery) {
                                                            if (_couponCode.isNotEmpty &&
                                                                !couponController
                                                                    .isLoading) {
                                                              couponController
                                                                  .applyCoupon(
                                                                  _couponCode,
                                                                  (_price - _discount) +
                                                                      _addOns,
                                                                  _deliveryCharge,
                                                                  restController
                                                                      .restaurant.id)
                                                                  .then((discount) {
                                                                if (discount > 0) {
                                                                  showCustomSnackBar(
                                                                    '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                                                    isError: false,
                                                                  );
                                                                }
                                                              });
                                                            } else if (_couponCode
                                                                .isEmpty) {
                                                              showCustomSnackBar(
                                                                  'enter_a_coupon_code'.tr);
                                                            }
                                                          } else {
                                                            couponController
                                                                .removeCouponData(true);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            // boxShadow: [
                                                            //   BoxShadow(
                                                            //       color: Colors.grey[
                                                            //           Get.isDarkMode
                                                            //               ? 800
                                                            //               : 200],
                                                            //       spreadRadius: 1,
                                                            //       blurRadius: 5)
                                                            // ],
                                                            borderRadius:
                                                            BorderRadius.horizontal(
                                                              left: Radius.circular(
                                                                  Get.find<LocalizationController>()
                                                                      .isLtr
                                                                      ? 0
                                                                      : 12),
                                                              right: Radius.circular(
                                                                  Get.find<LocalizationController>()
                                                                      .isLtr
                                                                      ? 10
                                                                      : 0),
                                                            ),
                                                          ),
                                                          child: (couponController
                                                              .discount <=
                                                              0 &&
                                                              !couponController
                                                                  .freeDelivery)
                                                              ? !couponController.isLoading
                                                              ? Text(
                                                            'apply'.tr,
                                                            style: robotoMedium
                                                                .copyWith(
                                                                color: Theme.of(
                                                                    context)
                                                                    .cardColor),
                                                          )
                                                              : CircularProgressIndicator(
                                                              valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                                  Colors.white))
                                                              : Icon(Icons.clear,
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ]);
                                                  },
                                                ),
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_LARGE),
                                                //SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                                Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('subtotal'.tr,
                                                          style: robotoMedium),
                                                      Text(
                                                          PriceConverter.convertPrice(_subTotal),
                                                          style: robotoMedium),
                                                    ]),
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_SMALL),
                                                Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('discount'.tr,
                                                          style: robotoRegular),
                                                      Text(
                                                          '${PriceConverter.convertPrice(_discount)}',
                                                          style: robotoRegular),
                                                    ]),
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_SMALL),
                                                (couponController.discount > 0 ||
                                                    couponController.freeDelivery)
                                                    ? Column(children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text('coupon_discount'.tr,
                                                            style: robotoRegular),
                                                        (couponController.coupon !=
                                                            null &&
                                                            couponController
                                                                .coupon
                                                                .couponType ==
                                                                'free_delivery')
                                                            ? Text(
                                                          'free_delivery'.tr,
                                                          style: robotoRegular.copyWith(
                                                              color: Theme.of(
                                                                  context)
                                                                  .primaryColor),
                                                        )
                                                            : Text(
                                                          '${PriceConverter.convertPrice(couponController.discount)}',
                                                          style: robotoRegular,
                                                        ),
                                                      ]),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                ])
                                                    : SizedBox(),
                                                /* Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('vat_tax'.tr, style: robotoRegular),
                            Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
                          ]),*/
                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_SMALL),
                                                _tabTextIconIndexSelected == 0
                                                    ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('delivery_fee'.tr,
                                                          style: robotoRegular),
                                                      (widget.onlydeliverfee == 0 || (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery'))
                                                          ? Text(
                                                        'free'.tr,
                                                        style: robotoRegular
                                                            .copyWith(
                                                            color: Theme.of(
                                                                context)
                                                                .primaryColor),
                                                      )
                                                          : Text(
                                                        '${PriceConverter.convertPrice(double.parse(widget.onlydeliverfee))}',
                                                        style: robotoRegular,
                                                      ),
                                                    ])
                                                    : SizedBox(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                      Dimensions.PADDING_SIZE_SMALL),
                                                  child: Divider(
                                                      thickness: 1,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(0.5)),
                                                ),
                                                SizedBox(height: 20,),
                                                Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'total_amount'.tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize:
                                                            Dimensions.fontSizeLarge,
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                      Text(
                                                        '${PriceConverter.convertPrice(_total)}',
                                                        style: robotoMedium.copyWith(
                                                            fontSize:
                                                            Dimensions.fontSizeLarge,
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                    ]),
                                              ]),
                                        )),
                                  ))),
                          orderController.isLoading?
                          CircularProgressIndicator(): Container(
                              width: Dimensions.WEB_MAX_WIDTH,
                              alignment: Alignment.center,
                              padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child:CustomButton(
                                  buttonText: 'Confirm Order'.tr,
                                  onPressed: () {
                                    ///


                                    // confirmOrderTabbed = true;
                                    bool _isAvailable = true;
                                    DateTime _scheduleDate = DateTime.now();
                                    if (orderController.timeSlots == null ||
                                        orderController.timeSlots.length ==
                                            0) {
                                      _isAvailable = false;
                                    } else {
                                      DateTime _date =
                                      orderController.selectedDateSlot ==
                                          0
                                          ? DateTime.now()
                                          : (Duration(days: 1));
                                      DateTime _time = orderController
                                          .timeSlots[orderController
                                          .selectedTimeSlot]
                                          .startTime;
                                      _scheduleDate = DateTime(
                                          _date.year,
                                          _date.month,
                                          _date.day,
                                          _time.hour,
                                          _time.minute + 1);

                                      for (CartModel cart in _cartList) {
                                        if (!DateConverter.isAvailable(
                                          cart.product.availableTimeStarts,
                                          cart.product.availableTimeEnds,
                                          time: restController
                                              .restaurant.scheduleOrder
                                              ? _scheduleDate
                                              : null,
                                        )) {
                                          _isAvailable = false;
                                          break;
                                        }
                                      }
                                    }
                                    if (_orderAmount <
                                        restController
                                            .restaurant.minimumOrder) {
                                      showCustomSnackBar(
                                          '${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                                    } else if ((orderController
                                        .selectedDateSlot ==
                                        0 &&
                                        _todayClosed) ||
                                        (orderController.selectedDateSlot ==
                                            1 &&
                                            _tomorrowClosed)) {
                                      showCustomSnackBar(
                                          'restaurant_is_closed'.tr);
                                    } else if (orderController.timeSlots ==
                                        null ||
                                        orderController.timeSlots.length ==
                                            0) {
                                      if (restController
                                          .restaurant.scheduleOrder) {
                                        showCustomSnackBar(
                                            'select_a_time'.tr);
                                      } else {
                                        showCustomSnackBar(
                                            'restaurant_is_closed'.tr);
                                      }
                                    }

                                    // else if (!_isAvailable) {
                                    //   showCustomSnackBar(
                                    //       'one_or_more_products_are_not_available_for_this_selected_time'
                                    //           .tr);
                                    // }

                                    else {
                                      List<Cart> carts = [];

                                      for (int index = 0; index < _cartList.length; index++) {
                                        CartModel cart = _cartList[index];
                                        List<int> _addOnIdList = [];
                                        List<int> _addOnQtyList = [];

                                        cart.addOnIds.forEach((addOn) {
                                          _addOnIdList.add(addOn.id);
                                          _addOnQtyList.add(addOn.quantity);
                                        });

                                        carts.add(Cart(
                                          cart.isCampaign ? null : cart.product.id,
                                          cart.isCampaign ? cart.product.id : null,
                                          cart.discountedPrice.toString(),
                                          '',
                                          cart.variation,
                                          cart.quantity,
                                          _addOnIdList,
                                          cart.addOns,
                                          _addOnQtyList,
                                          cart.sizeList, // Include list of sizes
                                        ));
                                      }

// Ensure that the 'carts' list is initialized before using it
                                      if (carts.isEmpty) {
                                        carts = []; // Initialize the list if it's null or empty
                                      }

// Now you can use the 'carts' list without encountering the 'add' method on null error


                                      // List<Cart> carts = [];
                                      // for (int index = 0;
                                      // index < _cartList.length;
                                      // index++) {
                                      //   CartModel cart = _cartList[index];
                                      //   List<int> _addOnIdList = [];
                                      //   List<int> _addOnQtyList = [];
                                      //   cart.addOnIds.forEach((addOn) {
                                      //     _addOnIdList.add(addOn.id);
                                      //     _addOnQtyList.add(addOn.quantity);
                                      //   });
                                      //   carts.add(Cart(
                                      //     cart.isCampaign
                                      //         ? null
                                      //         : cart.product.id,
                                      //     cart.isCampaign
                                      //         ? cart.product.id
                                      //         : null,
                                      //     cart.discountedPrice.toString(),
                                      //     '',
                                      //     cart.variation,
                                      //     cart.quantity,
                                      //     _addOnIdList,
                                      //     cart.addOns,
                                      //     _addOnQtyList,
                                      //
                                      //   ));
                                      // }

                                      this.orderController = orderController;
                                      // locationController;

                                      this.carts = carts;
                                      this.restController = restController;
                                      this._scheduleDate = _scheduleDate;
                                      this._total = _total;
                                      this._discount = _discount;
                                      this._tax = _tax;
                                      paymentMethodIndex = orderController.paymentMethodIndex;
                                      print(
                                          ">>> payment method index $paymentMethodIndex");
                                      print(">>> payment  $_total");

                                      if (paymentMethodIndex == 0) {
                                        print("yahe say horha hai");
                                        // order_amount,payment_method,order_type,restaurant_id,size

                                        getOrderPlaced(
                                            this.orderController,
                                            // this.locationController,
                                            this.carts,
                                            this.restController,
                                            this._scheduleDate,
                                            this._total,
                                            this._discount,
                                            this._tax);
                                      } else {}
                                    }
                                  })

                            //     : confirmOrderTabbed != true
                            //     ? Center(
                            //   child: Text(
                            //       "Thanks for your trust on Ansaar Bazar"),
                            // )

                          ),
                        ],
                      )
                          :
                      Column(
                        children: [
                          Expanded(
                              child: Scrollbar(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                    EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: Center(
                                        child: SizedBox(
                                          width: Dimensions.WEB_MAX_WIDTH,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                    onTap: (){
                                                      Get.back();
                                                    },
                                                    child: Icon(Icons.arrow_back,color: Colors.black,)),

                                                // Order type
                                                //    Text('delivery_option'.tr, style: robotoMedium),
                                                // Center(
                                                //   child: FlutterToggleTab(
                                                //     width: 75,
                                                //     borderRadius: 25,
                                                //     selectedTextStyle: TextStyle(
                                                //         color: Colors.black,
                                                //         fontSize: 14,
                                                //         fontWeight: FontWeight.w600),
                                                //     unSelectedTextStyle: TextStyle(
                                                //       color: Colors.blue,
                                                //       fontSize: 14,
                                                //       fontWeight: FontWeight.w400,
                                                //     ),
                                                //     labels: _listGenderText,
                                                //     begin: Alignment.centerLeft,
                                                //     icons: _listIconTabToggle,
                                                //     selectedIndex:
                                                //     _tabTextIconIndexSelected,
                                                //     selectedLabelIndex: (index) {
                                                //       setState(() {
                                                //         _tabTextIconIndexSelected = index;
                                                //
                                                //         if (index == 0) {
                                                //           delivery_pickup_value =
                                                //           "delivery";
                                                //           isFree_value = restController
                                                //               .restaurant.freeDelivery;
                                                //           isCharge_value = _deliveryCharge;
                                                //           print(
                                                //               "showing delivery charge cost $_deliveryCharge ");
                                                //         } else {
                                                //           delivery_pickup_value =
                                                //           "take_away";
                                                //           isFree_value = true;
                                                //           isCharge_value = _charge;
                                                //         }
                                                //       });
                                                //
                                                //       print("toogle index -- $index ");
                                                //       print(
                                                //           "-- is charge ${restController.restaurant.freeDelivery}");
                                                //       print(
                                                //           "-- is delivery_pickup_value ?  ${delivery_pickup_value}");
                                                //     },
                                                //   ),
                                                // ),
                                                // restController.restaurant.delivery ? DeliveryOptionButton(
                                                //   value: 'delivery', title: 'home_delivery'.tr, charge: _charge, isFree: restController.restaurant.freeDelivery,
                                                // ) : SizedBox(),
                                                // restController.restaurant.takeAway ? DeliveryOptionButton(
                                                //   value: 'take_away', title: 'take_away'.tr, charge: _deliveryCharge, isFree: true,
                                                // ) : SizedBox(),

                                                SizedBox(
                                                    height: Dimensions.PADDING_SIZE_LARGE),

                                                // _tabTextIconIndexSelected == 0 ?
                                                // restController.restaurant.delivery ?
                                                // Text(
                                                //   '(${(delivery_pickup_value == 'delivery' && isFree_value) ? 'free'.tr : PriceConverter.convertPrice(isCharge_value)})',
                                                //   style: robotoMedium,
                                                // ): SizedBox()
                                                // : restController.restaurant.takeAway ?
                                                // Text(
                                                //   '(${(delivery_pickup_value == 'take_away' && isFree_value) ? 'free'.tr : PriceConverter.convertPrice(isCharge_value)})',
                                                //   style: robotoMedium,
                                                // ): SizedBox(),

                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.5,
                                                          // color: Colors.red,
                                                          child: Column(
                                                            children: [
                                                              _tabTextIconIndexSelected != 1
                                                                  ? Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          // Text('deliver_to'.tr,
                                                                          //     style: robotoMedium),
                                                                          // TextButton.icon(
                                                                          //   onPressed: () => Get
                                                                          //       .toNamed(RouteHelper
                                                                          //       .getAddAddressRoute(
                                                                          //       true)),
                                                                          //   icon: Icon(Icons.add,
                                                                          //       size: 20),
                                                                          //   label: Text('add'.tr,
                                                                          //       style: robotoMedium
                                                                          //           .copyWith(
                                                                          //           fontSize:
                                                                          //           Dimensions
                                                                          //               .fontSizeSmall)),
                                                                          // ),

                                                                        ]),
                                                                    // DropdownButton(
                                                                    //   value: orderController
                                                                    //       .addressIndex,
                                                                    //   items: _addressList,
                                                                    //   itemHeight:
                                                                    //       ResponsiveHelper.isMobile(
                                                                    //               context)
                                                                    //           ? 70
                                                                    //           : 85,
                                                                    //   elevation: 0,
                                                                    //   iconSize: 30,
                                                                    //   iconEnabledColor:
                                                                    //       Colors.black,
                                                                    //   underline: SizedBox(),
                                                                    //   onChanged: (int index) =>
                                                                    //       orderController
                                                                    //           .setAddressIndex(
                                                                    //               index),
                                                                    // ),
                                                                    SizedBox(
                                                                        height: Dimensions
                                                                            .PADDING_SIZE_LARGE),
                                                                  ])
                                                                  : SizedBox(),

                                                              // Time Slot
                                                              // restController.restaurant.scheduleOrder
                                                              //     ? Column(
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment.start,
                                                              //         children: [
                                                              //             _tabTextIconIndexSelected != 1
                                                              //                 ? Text('delivery_time'.tr,
                                                              //                     style: robotoMedium)
                                                              //                 : Text('pickup_time'.tr,
                                                              //                     style: robotoMedium),
                                                              //             SizedBox(
                                                              //                 height: Dimensions
                                                              //                     .PADDING_SIZE_SMALL),
                                                              //             SizedBox(
                                                              //               height: 50,
                                                              //               child: ListView.builder(
                                                              //                 scrollDirection:
                                                              //                     Axis.horizontal,
                                                              //                 shrinkWrap: true,
                                                              //                 physics:
                                                              //                     BouncingScrollPhysics(),
                                                              //                 itemCount: 2,
                                                              //                 itemBuilder:
                                                              //                     (context, index) {
                                                              //                   return SlotWidget(
                                                              //                     title: index == 0
                                                              //                         ? 'today'.tr
                                                              //                         : 'tomorrow'.tr,
                                                              //                     isSelected: orderController
                                                              //                             .selectedDateSlot ==
                                                              //                         index,
                                                              //                     onTap: () =>
                                                              //                         orderController
                                                              //                             .updateDateSlot(
                                                              //                                 index),
                                                              //                   );
                                                              //                 },
                                                              //               ),
                                                              //             ),
                                                              //             SizedBox(
                                                              //                 height: Dimensions
                                                              //                     .PADDING_SIZE_SMALL),
                                                              //             SizedBox(
                                                              //               height: 50,
                                                              //               child: ((orderController
                                                              //                                   .selectedDateSlot ==
                                                              //                               0 &&
                                                              //                           _todayClosed) ||
                                                              //                       (orderController
                                                              //                                   .selectedDateSlot ==
                                                              //                               1 &&
                                                              //                           _tomorrowClosed))
                                                              //                   ? Center(
                                                              //                       child: Text(
                                                              //                           'restaurant_is_closed'
                                                              //                               .tr))
                                                              //                   : orderController
                                                              //                               .timeSlots !=
                                                              //                           null
                                                              //                       ? orderController
                                                              //                                   .timeSlots
                                                              //                                   .length >
                                                              //                               0
                                                              //                           ? ListView
                                                              //                               .builder(
                                                              //                               scrollDirection:
                                                              //                                   Axis.horizontal,
                                                              //                               shrinkWrap:
                                                              //                                   true,
                                                              //                               physics:
                                                              //                                   BouncingScrollPhysics(),
                                                              //                               itemCount:
                                                              //                                   orderController
                                                              //                                       .timeSlots
                                                              //                                       .length,
                                                              //                               itemBuilder:
                                                              //                                   (context,
                                                              //                                       index) {
                                                              //                                 return SlotWidget(
                                                              //                                   title: (index == 0 &&
                                                              //                                           orderController.selectedDateSlot == 0 &&
                                                              //                                           DateConverter.isAvailable(
                                                              //                                             restController.restaurant.openingTime,
                                                              //                                             restController.restaurant.closeingTime,
                                                              //                                           ))
                                                              //                                       ? 'now'.tr
                                                              //                                       : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                                              //                                           '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                                                              //                                   isSelected:
                                                              //                                       orderController.selectedTimeSlot ==
                                                              //                                           index,
                                                              //                                   onTap: () =>
                                                              //                                       orderController
                                                              //                                           .updateTimeSlot(index),
                                                              //                                 );
                                                              //                               },
                                                              //                             )
                                                              //                           : Center(
                                                              //                               child: Text(
                                                              //                                   'no_slot_available'
                                                              //                                       .tr))
                                                              //                       : Center(
                                                              //                           child:
                                                              //                               CircularProgressIndicator()),
                                                              //             ),
                                                              //             SizedBox(
                                                              //                 height: Dimensions
                                                              //                     .PADDING_SIZE_LARGE),
                                                              //           ])
                                                              //     : SizedBox(),

                                                              CustomTextField(
                                                                controller: _noteController,
                                                                hintText: 'additional_note'.tr,
                                                                maxLines: 3,
                                                                inputType: TextInputType.multiline,
                                                                inputAction: TextInputAction.newline,
                                                                capitalization:
                                                                TextCapitalization.sentences,
                                                              ),
                                                              // Coupon
                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_LARGE),

                                                              // Text('choose_payment_method'.tr,
                                                              //     style: robotoMedium),
                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_SMALL),
                                                              // _isCashOnDeliveryActive
                                                              //     ? PaymentButton(
                                                              //   icon: Images.cash_on_delivery,
                                                              //   title: 'cash_on_delivery'.tr,
                                                              //   subtitle:
                                                              //   'pay_your_payment_after_getting_food'
                                                              //       .tr,
                                                              //   index: 0,
                                                              // )
                                                              //     : SizedBox(),




                                                              //    Image.asset('assets/image/gpay.png'),
                                                              // adding google pay
                                                              //,

                                                              //    previous digital payment button
                                                              // _isDigitalPaymentActive
                                                              //     ?
                                                              // ? Row(children: [
                                                              //     PaymentBox(
                                                              //       icon: Images.googlepay,
                                                              //       index:
                                                              //           _isCashOnDeliveryActive
                                                              //               ? 1
                                                              //               : 0,
                                                              //     ),
                                                              //     SizedBox(
                                                              //       width: 10,
                                                              //     ),
                                                              //     PaymentBox(
                                                              //       icon: Images.stripe,
                                                              //       index:
                                                              //           _isCashOnDeliveryActive
                                                              //               ? 2
                                                              //               : 0,
                                                              //     ),
                                                              //     SizedBox(
                                                              //       width: 10,
                                                              //     ),
                                                              //     PaymentBox(
                                                              //       icon: Images.paypal,
                                                              //       index:
                                                              //           _isCashOnDeliveryActive
                                                              //               ? 3
                                                              //               : 0,
                                                              //     ),
                                                              //   ])
                                                              // : SizedBox(),
                                                              // GestureDetector(
                                                              //     onTap: () {
                                                              //       print("hello");
                                                              //     },
                                                              //     child: PaymentButton(
                                                              //       icon:
                                                              //           Images.digital_payment,
                                                              //       title: 'digital_payment'.tr,
                                                              //       subtitle:
                                                              //           'faster_and_safe_way'
                                                              //               .tr,
                                                              //       index:
                                                              //           1, //_isCashOnDeliveryActive ? 1 : 0
                                                              //     ),
                                                              //   )
                                                              // : SizedBox(),

                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_LARGE),

                                                              GetBuilder<CouponController>(
                                                                builder: (couponController) {
                                                                  return Row(children: [
                                                                    Expanded(
                                                                      child: SizedBox(
                                                                        height: 50,
                                                                        child: TextField(
                                                                          controller: _couponController,
                                                                          style: robotoRegular.copyWith(
                                                                              height: ResponsiveHelper
                                                                                  .isMobile(context)
                                                                                  ? null
                                                                                  : 2),
                                                                          decoration: InputDecoration(
                                                                            hintText:
                                                                            'enter_promo_code'.tr,
                                                                            hintStyle:
                                                                            robotoRegular.copyWith(
                                                                                color:
                                                                                Theme.of(context)
                                                                                    .hintColor),
                                                                            isDense: true,
                                                                            filled: true,
                                                                            enabled: couponController
                                                                                .discount ==
                                                                                0,
                                                                            fillColor: Colors.white,
                                                                            border: OutlineInputBorder(
                                                                              borderRadius:
                                                                              BorderRadius.horizontal(
                                                                                left: Radius.circular(
                                                                                    Get.find<LocalizationController>()
                                                                                        .isLtr
                                                                                        ? 10
                                                                                        : 1),
                                                                                right: Radius.circular(
                                                                                    Get.find<LocalizationController>()
                                                                                        .isLtr
                                                                                        ? 1
                                                                                        : 10),
                                                                              ),
                                                                              borderSide: BorderSide(
                                                                                  style: BorderStyle.none,
                                                                                  width: 1),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        String _couponCode =
                                                                        _couponController.text.trim();
                                                                        if (couponController.discount <
                                                                            1 &&
                                                                            !couponController
                                                                                .freeDelivery) {
                                                                          if (_couponCode.isNotEmpty &&
                                                                              !couponController
                                                                                  .isLoading) {
                                                                            couponController
                                                                                .applyCoupon(
                                                                                _couponCode,
                                                                                (_price - _discount) +
                                                                                    _addOns,
                                                                                _deliveryCharge,
                                                                                restController
                                                                                    .restaurant.id)
                                                                                .then((discount) {
                                                                              if (discount > 0) {
                                                                                showCustomSnackBar(
                                                                                  '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                                                                  isError: false,
                                                                                );
                                                                              }
                                                                            });
                                                                          } else if (_couponCode
                                                                              .isEmpty) {
                                                                            showCustomSnackBar(
                                                                                'enter_a_coupon_code'.tr);
                                                                          }
                                                                        } else {
                                                                          couponController
                                                                              .removeCouponData(true);
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        height: 50,
                                                                        width: 100,
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .primaryColor,
                                                                          // boxShadow: [
                                                                          //   BoxShadow(
                                                                          //       color: Colors.grey[
                                                                          //           Get.isDarkMode
                                                                          //               ? 800
                                                                          //               : 200],
                                                                          //       spreadRadius: 1,
                                                                          //       blurRadius: 5)
                                                                          // ],
                                                                          borderRadius:
                                                                          BorderRadius.horizontal(
                                                                            left: Radius.circular(
                                                                                Get.find<LocalizationController>()
                                                                                    .isLtr
                                                                                    ? 0
                                                                                    : 12),
                                                                            right: Radius.circular(
                                                                                Get.find<LocalizationController>()
                                                                                    .isLtr
                                                                                    ? 10
                                                                                    : 0),
                                                                          ),
                                                                        ),
                                                                        child: (couponController
                                                                            .discount <=
                                                                            0 &&
                                                                            !couponController
                                                                                .freeDelivery)
                                                                            ? !couponController.isLoading
                                                                            ? Text(
                                                                          'apply'.tr,
                                                                          style: robotoMedium
                                                                              .copyWith(
                                                                              color: Theme.of(
                                                                                  context)
                                                                                  .cardColor),
                                                                        )
                                                                            : CircularProgressIndicator(
                                                                            valueColor:
                                                                            AlwaysStoppedAnimation<
                                                                                Color>(
                                                                                Colors.white))
                                                                            : Icon(Icons.clear,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ]);
                                                                },
                                                              ),

                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_LARGE),
                                                              //SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                                                        Container(
                                                          // width: MediaQuery.of(context).size.width*0.3,
                                                          padding: EdgeInsets.all(8),
                                                          height: MySize.scaleFactorHeight*250,
                                                          width: 250,
                                                          // color: Colors.red,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(color: Colors.black.withOpacity(0.50)),
                                                            borderRadius: BorderRadius.circular(10),
                                                            // boxShadow: [
                                                            //   BoxShadow(
                                                            //     color: Colors.black.withOpacity(0.25),
                                                            //     offset: Offset(0,4),
                                                            //     blurRadius: 6,
                                                            //     spreadRadius: 4
                                                            //   )
                                                            // ]
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: MySize.size20),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('subtotal'.tr,
                                                                        style: robotoMedium),
                                                                    Text(
                                                                        PriceConverter.convertPrice(_subTotal),
                                                                        style: robotoMedium),
                                                                  ]),
                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_SMALL),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('discount'.tr,
                                                                        style: robotoRegular),
                                                                    Text(
                                                                        '${PriceConverter.convertPrice(_discount)}',
                                                                        style: robotoRegular),
                                                                  ]),
                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_SMALL),
                                                              (couponController.discount > 0 ||
                                                                  couponController.freeDelivery)
                                                                  ? Column(children: [
                                                                Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Text('coupon_discount'.tr,
                                                                          style: robotoRegular),
                                                                      (couponController.coupon !=
                                                                          null &&
                                                                          couponController
                                                                              .coupon
                                                                              .couponType ==
                                                                              'free_delivery')
                                                                          ? Text(
                                                                        'free_delivery'.tr,
                                                                        style: robotoRegular.copyWith(
                                                                            color: Theme.of(
                                                                                context)
                                                                                .primaryColor),
                                                                      )
                                                                          : Text(
                                                                        '${PriceConverter.convertPrice(couponController.discount)}',
                                                                        style: robotoRegular,
                                                                      ),
                                                                    ]),
                                                                SizedBox(
                                                                    height: Dimensions
                                                                        .PADDING_SIZE_SMALL),
                                                              ])
                                                                  : SizedBox(),
                                                              SizedBox(
                                                                  height: Dimensions.PADDING_SIZE_SMALL),
                                                              _tabTextIconIndexSelected == 0
                                                                  ? Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('delivery_fee'.tr,
                                                                        style: robotoRegular),
                                                                    (widget.onlydeliverfee == 0 || (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery'))
                                                                        ? Text(
                                                                      'free'.tr,
                                                                      style: robotoRegular
                                                                          .copyWith(
                                                                          color: Theme.of(
                                                                              context)
                                                                              .primaryColor),
                                                                    )
                                                                        : Text(
                                                                      '${PriceConverter.convertPrice(double.parse(widget.onlydeliverfee))}',
                                                                      style: robotoRegular,
                                                                    ),
                                                                  ])
                                                                  : SizedBox(),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                    Dimensions.PADDING_SIZE_SMALL),
                                                                child: Divider(
                                                                    thickness: 1,
                                                                    color: Theme.of(context)
                                                                        .hintColor
                                                                        .withOpacity(0.5)),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'total_amount'.tr,
                                                                      style: robotoMedium.copyWith(
                                                                          fontSize:
                                                                          Dimensions.fontSizeLarge,
                                                                          color: Theme.of(context)
                                                                              .primaryColor),
                                                                    ),
                                                                    Text(
                                                                      '${PriceConverter.convertPrice(_total)}',
                                                                      style: robotoMedium.copyWith(
                                                                          fontSize:
                                                                          Dimensions.fontSizeLarge,
                                                                          color: Theme.of(context)
                                                                              .primaryColor),
                                                                    ),
                                                                  ]),

                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),

                                                  ],
                                                ),
                                                orderController.isLoading? CircularProgressIndicator():    Container(
                                                    width: MySize.scaleFactorWidth*80,
                                                    // width: Dimensions.WEB_MAX_WIDTH,
                                                    alignment: Alignment.center,
                                                    padding:
                                                    EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                    child: CustomButton(
                                                        buttonText: 'Confirm Order'.tr,
                                                        onPressed: () {
                                                          ///

                                                          // confirmOrderTabbed = true;
                                                          bool _isAvailable = true;
                                                          DateTime _scheduleDate = DateTime.now();
                                                          if (orderController.timeSlots == null ||
                                                              orderController.timeSlots.length ==
                                                                  0) {
                                                            _isAvailable = false;
                                                          } else {
                                                            DateTime _date =
                                                            orderController.selectedDateSlot ==
                                                                0
                                                                ? DateTime.now()
                                                                : (Duration(days: 1));
                                                            DateTime _time = orderController
                                                                .timeSlots[orderController
                                                                .selectedTimeSlot]
                                                                .startTime;
                                                            _scheduleDate = DateTime(
                                                                _date.year,
                                                                _date.month,
                                                                _date.day,
                                                                _time.hour,
                                                                _time.minute + 1);

                                                            for (CartModel cart in _cartList) {
                                                              if (!DateConverter.isAvailable(
                                                                cart.product.availableTimeStarts,
                                                                cart.product.availableTimeEnds,
                                                                time: restController
                                                                    .restaurant.scheduleOrder
                                                                    ? _scheduleDate
                                                                    : null,
                                                              )) {
                                                                _isAvailable = false;
                                                                break;
                                                              }
                                                            }
                                                          }
                                                          if (_orderAmount <
                                                              restController
                                                                  .restaurant.minimumOrder) {
                                                            showCustomSnackBar(
                                                                '${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                                                          } else if ((orderController
                                                              .selectedDateSlot ==
                                                              0 &&
                                                              _todayClosed) ||
                                                              (orderController.selectedDateSlot ==
                                                                  1 &&
                                                                  _tomorrowClosed)) {
                                                            showCustomSnackBar(
                                                                'restaurant_is_closed'.tr);
                                                          } else if (orderController.timeSlots ==
                                                              null ||
                                                              orderController.timeSlots.length ==
                                                                  0) {
                                                            if (restController
                                                                .restaurant.scheduleOrder) {
                                                              showCustomSnackBar(
                                                                  'select_a_time'.tr);
                                                            } else {
                                                              showCustomSnackBar(
                                                                  'restaurant_is_closed'.tr);
                                                            }
                                                          }

                                                          // else if (!_isAvailable) {
                                                          //   showCustomSnackBar(
                                                          //       'one_or_more_products_are_not_available_for_this_selected_time'
                                                          //           .tr);
                                                          // }

                                                          else {
                                                            List<Cart> carts = [];

                                                            for (int index = 0; index < _cartList.length; index++) {
                                                              CartModel cart = _cartList[index];
                                                              List<int> _addOnIdList = [];
                                                              List<int> _addOnQtyList = [];

                                                              cart.addOnIds.forEach((addOn) {
                                                                _addOnIdList.add(addOn.id);
                                                                _addOnQtyList.add(addOn.quantity);
                                                              });

                                                              carts.add(Cart(
                                                                cart.isCampaign ? null : cart.product.id,
                                                                cart.isCampaign ? cart.product.id : null,
                                                                cart.discountedPrice.toString(),
                                                                '',
                                                                cart.variation,
                                                                cart.quantity,
                                                                _addOnIdList,
                                                                cart.addOns,
                                                                _addOnQtyList,
                                                                cart.sizeList, // Include list of sizes
                                                              ));
                                                            }

// Ensure that the 'carts' list is initialized before using it
                                                            if (carts.isEmpty) {
                                                              carts = []; // Initialize the list if it's null or empty
                                                            }

// Now you can use the 'carts' list without encountering the 'add' method on null error


                                                            // List<Cart> carts = [];
                                                            // for (int index = 0;
                                                            // index < _cartList.length;
                                                            // index++) {
                                                            //   CartModel cart = _cartList[index];
                                                            //   List<int> _addOnIdList = [];
                                                            //   List<int> _addOnQtyList = [];
                                                            //   cart.addOnIds.forEach((addOn) {
                                                            //     _addOnIdList.add(addOn.id);
                                                            //     _addOnQtyList.add(addOn.quantity);
                                                            //   });
                                                            //   carts.add(Cart(
                                                            //     cart.isCampaign
                                                            //         ? null
                                                            //         : cart.product.id,
                                                            //     cart.isCampaign
                                                            //         ? cart.product.id
                                                            //         : null,
                                                            //     cart.discountedPrice.toString(),
                                                            //     '',
                                                            //     cart.variation,
                                                            //     cart.quantity,
                                                            //     _addOnIdList,
                                                            //     cart.addOns,
                                                            //     _addOnQtyList,
                                                            //
                                                            //   ));
                                                            // }

                                                            this.orderController = orderController;
                                                            // locationController;

                                                            this.carts = carts;
                                                            this.restController = restController;
                                                            this._scheduleDate = _scheduleDate;
                                                            this._total = _total;
                                                            this._discount = _discount;
                                                            this._tax = _tax;
                                                            paymentMethodIndex = orderController.paymentMethodIndex;
                                                            print(
                                                                ">>> payment method index $paymentMethodIndex");
                                                            print(">>> payment  $_total");

                                                            if (paymentMethodIndex == 0) {
                                                              print("yahe say horha hai");
                                                              // order_amount,payment_method,order_type,restaurant_id,size

                                                              getOrderPlaced(
                                                                  this.orderController,
                                                                  // this.locationController,
                                                                  this.carts,
                                                                  this.restController,
                                                                  this._scheduleDate,
                                                                  this._total,
                                                                  this._discount,
                                                                  this._tax);
                                                            } else {}
                                                          }
                                                        })
                                                  // : confirmOrderTabbed != true

                                                )
                                                ///total
                                                ///
                                                ///


                                                /* Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('vat_tax'.tr, style: robotoRegular),
                            Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
                          ]),*/

                                              ]),
                                        )),
                                  ))),

                        ],
                      );
                      // : Center(child: CircularProgressIndicator());
                    });
                });



              });
            },
          )
        // : NotLoggedInScreen(),
      ),
    );
  }

  void getOrderPlaced(
      orderController,
      // locationController,
      carts,
      restController,
      _scheduleDate,
      _total,
      _discount,
      _tax,
      ) {
    // AddressModel _address = orderController.addressIndex == -1
    //     ? Get.find<LocationController>().getUserAddress()
    //     : locationController.addressList[orderController.addressIndex];
    /// placed order model give hard coded
    orderController.placeOrder(
        PlaceOrderBody(
          ///suggestionhere size etc
          size: AppConstants.sizeId,
          cart: carts,
          delivery_charge: double.parse(widget.onlydeliverfee),
          couponDiscountAmount: Get.find<CouponController>().discount,
          distance: 0.0,
          couponDiscountTitle: Get.find<CouponController>().discount > 0
              ? Get.find<CouponController>().coupon.title
              : null,
          scheduleAt: !restController.restaurant.scheduleOrder
              ? null
              : (orderController.selectedDateSlot == 0 &&
              orderController.selectedTimeSlot == 0)
              ? null
              : DateConverter.dateToDateAndTime(_scheduleDate),
          orderAmount: _total,
          orderNote: _noteController.text,
          orderType: 'take_away',
          // orderType: orderController.orderType,
          paymentMethod:'cash_on_delivery',

          // _isCashOnDeliveryActive
          //     ? orderController.paymentMethodIndex == 0
          //     ? 'cash_on_delivery'
          //     : 'cash_on_delivery'
          //     : 'digital_payment',
        //     ? orderController.paymentMethodIndex == 0
        // ? 'cash_on_delivery'
        //     : 'digital_payment'
        //     : 'digital_payment',
          couponCode: (Get.find<CouponController>().discount > 0 ||
              (Get.find<CouponController>().coupon != null &&
                  Get.find<CouponController>().freeDelivery))
              ? Get.find<CouponController>().coupon.code
              : null,
          restaurantId: _cartList[0].product.restaurantId,
          address: widget.address,
          // latitude: _address.latitude,
          // longitude: _address.longitude,
          // addressType: _address.addressType,
          // contactPersonName: _address.contactPersonName ??
          //     '${Get.find<UserController>().userInfoModel.fName} '
          //         '${Get.find<UserController>().userInfoModel.lName}',
          // contactPersonNumber: _address.contactPersonNumber ??
          //     Get.find<UserController>().userInfoModel.phone,
          discountAmount: _discount,
          taxAmount: _tax,
        ),
        _callback

    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    print("callback is going to success now $isSuccess");
    if (isSuccess) {
      if (widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      setState(() {
        paymentMethodIndex = Get.find<OrderController>().paymentMethodIndex;
      });
      print(
          '---index of paymentmethods ok----${Get.find<OrderController>().paymentMethodIndex}');

      if ((_isCashOnDeliveryActive &&
          Get.find<OrderController>().paymentMethodIndex == 0) ||
          (Get.find<OrderController>().paymentMethodIndex == 1)) {
        print("YES I am here >> going next ");
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success'));
      } else {
        print("NO NO! I am here");
        if (GetPlatform.isWeb) {
          Get.back();
        } else {
          print("on mobile  YES I am here");

          //    _show = F
          //    setState(() {

          //   });
          //  Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));
        }
      }
      if (is_user_charged) {
        Get.find<OrderController>().clearPrevData();
        Get.find<CouponController>().removeCouponData(false);
      }
    } else {
      print(" $message >NOT callback is going to success now $isSuccess");
      showCustomSnackBar(message);
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<bool> _exitApp(BuildContext context) async {
    return Get.dialog(
        PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
  }
}
