import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code.dart';
import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/localization_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/helper/route_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_button.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/custom_text_field.dart';
import 'package:ansarbazzarweb/view/base/web_menu_bar.dart';
import 'package:ansarbazzarweb/view/screens/auth/widget/code_picker_widget.dart';
import 'package:ansarbazzarweb/view/screens/auth/widget/condition_check_box.dart';
import 'package:ansarbazzarweb/view/screens/auth/widget/guest_button.dart';
import 'package:ansarbazzarweb/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import '../../../util/app_colors.dart';
import '../restaurant/restaurant_screen.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  SignInScreen({@required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    ///commented it dont know what its means
    // _countryDialCode =
    //     Get.find<AuthController>().getUserCountryCode().isNotEmpty
    //         ? Get.find<AuthController>().getUserCountryCode()
    //         : CountryCode.fromCountryCode(
    //                 Get.find<SplashController>().configModel.country)
    //             .dialCode;
    // _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    // _passwordController.text =
    //     Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Get.to(()=> RestaurantScreen());
              // Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ResponsiveHelper.isDesktop(context)
            ? WebMenuBar()
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent)
                : null,
        body: SafeArea(
            child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: Container(
                  // color: Colors.white,
                  width: context.width > 700 ? 700 : context.width,
                  padding: context.width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : null,
                  decoration: context.width > 700
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        )
                      : null,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(children: [
                      Image.asset(Images.logo, width: 150),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      //Image.asset(Images.slogan, width: 200),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      //Image.asset(Images.logo_name, width: 100),
                      //SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                      Text('sign_in'.tr.toUpperCase(),
                          style: robotoBlack.copyWith(fontSize: 20)),
                      SizedBox(height: 50),

                      Container(
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        //   color: Theme.of(context).cardColor,
                        //   boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 150], spreadRadius: 1, blurRadius: 0.3)],
                        // ),
                        child: Column(children: [
                          Row(children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(
                            //         Dimensions.RADIUS_SMALL),
                            //     color: Colors.white,
                            //     boxShadow: [
                            //       BoxShadow(
                            //           color: Colors
                            //               .grey[Get.isDarkMode ? 800 : 150],
                            //           spreadRadius: 1,
                            //           blurRadius: 0.3)
                            //     ],
                            //   ),
                            //   child: CodePickerWidget(
                            //     boxDecoration: BoxDecoration(
                            //       color: Color(0xffa8957a),
                            //     ),
                            //     onChanged: (CountryCode countryCode) {
                            //       _countryDialCode = countryCode.dialCode;
                            //     },
                            //     initialSelection: _countryDialCode != null
                            //         ? _countryDialCode
                            //         : Get.find<LocalizationController>()
                            //             .locale
                            //             .countryCode,
                            //     favorite: [_countryDialCode],
                            //     // countryFilter: [_countryDialCode],
                            //     showDropDownButton: true,
                            //     padding: EdgeInsets.zero,
                            //     showFlagMain: true,
                            //     flagWidth: 30,
                            //     textStyle: robotoRegular.copyWith(
                            //       fontSize: Dimensions.fontSizeLarge,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  prefixIcon: Images.phoneIcon,
                                  hintText: '03xxxxxx90',
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  maxLines: 1,
                                  maxlength: 11,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.phone,
                                  divider: false,

                                )),
                          ]),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 10)),
                          CustomTextField(
                            hintText: 'password'.tr,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            maxlength: 11,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Images.lock,
                            isPassword: true,
                            onSubmit: (text) => (GetPlatform.isWeb &&
                                    authController.acceptTerms)
                                ? _login(authController)
                                : null,
                          ),
                        ]),
                      ),
                      SizedBox(height: 10),

                      Row(children: [
                        Expanded(
                          child: ListTile(
                            onTap: () => authController.toggleRememberMe(),
                            leading: Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  // set overlay color when the checkbox is being pressed
                                  return Color(0xff8B4512);
                                } else {
                                  // set overlay color when the checkbox is not being pressed
                                  return Color(0xff8B4512);
                                }
                              }),
                              activeColor:AppColors.primarycolor,
                              value: authController.isActiveRememberMe,
                              onChanged: (bool isChecked) =>
                                  authController.toggleRememberMe(),
                            ),
                            title: Text(
                              'remember_me'.tr,
                              style: TextStyle(color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                        ),
                        // TextButton(
                        //   onPressed: () => Get.toNamed(
                        //       RouteHelper.getForgotPassRoute(false, null)),
                        //   child: Text('${'forgot_password'.tr}?'),
                        // ),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      ConditionCheckBox(authController: authController),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      !authController.isLoading
                          ? Row(children: [
                              Expanded(
                                  child: CustomButton(
                                buttonText: 'sign_up'.tr,
                                transparent: true,
                                onPressed: () =>
                                    Get.toNamed(RouteHelper.getSignUpRoute()),
                              )),
                              Expanded(
                                  child: CustomButton(
                                buttonText: 'sign_in'.tr,
                                onPressed: authController.acceptTerms
                                    ? () =>
                                ///for web navigation
                                        _login(authController)
                                // Get.toNamed(RouteHelper.html)


                                    : null,

                              )),
                            ])
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 30),

                      // SocialLoginWidget(),

                     Center(child: GuestButton()),

                    ]);
                  }),
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
  void _login(AuthController authController) async {
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    // String _numberWithCountryCode = countryDialCode + _phone;
    String _numberWithCountryCode =  _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        // PhoneNumber phoneNumber =
        //     await PhoneNumberUtil().parse(_numberWithCountryCode);
        // _numberWithCountryCode =
        //     '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(_numberWithCountryCode, _password)
          .then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(_phone, _password,'');

          } else {
            authController.clearUserNumberAndPassword();
          }
          String _token = status.message.substring(1, status.message.length);
          // Get.toNamed(RouteHelper.getInitialRoute());
          Get.to(()=> RestaurantScreen());

          // Get.to(()=> DashboardScreen(pageIndex: 0, id: 1,));
          // Get.to(()=> DashboardScreen(pageIndex: 0, id: 1,));
          // if (Get.find<SplashController>().configModel.customerVerification) {
          //   List<int> _encoded = utf8.encode(_password);
          //   String _data = base64Encode(_encoded);
          //   Get.toNamed(RouteHelper.getInitialRoute());
          // } else {
          //   Get.toNamed(RouteHelper.getRestaurantReviewRoute(1));
          //   // Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
          // }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
  // void _login(AuthController authController) async {
  //   String _phone = _phoneController.text.trim();
  //   String _password = _passwordController.text.trim();
  //   // String _numberWithCountryCode = countryDialCode + _phone;
  //   // String _numberWithCountryCode =  _phone;
  //   bool _isValid = GetPlatform.isWeb ? true : false;
  //   // if (!GetPlatform.isWeb) {
  //   //   try {
  //   //
  //   //     // PhoneNumber phoneNumber =
  //   //     //     await PhoneNumberUtil().parse(_numberWithCountryCode);
  //   //     // _numberWithCountryCode =
  //   //     //     '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
  //   //     _isValid = true;
  //   //     // Get.to(()=>RestaurantScreen());
  //   //     if(kDebugMode){
  //   //       print('Hogea bhai');
  //   //     }
  //   //   } catch (e) {}
  //   // }
  //   if (_phone.isEmpty) {
  //     showCustomSnackBar('enter_phone_number'.tr);
  //   } else if (!_isValid) {
  //     showCustomSnackBar('invalid_phone_number'.tr);
  //   } else if (_password.isEmpty) {
  //     showCustomSnackBar('enter_password'.tr);
  //   } else if (_password.length < 6) {
  //     showCustomSnackBar('password_should_be'.tr);
  //   } else {
  //     authController.login(_phone, _password)
  //         .then((status) async {
  //       if (status.isSuccess) {
  //         Get.toNamed(RouteHelper.getInitialRoute());
  //         // if (authController.isActiveRememberMe) {
  //         //   authController.saveUserNumberAndPassword(_phone, _password,'');
  //         // } else {
  //         //   authController.clearUserNumberAndPassword();
  //         // }
  //         // String _token = status.message.substring(1, status.message.length);
  //         // if (Get.find<SplashController>().configModel.customerVerification) {
  //         //   List<int> _encoded = utf8.encode(_password);
  //         //   String _data = base64Encode(_encoded);
  //         //   Get.toNamed(RouteHelper.getInitialRoute());
  //         // } else {
  //         //   Get.toNamed(RouteHelper.getInitialRoute());
  //         //   // Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
  //         // }
  //       } else {
  //         showCustomSnackBar(status.message);
  //       }
  //     });
  //   }
  // }
}

// thought/processing/feelingemotions/alert/bydefault
