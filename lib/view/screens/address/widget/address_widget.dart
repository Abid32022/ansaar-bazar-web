import 'package:ansarbazzarweb/data/model/response/address_model.dart';
import 'package:ansarbazzarweb/helper/responsive_helper.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;
  AddressWidget(
      {@required this.address,
      @required this.fromAddress,
      this.onRemovePressed,
      this.onEditPressed,
      this.onTap,
      this.fromCheckout = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
              ? Dimensions.PADDING_SIZE_DEFAULT
              : Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: fromCheckout ? null : Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            border: fromCheckout
                ? Border.all(color: Theme.of(context).disabledColor, width: 1)
                : null,
            boxShadow: fromCheckout
                ? null
                : [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 50],
                        blurRadius: 0.5,
                        spreadRadius: 0.5)
                  ],
          ),
          child: Row(children: [
            Icon(
              address.addressType == 'home'
                  ? Icons.home_filled
                  : address.addressType == 'office'
                      ? Icons.work
                      : Icons.location_on,
              size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
              color:AppColors.primarycolor
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.addressType.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      address.address,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).disabledColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            ),
            // fromAddress ? IconButton(
            //   icon: Icon(Icons.edit, color: Colors.blue, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
            //   onPressed: onEditPressed,
            // ) : SizedBox(),
            fromAddress
                ? IconButton(
                    icon: Icon(Icons.delete,
                        color: Colors.red,
                        size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
                    onPressed: onRemovePressed,
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
