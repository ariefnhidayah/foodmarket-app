import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/theme.dart';

PreferredSizeWidget appBar({
  String title = '',
  String subtitle = '',
  required BuildContext context,
  String routeName = '/',
  List<Widget>? actions,
  Color? backgroundColor,
  Color? leadingIconColor,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? Colors.white,
    titleTextStyle: const TextStyle(color: textColor),
    toolbarHeight: 108,
    titleSpacing: 24,
    leading: routeName != '/'
        ? Container(
            margin: const EdgeInsets.only(
              left: 24,
              right: 10,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: leadingIconColor ?? textColor,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        : null,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: textStyleTheme().copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: textStyleTheme()
                    .copyWith(fontSize: 14, color: secondaryColor),
              )
            : const SizedBox(),
        const SizedBox(
          height: 24,
        ),
      ],
    ),
    actions: actions,
  );
}
