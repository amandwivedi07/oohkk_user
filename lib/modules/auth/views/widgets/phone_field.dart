import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/font_family.dart';
import 'package:getitgouser/shared/constants/theme_data.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    super.key,
    required this.hintText,
    required this.prefix,
    required this.hintTextColor,
    this.validator,
    this.inputType,
    this.hintTextFontSize,
    this.hintTextFontWeight,
    this.radius,
    this.onChanged,
    this.onSaved,
  });

  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String hintText;
  final String prefix;
  final Color hintTextColor;
  final double? hintTextFontSize;
  final FontWeight? hintTextFontWeight;
  final double? radius;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [ThemeClass().underBoxShadow],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextFormField(
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          keyboardType: widget.inputType,
          validator: widget.validator,
          style: kManropeSemiBold.copyWith(
              fontSize: kFont16, color: AppColors.blackColor),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  widget.prefix,
                  textAlign: TextAlign.center,
                  style: kPoppinsMedium.copyWith(
                      color: AppColors.blackColor, fontSize: kFont16),
                ),
              ),
              fillColor: AppColors.whiteColor,
              hintText: widget.hintText,
              hintStyle: kPoppinsRegular.copyWith(
                  color: widget.hintTextColor, fontSize: kFont16),
              filled: true,
              // errorBorder: ThemeClass().kInputBorder,
              focusedBorder: ThemeClass().kInputBorder,
              enabledBorder: ThemeClass().kInputBorder,
              border: ThemeClass().kInputBorder,
              disabledBorder: ThemeClass().kInputBorder),
        ));
  }
}
