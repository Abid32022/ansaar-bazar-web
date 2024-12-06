import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  final Text name;
  BottomNavItem({@required this.iconData, this.onTap, this.isSelected = false, this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon: Icon(iconData, color: isSelected ? Colors.white : Colors.white.withOpacity(0.65), size: 25),
        onPressed: onTap,

      ),
    );
  }
}
