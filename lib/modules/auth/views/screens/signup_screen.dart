import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getitgouser/modules/auth/controllers/auth_controller.dart';
import 'package:getitgouser/modules/home/view/home_view.dart';

import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/dimensions.dart';
import 'package:getitgouser/shared/constants/font_family.dart';
import 'package:getitgouser/shared/helper/widgets/buttons.dart';

import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authcontroller = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formfieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                fontSize: kFont19,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  Get.offAll(const HomeView());
                  // registerAction();
                },

                //  loginAction,
                buttonTitle: 'Next',
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: Dimensions.pagePadding,
            child: SingleChildScrollView(
              child: Form(
                key: _formfieldKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Create Account'.tr,
                          textAlign: TextAlign.center,
                          style: kManropeBold.copyWith(
                            color: AppColors.blackColor,
                            fontSize: kFont17,
                            letterSpacing: -0.41,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 10,
                    ),
                    Text(
                      'Enter your name',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 120),
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: GoogleFonts.poppins()),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Enter your email',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 120),
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: GoogleFonts.poppins()),
                        )),
                    const SizedBox(height: Dimensions.padding16),
                    const SizedBox(height: Dimensions.padding16),
                    const SizedBox(height: Dimensions.padding12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerAction() async {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      try {
        final body = {
          "name": _nameController.value.text,
          "email": _emailController.value.text
        };
        await authcontroller.registerUser(body);
        Get.offAll(const HomeView());
      } on Exception catch (e) {
        e.printError();
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: "Mandatory",
        message: 'Please fill all details',
      ));
    }
  }
}
