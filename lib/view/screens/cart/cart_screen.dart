
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/util/my_size.dart';
import 'package:ansarbazzarweb/view/base/custom_button.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:ansarbazzarweb/view/screens/cart/widget/cart_product_widget.dart';

// import 'package:efood_multivendor/helper/date_converter.dart';
// import 'package:efood_multivendor/view/base/custom_button.dart';
// import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/coupon_controller.dart';
import '../../../data/model/response/product_model.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text_field.dart';
import '../../base/no_data_screen.dart';
import '../../base/not_logged_in_screen.dart';

class CartScreen extends StatefulWidget {
  final fromNav;

  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoggedIn;

  // TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {

      // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      // Get.find<OrderController>().getRunningOrders(1);
      // Get.find<OrderController>().getHistoryOrders(1);
    }
    // TODO: implement initState
    super.initState();
  }
  TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _validateAddress(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your delivery address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
  MySize().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          isBackButtonExist: (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
      body:  _isLoggedIn?
      GetBuilder<CartController>(
        builder: (cartController) {
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _total = 0;
          double _addOns = 0;
          double _discount = 0;
          cartController.cartList.forEach((cartModel) {
            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for (AddOns addOns in cartModel.product.addOns) {
                if (addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);

            _availableList.add(DateConverter.isAvailable(
                cartModel.product.availableTimeStarts,
                cartModel.product.availableTimeEnds));

            for (int index = 0; index < _addOnList.length; index++) {
              _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
            }

            _itemPrice = _itemPrice + (cartModel.discountedPrice * cartModel.quantity);
            _total = _total + (cartModel.price * cartModel.quantity);
            _discount = _discount + (cartModel.discountAmount * cartModel.quantity);

          });

          double _deliveryfee;

          // Check if the deliveryFeeList is not empty
          if (cartController.deliveryFeeList.isNotEmpty) {
            // Sort the list in descending order to get the highest number first
            cartController.deliveryFeeList.sort((a, b) => b.compareTo(a));
            // Assign the first element (highest number) to the _deliveryfee variable
            _deliveryfee = cartController.deliveryFeeList[0];
          } else {
            // If the list is empty, set _deliveryfee to a default value (0 or any other value)
            _deliveryfee = 0; // Default value when the list is empty
          }

          double _subTotal = _itemPrice + _addOns;
          _subTotal = _subTotal +_deliveryfee;
          if (cartController.cartList.length > 0) {
            return
              GetPlatform.isAndroid || GetPlatform.isIOS?
              Column(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.WEB_MAX_WIDTH,
                          child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product
                                  Container(
                                    // width: MySize.scaleFactorWidth*250,
                                    // color: Colors.yellow,
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: cartController.cartList.length,
                                          itemBuilder: (context, index) {
                                            return CartProductWidget(
                                              cart: cartController.cartList[index],
                                              cartIndex: index,
                                              addOns: _addOnsList[index],
                                              // isAvailable: _availableList[index]
                                              isAvailable: true,

                                            );
                                          },
                                        ),
                                        SizedBox(
                                            height: Dimensions.PADDING_SIZE_SMALL),

                                        TextFormField(
                                          controller: _addressController,
                                          maxLines: 4,
                                          style: TextStyle(color: Colors.black),
                                          maxLength: 50,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                            enabled: true,
                                            hintText: 'Delivery Address',
                                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                          ),
                                          validator: _validateAddress,
                                        ),
                                        SizedBox(
                                            height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                                      ],
                                    ),
                                  ),

                                  Container(
                                    // width: MySize.scaleFactorWidth*250,
                                    // color: Colors.red,
                                    child: Column(
                                      children: [

                                        // Total
                                        // SizedBox(height: MediaQuery.of(context).size.width*0.3,),
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('item_price'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  PriceConverter.convertPrice(_total),
                                                  style: robotoRegular),
                                            ]),

                                        SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Discounts',
                                                  style: robotoRegular),
                                              Text(
                                                  '${PriceConverter.convertPrice(_discount,)}',
                                                  // '${PriceConverter.convertPrice(_discount,)}',
                                                  style: robotoRegular),
                                            ]),
                                        SizedBox(height: 10,),
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Delivery Charges'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  '${_deliveryfee}',
                                                  // cartController.cartList[0].deliverycharges ,
                                                  style: robotoRegular),

                                            ]),
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
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('subtotal'.tr, style: robotoMedium),
                                              Text(PriceConverter.convertPrice(_subTotal),style: robotoMedium),
                                              // Text(PriceConverter.convertPrice(_subTotal+double.parse(cartController.cartList[0].deliverycharges)),
                                              //     style: robotoMedium),
                                            ]),
                                      ],
                                    ),
                                  ),


                                  ///

                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Dimensions.WEB_MAX_WIDTH,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomButton(
                      buttonText: 'Proceed_To_Checkout'.tr,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Address field is valid, proceed to checkout
                          Get.find<CouponController>().removeCouponData(false);
                          Get.toNamed(RouteHelper.getCheckoutRoute(
                            'cart',
                            deliveryFee: _subTotal,
                            onlyDeliveryFee: _deliveryfee,
                            address: _addressController.text,
                          ));
                        }

                        // if (_formKey.currentState!.validate()) {
                        //   // Form is valid, proceed to next step
                        //   String address = _addressController.text;
                        //   // Do something with the address
                        //   print('Address: $address');
                        // }
                      },
                    ),
                  ),
                ],
              ):
              Column(
              children: [
                Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    physics: BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product

                                    Text("Products",style: TextStyle(fontSize: MySize.size26,fontWeight: FontWeight.w600,color: Colors.black),),

                                SizedBox(height: MySize.size20,),


                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.5,
                                          // color: Colors.yellow,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: cartController.cartList.length,
                                                itemBuilder: (context, index) {
                                                  return CartProductWidget(
                                                    cart: cartController.cartList[index],
                                                    cartIndex: index,
                                                    addOns: _addOnsList[index],
                                                    // isAvailable: _availableList[index]
                                                    isAvailable: true,

                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                  height: Dimensions.PADDING_SIZE_SMALL),

                                              TextFormField(
                                                controller: _addressController,
                                                maxLines: 4,
                                                style: TextStyle(color: Colors.black),
                                                maxLength: 150,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  enabled: true,
                                                  hintText: 'Delivery Address',
                                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                ),
                                                validator: _validateAddress,
                                              ),
                                              SizedBox(
                                                  height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                                            ],
                                          ),
                                        ),
                                        ///prices etc
                                      ],
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.05,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                            Container(
                                          padding: EdgeInsets.all(8),
                                          height: MySize.scaleFactorHeight*300,
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // SizedBox(height: MediaQuery.of(context).size.width*0.3,),
                                              // Total
                                              Row(
                                                children: [
                                                  Text('Total Price',
                                                    style: TextStyle(fontSize: MySize.size25,color: Colors.black,fontWeight: FontWeight.w600),),
                                                ],
                                              ),

                                              // SizedBox(height: MySize.scaleFactorHeight*10,),

                                              Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('item_price'.tr,
                                                        style: robotoRegular),
                                                    Text(
                                                        PriceConverter.convertPrice(_total),
                                                        style: robotoRegular),
                                                  ]),
                                              // SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Discounts',
                                                        style: robotoRegular),
                                                    Text(
                                                        '${PriceConverter.convertPrice(_discount,)}',
                                                        // '${PriceConverter.convertPrice(_discount,)}',
                                                        style: robotoRegular),
                                                  ]),
                                              // SizedBox(height: 10,),
                                              Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Delivery Charges'.tr,
                                                        style: robotoRegular),
                                                    Text(
                                                        '${_deliveryfee}',
                                                        // cartController.cartList[0].deliverycharges ,
                                                        style: robotoRegular),

                                                  ]),
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
                                              Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('subtotal'.tr, style: robotoMedium),
                                                    Text(PriceConverter.convertPrice(_subTotal),style: robotoMedium),
                                                    // Text(PriceConverter.convertPrice(_subTotal+double.parse(cartController.cartList[0].deliverycharges)),
                                                    //     style: robotoMedium),
                                                  ]),
                                              // SizedBox(height: MediaQuery.of(context).size.width*0.5,),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),

                                ///

                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MySize.scaleFactorWidth*80,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                        buttonText: 'Proceed to Checkout'.tr,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // Address field is valid, proceed to checkout
                            Get.find<CouponController>().removeCouponData(false);
                            Get.toNamed(RouteHelper.getCheckoutRoute(
                              'cart',
                              deliveryFee: _subTotal,
                              onlyDeliveryFee: _deliveryfee,
                              address: _addressController.text,
                            ));
                          }

                          // if (_formKey.currentState!.validate()) {
                          //   // Form is valid, proceed to next step
                          //   String address = _addressController.text;
                          //   // Do something with the address
                          //   print('Address: $address');
                          // }
                        },
                      ),
                    ),
                    SizedBox(width: MySize.scaleFactorWidth*80,)
                  ],
                ),
              ],
            );

          } else {
            return NoDataScreen(isCart: true, text: '');
          }
        },
      )
          : NotLoggedInScreen(),
    );
  }
}

