import 'dart:convert';
import 'package:country_code_picker/country_code.dart';
import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/data/model/body/signup_body.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _countryDialCode = "92";

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Container(
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
                  // Image.asset(Images.slogan, width: 200),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  //  Image.asset(Images.logo_name, width: 100),
                  //  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                  Text('sign_up'.tr.toUpperCase(),
                      style: robotoBlack.copyWith(fontSize: 20)),
                  SizedBox(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      CustomTextField(
                        hintText: 'first_name'.tr,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        prefixIcon: Images.user,
                        capitalization: TextCapitalization.words,
                        // prefixIcon: Images.user,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'last_name'.tr,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.user,
                        divider: true,
                      ),

                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                        divider: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("(Email is Optional)",style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(children: [

                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius:
                        //         BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //           color: Colors.grey[Get.isDarkMode ? 800 : 5],
                        //           spreadRadius: 0.9,
                        //           blurRadius: 0.2)
                        //     ],
                        //   ),
                        //   child: CodePickerWidget(
                        //     boxDecoration: BoxDecoration(
                        //       color: Color(0xff8B4512),
                        //     ),
                        //     onChanged: (CountryCode countryCode) {
                        //       _countryDialCode = countryCode.dialCode;
                        //     },
                        //     initialSelection: _countryDialCode,
                        //     favorite: [_countryDialCode],
                        //     //backgroundColor: Colors.grey,
                        //     showDropDownButton: true,
                        //     padding: EdgeInsets.zero,
                        //     showFlagMain: true,
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
                            child: CustomTextField(
                              prefixIcon: Images.phoneIcon,
                              hintText: 'phone'.tr,
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          maxlength: 11,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.phone,
                          divider: false,
                        )),
                      ]),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Divider(height: 1)),
                      SizedBox(
                        height: 17,
                      ),
                      CustomTextField(
                        hintText: 'password'.tr,
                        maxlength: 11,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        maxlength: 11,
                        isPassword: true,
                        onSubmit: (text) =>
                            (GetPlatform.isWeb && authController.acceptTerms)
                                ? _register(authController, _countryDialCode)
                                : null,
                      ),
                    ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  ConditionCheckBox(authController: authController),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  !authController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'sign_in'.tr,
                            transparent: true,
                            onPressed: () => Get.toNamed(
                                RouteHelper.getSignInRoute(RouteHelper.signUp)),
                          )),
                          Expanded(
                              child: CustomButton(
                            buttonText: 'sign_up'.tr,
                            onPressed: authController.acceptTerms
                                ? () =>
                                    _register(authController, _countryDialCode)
                                : null,
                          )),
                        ])
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(height: 15),

                  // SocialLoginWidget(),
                 // GuestButton(),
                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }


  String countrycode = "92";
  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    // String _numberWithCountryCode = countrydail + _phone;

    String _numberWithCountryCode = '+92' + _number;

    bool _isValid = GetPlatform.isWeb ? true : false;
    print("Country code is  ${_countryDialCode}");
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    // String _numberWithCountryCode = countryCode + _number;
    // bool _isValid = GetPlatform.isWeb ? true : false;
    // print("Country code is  ${_countryDialCode}");
    // if (!GetPlatform.isWeb) {
    //   try {
    //     PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
    //     _numberWithCountryCode = '+' +  countrycode + phoneNumber.nationalNumber;
    //     _isValid = true;
    //   } catch (e) {}
    // }

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }  else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
          fName: _firstName,
          lName: _lastName,
          email: _email,
          // phone: _numberWithCountryCode,
          phone: _phoneController.text,
          password: _password);

      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);

            Get.toNamed(RouteHelper.getSignInRoute('Sign-up'));

          } else {

            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));

          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
