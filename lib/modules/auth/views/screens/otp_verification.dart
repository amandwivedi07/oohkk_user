import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'package:getitgouser/modules/auth/controllers/auth_controller.dart';
import 'package:getitgouser/modules/auth/views/screens/signup_screen.dart';
import 'package:getitgouser/modules/home/view/home_view.dart';
import 'package:getitgouser/shared/constants/assets.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/dimensions.dart';
import 'package:getitgouser/shared/constants/font_family.dart';
import 'package:getitgouser/shared/constants/theme_data.dart';
import 'package:getitgouser/shared/helper/widgets/buttons.dart';

import '../../models/user.dart';

class OtpVerificationView extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationView({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final authController = Get.find<AuthController>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  int secondsRemaining = 60;
  bool enableResend = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  void loginAction() async {
    Get.offAll(const SignUpScreen());
    // focusNode.unfocus();
    // User? user = await authController.authenticate(pinController.text);
    // log(user.toString());
    // if (user == null) {
    //   return;
    // }
    // if (user.name == null) {
    //   Get.offAll(const SignUpScreen());
    // } else {
    //   Get.offAll(const HomeView());
    // }
  }

  void _resedOtp() async {
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
    await authController.verifyPhoneNumber(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: kPoppinsMedium.copyWith(
        fontSize: kFont20,
        color: AppColors.blackColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [ThemeClass().underBoxShadow],
      ),
    );

    String protectedPhoneString =
        widget.phoneNumber.replaceRange(0, 8, '********');

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       const Padding(
      //         padding: EdgeInsets.all(8.0),
      //         child: Text(
      //             'By tapping the arrow below, you agree to the Terms of Use and acknowledge that you have read the Privacy Policy.'),
      //       ),
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: CustomButton(
      //               fontSize: kFont19,
      //               fontWeight: FontWeight.w600,
      //               onPressed: loginAction,

      //               // () {
      //               //   Get.to(const SignUpScreen());
      //               // },

      //               buttonTitle: 'Verify'.tr,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: Dimensions.pagePadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height / 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter the 6-digit code sent to you at',
                          style: GoogleFonts.poppins(
                              fontSize: 21, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(widget.phoneNumber,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),
                  // Row(
                  //   children: [
                  //     const Expanded(child: SizedBox()),
                  //     Expanded(
                  //       flex: 3,
                  //       child: Text(
                  //         'otpSendMobileText'.trParams(
                  //             {'phoneNumber': '+91$protectedPhoneString'}),
                  //         // '${'Code has been send to '.tr} +91$protectedPhoneString',
                  //         textAlign: TextAlign.center,
                  //         style: kManrope.copyWith(
                  //             color: Colors.black,
                  //             fontSize: kFont15,
                  //             fontWeight: FontWeight.w300),
                  //         maxLines: 3,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     const Expanded(child: SizedBox()),
                  //   ],
                  // ),
                  const SizedBox(height: Dimensions.padding16),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.padding12),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        autofocus: true,
                        errorText: 'Wrong OTP entered. Please try again'.tr,
                        errorTextStyle: kPoppinsRegular.copyWith(
                            fontSize: kFont13, color: AppColors.redColor),
                        controller: pinController,
                        length: 6,
                        focusNode: focusNode,
                        onCompleted: (pin) {
                          if (pin.length == 6) {
                            loginAction();
                          }
                        },
                        onSubmitted: (pin) {
                          if (pin.length == 6) {
                            loginAction();
                          }
                        },
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        validator: (pin) {
                          if (pin?.length == 6) {
                            return null;
                          }
                          return '6 digits';
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 1,
                              height: 22,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          textStyle: kPoppinsMedium.copyWith(
                            fontSize: kFont20,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: enableResend ? _resedOtp : () {},
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: enableResend
                                    ? 'Resend Code '.tr
                                    : 'Resend Code In'.tr,
                                style: kPoppinsRegular.copyWith(
                                    fontSize: kFont14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400),
                              ),
                              // TextSpan(
                              //   text: enableResend ? '' : ' In '.tr,
                              //   style: kPoppinsRegular.copyWith(
                              //       fontSize: kFont14,
                              //       fontWeight: FontWeight.w400),
                              // ),
                              TextSpan(
                                text:
                                    enableResend ? '' : ' 00:$secondsRemaining',
                                style: kPoppinsRegular.copyWith(
                                    fontSize: kFont14,
                                    color: AppColors.buttonColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: Dimensions.padding12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'By tapping the arrow below, you agree to the Terms of Use and acknowledge that you have read the Privacy Policy.'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              fontSize: kFont19,
                              fontWeight: FontWeight.w600,
                              onPressed: loginAction,

                              // () {
                              //   Get.to(const SignUpScreen());
                              // },

                              buttonTitle: 'Verify'.tr,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
