import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  QuantityButton({@required this.isIncrement, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36, width: 36,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: isIncrement ?Color(0xFF009f67) : Colors.black.withOpacity(0.50)),
          color: isIncrement ?Color(0xFF009f67) : Theme.of(context).disabledColor.withOpacity(0.2),
        ),
        alignment: Alignment.center,
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          size: 15,
          color: isIncrement ? Theme.of(context).cardColor : Colors.black,
        ),
      ),
    );
  }
}