import 'package:flutter/material.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/dimensions.dart';
import 'package:getitgouser/shared/constants/font_family.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.onPressed,
      required this.buttonTitle,
      this.lpadding = Dimensions.padding16,
      this.rpadding = Dimensions.padding16,
      this.tpadding = Dimensions.padding16,
      this.bpadding = Dimensions.padding16,
      this.fontSize = kFont18,
      this.fontWeight = FontWeight.w600,
      this.elevation = 5.0,
      this.borderRadius = 20.0,
      this.textColor = Colors.white,
      this.buttonBackgroundColor = AppColors.kPrimaryColor,
      this.infiteWidth = true,
      this.isDisabled = false,
      this.filled = true});

  final GestureTapCallback onPressed;
  final String buttonTitle;

  final double elevation;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  Color buttonBackgroundColor;
  final double lpadding;
  final double rpadding;
  final double bpadding;
  final double tpadding;
  final bool infiteWidth;
  final bool isDisabled;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      width: infiteWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: filled
            ? ElevatedButton.styleFrom(
                backgroundColor:
                    isDisabled ? AppColors.greyColor : buttonBackgroundColor,
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ))
            : ElevatedButton.styleFrom(
                backgroundColor: AppColors.whiteColor,
                side: BorderSide(color: buttonBackgroundColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            lpadding,
            tpadding,
            rpadding,
            bpadding,
          ),
          child: Text(
            buttonTitle,
            style: kManrope.copyWith(
                color: textColor, fontSize: fontSize, fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }
}
