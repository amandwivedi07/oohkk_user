import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:getitgouser/modules/auth/views/screens/login_screen.dart';
import 'package:getitgouser/modules/onboarding/views/widgets/onboarding_widget.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/helper/widgets/buttons.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding-view';
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: pages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    3,
                    (position) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: _currentPage == position ? 7 : 7,
                          width: _currentPage == position ? 26 : 7,
                          decoration: BoxDecoration(
                              color: _currentPage == position
                                  ? AppColors.kPrimaryColor
                                  : AppColors.borderColor,
                              borderRadius: BorderRadius.circular(8)),
                        ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  buttonTitle: 'Continue',

                  // height: Get.height / 16,

                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  onPressed: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    if (_currentPage == 2) {
                      Get.offAll(() => const LoginScreen());
                    }
                  }),
            ),
            SizedBox(
              height: Get.height / 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account ?',
                  style: TextStyle(
                    fontFamily: 'Mabry-Pro',
                    fontSize: 17,
                    fontWeight: FontWeight.w500, // Medium style
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))
              ],
            ),
            SizedBox(
              height: Get.height / 40,
            ),
          ],
        ),
      ),
    );
  }

  late List<Widget> pages = [
    OnBoardingWidget(
      controller: _controller,
      currentPage: 0,
      imageAssetpath: 'AppImages.onboard12',
      onboardingText: 'Books in 15 minutes',
      onboardDescrption:
          'We read the best books, highlight key ideas and insights, create summaries and visual narratives for you',
    ),
    OnBoardingWidget(
      controller: _controller,
      currentPage: 1,
      imageAssetpath: 'AppImages.onboard2',
      onboardingText: "Read, listen and \n watch anywhere",
      onboardDescrption:
          "You can read, listen and watch at the same time without the Internet connection",
    ),
    OnBoardingWidget(
      controller: _controller,
      currentPage: 2,
      imageAssetpath: 'AppImages.onboard3',
      onboardingText: 'Personal \n reading plan',
      onboardDescrption:
          'Set your reading goals and accept a personalized challenge',
    ),
  ];
}
