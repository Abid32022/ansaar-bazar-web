import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/html_type.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  Widget build(BuildContext context) {
    String _data = htmlType == HtmlType.TERMS_AND_CONDITION
        ? Get.find<SplashController>().configModel.termsAndConditions
        : htmlType == HtmlType.ABOUT_US
            ? Get.find<SplashController>().configModel.aboutUs
            : htmlType == HtmlType.PRIVACY_POLICY
                ? Get.find<SplashController>().configModel.privacyPolicy
                : null;

    if (_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if (GetPlatform.isWeb) {

    }
    return Scaffold(
      appBar: CustomAppBar(
          title: htmlType == HtmlType.TERMS_AND_CONDITION
              ? 'terms_conditions'.tr
              : htmlType == HtmlType.ABOUT_US
                  ? 'about_us'.tr
                  : htmlType == HtmlType.PRIVACY_POLICY
                      ? 'privacy_policy'.tr
                      : 'no_data_found'.tr),
      body: Center(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          height: MediaQuery.of(context).size.height,
          color: GetPlatform.isWeb ? Colors.black : Colors.white,
          child: GetPlatform.isWeb
              ? Column(
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: SelectableText(
                        htmlType == HtmlType.TERMS_AND_CONDITION
                            ? 'terms_conditions'.tr
                            : htmlType == HtmlType.ABOUT_US
                                ? 'about_us'.tr
                                : htmlType == HtmlType.PRIVACY_POLICY
                                    ? 'privacy_policy'.tr
                                    : 'no_data_found'.tr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                        child: IgnorePointer(
                            child: HtmlElementView(
                                viewType: _viewID,
                                key: Key(htmlType.toString()))
                        )
                    ),
                  ],
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  child: HtmlWidget(
                    _data ?? '',
                    textStyle: TextStyle(color: Colors.black),
                    key: Key(htmlType.toString()),
                    onTapUrl: (String url) {
                      return launch(url);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
