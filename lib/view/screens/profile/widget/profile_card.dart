import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String data;
  ProfileCard({@required this.data, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Colors.white,
        border: Border.all(width: 0.5),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(data,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color:AppColors.primarycolor
            )),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).disabledColor,
            )),
      ]),
    ));
  }
}
