import 'package:ansarbazzarweb/controller/order_controller.dart';
import 'package:ansarbazzarweb/helper/price_converter.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double charge;
  final bool isFree;
  DeliveryOptionButton({@required this.value, @required this.title, @required this.charge, @required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return InkWell(
          onTap: () => orderController.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: orderController.orderType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (String value) => orderController.setOrderType(value),
                activeColor:AppColors.primarycolor
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Text(title, style: robotoRegular),
              SizedBox(width: 5),

              Text(
                '(${(value == 'take_away' || isFree) ? 'free'.tr : PriceConverter.convertPrice(charge)})',
                style: robotoMedium,
              ),

            ],
          ),
        );
      },
    );
  }
}
