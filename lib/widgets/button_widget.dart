import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';

class ButtonWidget extends StatelessWidget {
  final double? elevation;
  final Function()? onPress;
  final double? height;
  final Color? color;
  final Widget child;
  final double? width;

  const ButtonWidget({
    Key? key,
    this.elevation,
    this.onPress,
    this.height,
    this.color,
    required this.child,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: ElevatedButton(
        onPressed: onPress,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color ?? primaryColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // <-- Radius
          ),
        ),
      ),
    );
  }
}
