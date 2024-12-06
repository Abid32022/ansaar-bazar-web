import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isButtonActive;
  final Function onTap;
  ProfileButton(
      {@required this.icon,
      @required this.title,
      @required this.onTap,
      this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
          vertical: isButtonActive != null
              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
              : Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            border: Border.all(width: 0.5)),
        child: Row(children: [
          Icon(
            icon,
            size: 25,
            color: Colors.black,
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child: Text(title, style: robotoRegular)),
          isButtonActive != null
              ? Switch(
                  value: isButtonActive,
                  onChanged: (bool isActive) => onTap(),
                  activeColor:AppColors.primarycolor,
                  activeTrackColor:
                     Color(0xFF009f67).withOpacity(0.5),
                )
              : SizedBox(),
        ]),
      ),
    );
  }
}
