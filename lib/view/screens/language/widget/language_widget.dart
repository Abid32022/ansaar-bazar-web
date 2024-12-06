import 'package:ansarbazzarweb/controller/localization_controller.dart';
import 'package:ansarbazzarweb/data/model/response/language_model.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';

import '../../../../util/app_colors.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  LanguageWidget(
      {@required this.languageModel,
      @required this.localizationController,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          border: Border.all(width: 0.5),
        ),
        child: Stack(children: [
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                alignment: Alignment.center,
                child:
                    Image.asset(languageModel.imageUrl, width: 36, height: 36),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text(languageModel.languageName, style: robotoRegular),
            ]),
          ),
          localizationController.selectedIndex == index
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.check_circle,
                      color:AppColors.primarycolor, size: 25),
                )
              : SizedBox(),
        ]),
      ),
    );
  }
}
