import 'package:flutter/material.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/font_family.dart';

class CustomTextFormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  final String hintText;
  final TextInputType keyboardType;
  final double fontSize;
  final double borderRadius;
  final FontWeight fontWeight;
  final FontWeight hintTextFontWeight;
  final double prefixFontSize;
  final FontWeight prefixFontWeight;
  final Color hintTextColor;
  final double blurRadius;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextFormInputField({
    Key? key,
    required this.controller,
    this.validator,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fontSize = kFont14,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w500,
    this.hintTextFontWeight = FontWeight.w400,
    this.prefixFontSize = kFont16,
    this.prefixFontWeight = FontWeight.w400,
    this.hintTextColor = const Color(0xFF787878),
    this.blurRadius = 4,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: kManrope.copyWith(fontSize: fontSize, fontWeight: fontWeight),
      showCursor: true,
      cursorColor: AppColors.blackColor,
      cursorHeight: fontSize,
      decoration: InputDecoration(
          labelText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColors.buttonColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Color(0xffDADADA)),
          ),
          prefixIcon: prefixIcon,
          hintTextDirection: TextDirection.ltr,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: kManropeRegular.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
              color: hintTextColor)),
    );
  }
}
