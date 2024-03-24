import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OnBoardingWidget extends StatelessWidget {
  final String imageAssetpath;
  final int currentPage;
  final String onboardingText;
  final String onboardDescrption;

  PageController controller;
  OnBoardingWidget({
    Key? key,
    required this.currentPage,
    required this.imageAssetpath,
    required this.onboardingText,
    required this.onboardDescrption,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: Get.height / 2,
                  width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     fit: BoxFit.fill,
                  //     image: AssetImage(
                  //         // currentPage == 0
                  //         //     ? AppImages.bgOnboard1
                  //         //     : AppImages.bgOnboard2,
                  //         ),
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 5.55),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.224,
                      // ),
                      Expanded(
                        child: Image.asset(
                          imageAssetpath,
                          fit: BoxFit.fill,
                          // height: Get.height / 3.15,
                          // width: Get.width,

                          // height: 298,
                          // width: 320,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 25,
              ),
              Text(
                onboardingText,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  onboardDescrption,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
