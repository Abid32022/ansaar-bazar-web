import 'package:ansarbazzarweb/controller/cart_controller.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/app_colors.dart';

class CartWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool fromRestaurant;
  CartWidget({@required this.color, @required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.shopping_cart, size: size,
        color: color,
      ),
      GetBuilder<CartController>(builder: (cartController) {
        return cartController.cartList.length > 0 ? Positioned(
          top: -5, right: -5,
          child: Container(
            height: size < 20 ? 10 : size/2, width: size < 20 ? 10 : size/2, alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: fromRestaurant ? Theme.of(context).cardColor :AppColors.primarycolor
              ,border: Border.all(width: size < 20 ? 0.7 : 1, color: fromRestaurant ?Color(0xFF009f67) : Theme.of(context).cardColor),
            ),
            child: Text(
              cartController.cartList.length.toString(),
              style: robotoRegular.copyWith(
                fontSize: size < 20 ? size/3 : size/3.8,
                color: fromRestaurant ?Color(0xFF009f67) : Theme.of(context).cardColor,
              ),
            ),
          ),
        ) : SizedBox();
      }),
    ]);
  }
}
