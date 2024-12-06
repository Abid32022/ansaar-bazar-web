// import 'dart:convert';
// import 'package:ansarbazzarweb/controller/auth_controller.dart';
// import 'package:ansarbazzarweb/controller/coupon_controller.dart';
// import 'package:ansarbazzarweb/controller/location_controller.dart';
// import 'package:ansarbazzarweb/controller/order_controller.dart';
// import 'package:ansarbazzarweb/controller/splash_controller.dart';
// import 'package:ansarbazzarweb/controller/user_controller.dart';
// import 'package:ansarbazzarweb/data/model/body/place_order_body.dart';
// import 'package:ansarbazzarweb/data/model/response/address_model.dart';
// import 'package:ansarbazzarweb/data/model/response/cart_model.dart';
// import 'package:ansarbazzarweb/data/model/response/order_model.dart';
// import 'package:ansarbazzarweb/helper/date_converter.dart';
// import 'package:ansarbazzarweb/helper/route_helper.dart';
// import 'package:ansarbazzarweb/util/dimensions.dart';
// import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
// import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
// import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
// import 'package:ansarbazzarweb/view/screens/address/widget/address_widget.dart';
// import 'package:ansarbazzarweb/view/screens/checkout/widget/payment_failed_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// class CheckoutScreen extends StatefulWidget {
//   final List<CartModel> cartList;
//   final OrderModel orderModel;
//   final bool fromCart;
//   CheckoutScreen(
//       {@required this.fromCart,
//       @required this.cartList,
//       @required this.orderModel});
//
//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   bool is_user_charged = false;
//   var _tabTextIconIndexSelected = 0;
//   Map<String, dynamic> paymentIntentData;
//   bool _show = false;
//   int paymentMethodIndex = 0;
//   OrderController orderController;
//   LocationController locationController;
//   List<Cart> carts;
//   //RestaurantController restController;
//   DateTime _scheduleDate;
//   double _total;
//   double _discount;
//   double _tax;
//
//   var _listIconTabToggle = [
//     Icons.delivery_dining,
//     Icons.person,
//   ];
//   var _listGenderText = ["Delivery", "Pick-Up"];
//
//   final TextEditingController _couponController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();
//   double _taxPercent = 0;
//   double _totalToPay = 0;
//   bool confirmOrderTabbed = false;
//   bool _isCashOnDeliveryActive;
//   bool _isDigitalPaymentActive;
//   bool _isLoggedIn;
//   List<CartModel> _cartList;
//
//   @override
//   void initState() {
//     super.initState();
//
//
//     _isLoggedIn = Get.find<AuthController>().isLoggedIn();
//     if (_isLoggedIn) {
//       if (Get.find<UserController>().userInfoModel == null) {
//         Get.find<UserController>().getUserInfo();
//       }
//       if (Get.find<LocationController>().addressList == null) {
//         Get.find<LocationController>().getAddressList();
//       }
//       _isCashOnDeliveryActive =
//           Get.find<SplashController>().configModel.cashOnDelivery;
//       _isDigitalPaymentActive =
//           Get.find<SplashController>().configModel.digitalPayment;
//     }
//   }
//
//   // void initialiseStripe() async {
//   //   WidgetsFlutterBinding.ensureInitialized();
//   //
//   //   Stripe.publishableKey =
//   //       // "pk_live_51JCskPGJw4LwnASwj8uzAK4PxhtFuAX8YLuLoTHpMMymSAVxaTv84NcTwNCTsVYXmz20B4eivhLWw8FSJwsKXCnw001raIyiZz";
//   //       "pk_test_51JCskPGJw4LwnASwQnWvlFZPtqiSLhMqbvQfxb8nILiPySlXNvxwiDN5FvFHAOjTTBu0CZ9OrngpN3Xa0NwqFmx400hALvW7f2";
//   //   await Stripe.instance.applySettings();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _exitApp(context),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(title: 'checkout'.tr),
//         body: _isLoggedIn
//             ? GetBuilder<LocationController>(builder: (locationController) {
//                 List<DropdownMenuItem<int>> _addressList = [];
//                 _addressList.add(DropdownMenuItem<int>(
//                     value: -1,
//                     child: SizedBox(
//                       width: context.width > Dimensions.WEB_MAX_WIDTH
//                           ? Dimensions.WEB_MAX_WIDTH - 50
//                           : context.width - 50,
//                       child: AddressWidget(
//                         address:
//                             Get.find<LocationController>().getUserAddress(),
//                         fromAddress: false,
//                         fromCheckout: true,
//                       ),
//                     )));
//                 if (locationController.addressList != null) {
//                   for (int index = 0;
//                       index < locationController.addressList.length;
//                       index++) {
//                     if (locationController.addressList[index].zoneId ==
//                         Get.find<LocationController>()
//                             .getUserAddress()
//                             .zoneId) {
//                       _addressList.add(DropdownMenuItem<int>(
//                           value: index,
//                           child: SizedBox(
//                             width: context.width > Dimensions.WEB_MAX_WIDTH
//                                 ? Dimensions.WEB_MAX_WIDTH - 50
//                                 : context.width - 50,
//                             child: AddressWidget(
//                               address: locationController.addressList[index],
//                               fromAddress: false,
//                               fromCheckout: true,
//                             ),
//                           )));
//                     }
//                   }
//                 }
//                 return Container();
//               })
//             : NotLoggedInScreen(),
//         //   bottomSheet: _showBottomSheet(_totalToPay),
//       ),
//     );
//   }
//
//   void getOrderPlaced(orderController, locationController, carts,
//       restController, _scheduleDate, _total, _discount, _tax) {
//     AddressModel _address = orderController.addressIndex == -1
//         ? Get.find<LocationController>().getUserAddress()
//         : locationController.addressList[orderController.addressIndex];
//     orderController.placeOrder(
//         PlaceOrderBody(
//           cart: carts,
//           couponDiscountAmount: Get.find<CouponController>().discount,
//           distance: orderController.distance,
//           couponDiscountTitle: Get.find<CouponController>().discount > 0
//               ? Get.find<CouponController>().coupon.title
//               : null,
//           scheduleAt: !restController.restaurant.scheduleOrder
//               ? null
//               : (orderController.selectedDateSlot == 0 &&
//                       orderController.selectedTimeSlot == 0)
//                   ? null
//                   : DateConverter.dateToDateAndTime(_scheduleDate),
//           orderAmount: _total,
//           orderNote: _noteController.text,
//           orderType: orderController.orderType,
//           paymentMethod: _isCashOnDeliveryActive
//               ? orderController.paymentMethodIndex == 0
//                   ? 'cash_on_delivery'
//                   : 'digital_payment'
//               : 'digital_payment',
//           couponCode: (Get.find<CouponController>().discount > 0 ||
//                   (Get.find<CouponController>().coupon != null &&
//                       Get.find<CouponController>().freeDelivery))
//               ? Get.find<CouponController>().coupon.code
//               : null,
//           restaurantId: _cartList[0].product.restaurantId,
//           address: _address.address,
//           latitude: _address.latitude,
//           longitude: _address.longitude,
//           addressType: _address.addressType,
//           contactPersonName: _address.contactPersonName ??
//               '${Get.find<UserController>().userInfoModel.fName} '
//                   '${Get.find<UserController>().userInfoModel.lName}',
//           contactPersonNumber: _address.contactPersonNumber ??
//               Get.find<UserController>().userInfoModel.phone,
//           discountAmount: _discount,
//           taxAmount: _tax,
//         ),
//         _callback);
//   }
//
//   Widget _showBottomSheet(double _totalToPay) {
//     print("index of payment method $paymentMethodIndex");
//
//     print("show is $_show");
//     if (_show) {
//       if (paymentMethodIndex == 1) {
//         return BottomSheet(
//           onClosing: () {},
//           builder: (context) {
//             return Container(
//               height: 100,
//               width: double.infinity,
//               color: Colors.grey.shade200,
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//
//                   ElevatedButton(
//                     child: Text("Close"),
//                     style: ElevatedButton.styleFrom(
//                       onPrimary: Colors.white,
//                       primary: Colors.green,
//                     ),
//                     onPressed: () {
//                       _show = false;
//                       setState(() {});
//                     },
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       }
//       if (paymentMethodIndex == 2) {
//         //initialiseStripe();
//
//         return BottomSheet(
//           onClosing: () {
//             confirmOrderTabbed = false;
//           },
//           builder: (context) {
//             return Container(
//               height: 100,
//               width: double.infinity,
//               color: Colors.white,
//               alignment: Alignment.center,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 90,
//                   ),
//                   ElevatedButton(
//                     child: Text(
//                       "Pay",
//                       style: TextStyle(
//                         color: Colors.deepOrangeAccent,
//                         fontSize: 30,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       onPrimary: Colors.deepOrangeAccent,
//                       primary: Colors.black87,
//                     ),
//                     onPressed: () async {
//                       //        await makePayment();
//                     },
//                   ),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   Text(
//                     _totalToPay.toString(),
//                     style: TextStyle(
//                       color: Colors.deepOrangeAccent,
//                       fontSize: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }
//     } else {
//       return null;
//     }
//   }
//
//   void _callback(bool isSuccess, String message, String orderID) async {
//     if (isSuccess) {
//       Get.find<OrderController>().stopLoader();
//       setState(() {
//         paymentMethodIndex = Get.find<OrderController>().paymentMethodIndex;
//       });
//       print(
//           '---index of paymentmethods----${Get.find<OrderController>().paymentMethodIndex}');
//       if (_isCashOnDeliveryActive &&
//           Get.find<OrderController>().paymentMethodIndex == 0) {
//         print("YES I am here");
//         Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success'));
//       } else {
//         print("NO NO! I am here");
//         if (GetPlatform.isWeb) {
//           Get.back();
//
//         } else {
//           print("on mobile  YES I am here");
//
//           //    _show = true;
//           //    setState(() {
//
//           //   });
//           //  Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));
//         }
//       }
//       if (is_user_charged) {
//         Get.find<OrderController>().clearPrevData();
//         Get.find<CouponController>().removeCouponData(false);
//       }
//     } else {
//       showCustomSnackBar(message);
//     }
//   }
//
//   void makepay() async {
//     //initialiseStripe();
//     //await makePayment();
//   }
//
//   // Future<void> makePayment() async {
//   //   try {
//   //     paymentIntentData = await createPaymentIntent(
//   //         _totalToPay.toString(), 'GBP'); //json.decode(response.body);
//   //     // print('Response body==>${response.body.toString()}');
//   //     await Stripe.instance
//   //         .initPaymentSheet(
//   //             paymentSheetParameters: SetupPaymentSheetParameters(
//   //                 paymentIntentClientSecret: paymentIntentData['client_secret'],
//   //                 //Todo: comment paymnet method
//   //                 // applePay: true,
//   //                 // googlePay: true,
//   //                 // testEnv: true,
//   //                 // style: ThemeMode.dark,
//   //                 // merchantCountryCode: 'UK',
//   //                 merchantDisplayName: 'Ansaar Bazar'))
//   //         .then((value) {});
//   //
//   //     ///now finally display payment sheeet
//   //
//   //     // displayPaymentSheet();
//   //   } catch (e, s) {
//   //     print('exception:$e$s');
//   //   }
//   // }
//
//   // displayPaymentSheet() async {
//   //   try {
//   //     await Stripe.instance
//   //         .presentPaymentSheet(
//   //             parameters: PresentPaymentSheetParameters(
//   //       clientSecret: paymentIntentData['client_secret'],
//   //       confirmPayment: true,
//   //     ),)
//   //         .then((newValue) {
//   //       print('payment intent' + paymentIntentData['id'].toString());
//   //       print('payment intent' + paymentIntentData['client_secret'].toString());
//   //       print('payment intent' + paymentIntentData['amount'].toString());
//   //       print('payment intent' + paymentIntentData.toString());
//   //       //orderPlaceApi(paymentIntentData!['id'].toString());
//   //       is_user_charged = true;
//   //       print("---- PAID PAID PAID");
//   //       ScaffoldMessenger.of(context)
//   //           .showSnackBar(SnackBar(content: Text("paid successfully")));
//   //
//   //       paymentIntentData = null;
//   //     }).onError((error, stackTrace) {
//   //       print("---- NO PAID NO PAID NO PAID");
//   //       is_user_charged = false;
//   //       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
//   //     });
//   //
//   //     print("user payment status $is_user_charged");
//   //     if (is_user_charged) {
//   //       getOrderPlaced(
//   //           this.orderController,
//   //           this.locationController,
//   //           this.carts,
//   //           this.restController,
//   //           this._scheduleDate,
//   //           this._total,
//   //           this._discount,
//   //           this._tax);
//   //     }
//   //   } on StripeException catch (e) {
//   //     is_user_charged = false;
//   //     print("---- NO PAID NO PAID NO PAID");
//   //     print('Exception/DISPLAYPAYMENTSHEET==> $e');
//   //     print("user payment status $is_user_charged");
//   //     showDialog(
//   //         context: context,
//   //         builder: (_) => AlertDialog(
//   //               content: Text("Cancelled "),
//   //             ));
//   //   } catch (e) {
//   //     print('$e');
//   //   }
//   // }
//
//   //  Future<Map<String, dynamic>>
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       print("-- total to pay ****** ${_totalToPay.toString()}");
//       Map<String, dynamic> body = {
//         'amount': _totalToPay.toString(),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       print(body);
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization':
//                 'Bearer sk_test_51JCskPGJw4LwnASwJERnuogL4q8PUP3b6Bhaq9jCatRtCA32vSRzI7VyktZIGv2423ZZEU4F3aremQI6QnujK4dl00zCaIVbyD',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//
//       print('Create Intent reponse ===> ${response.body.toString()}');
//       print(" SUSCCESS of carged or not ");
//       return jsonDecode(response.body);
//     } catch (err) {
//       print(" Failure  - confimed not charged");
//       is_user_charged = false;
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   calculateAmount(String amount) {
//     final a = (int.parse(amount)) * 100;
//     return a.toString();
//   }
//
//   Future<bool> _exitApp(BuildContext context) async {
//     return Get.dialog(
//         PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
//   }
// }
