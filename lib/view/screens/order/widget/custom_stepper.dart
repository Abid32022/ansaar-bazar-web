import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;

  CustomStepper(
      {@required this.title,
      @required this.isActive,
      @required this.haveLeftBar,
      @required this.haveRightBar,
      @required this.rightActive});

  @override
  Widget build(BuildContext context) {
    Color _color = isActive
        ?Color(0xFF009f67)
        : Colors.grey;
    Color _right = rightActive
        ?Color(0xFF009f67)
        : Colors.grey;

    return Expanded(
      child: Column(children: [
        Row(children: [
          Expanded(
              child: haveLeftBar
                  ? Divider(color: _color, thickness: 2)
                  : SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isActive ? 0 : 5),
            child: Icon(isActive ? Icons.check_circle : Icons.blur_circular,
                color: _color, size: isActive ? 25 : 15),
          ),
          Expanded(
              child: haveRightBar
                  ? Divider(color: _right, thickness: 2)
                  : SizedBox()),
        ]),
        Text(
          title + '\n',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(
              color: _color, fontSize: Dimensions.fontSizeExtraSmall),
        ),
      ]),
    );
  }
}
