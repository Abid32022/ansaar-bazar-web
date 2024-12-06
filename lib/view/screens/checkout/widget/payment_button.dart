import 'package:ansarbazzarweb/controller/order_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int index;
  PaymentButton(
      {@required this.index,
      @required this.icon,
      @required this.title,
      @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () => orderController.setPaymentMethod(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              border: Border.all(width: 0.5),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey[Get.isDarkMode ? 800 : 150],
              //       blurRadius: 1,
              //       spreadRadius: 0.2)
              // ],
            ),
            child: ListTile(
              leading: Image.asset(
                icon,
                width: 40,
                height: 40,
                color: _selected
                    ?Color(0xFF009f67)
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              subtitle: Text(
                subtitle,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: _selected
                  ? Icon(Icons.check_circle,
                      color:Color(0xFF009f67))
                  : null,
            ),
          ),
        ),
      );
    });
  }
}
