import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool autoCorrect;
  final bool autoFocus;
  final Function()? onTap;
  final bool readonly;

  const TextFieldWidget({
    Key? key,
    this.hintText = '',
    this.onChanged,
    this.isPassword = false,
    this.keyboardType,
    this.errorText,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.autoCorrect = false,
    this.autoFocus = false,
    this.onTap,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onTap: onTap,
          keyboardType: keyboardType,
          obscureText: isPassword,
          onChanged: onChanged,
          autocorrect: autoCorrect,
          autofocus: autoFocus,
          readOnly: readonly,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorText: errorText != null && errorText!.isNotEmpty ? "" : null,
          ),
        ),
        errorText != null && errorText!.isNotEmpty
            ? Container(
                padding: const EdgeInsets.only(
                  left: 5,
                  top: 3,
                ),
                child: Text(
                  errorText!,
                  style: const TextStyle(color: dangerColor),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
