import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/dimensions.dart';
import 'package:getitgouser/shared/constants/font_family.dart';
import 'package:getitgouser/shared/helper/widgets/buttons.dart';
import 'package:hive/hive.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpgradeType {
  force,
  recommended,
}

class UpgradeAlert extends StatelessWidget {
  static int get lastPromptedRecommendation =>
      Hive.box('secureBox').get('lastPromptedRecommendation', defaultValue: 0);
  static set lastPromptedRecommendation(int value) {
    Hive.box('secureBox').put('lastPromptedRecommendation', value);
  }

  static void handleUpdate(int minRecommendedBuild, int obsoleteBuild,
      Map<String, dynamic> updateInfo) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 999999999;
    if (obsoleteBuild >= currentBuildNumber) {
      return _update(true, updateInfo);
    }
    if (minRecommendedBuild > currentBuildNumber &&
        lastPromptedRecommendation < minRecommendedBuild) {
      lastPromptedRecommendation = minRecommendedBuild;
      return _update(false, updateInfo);
    }
  }

  static void _update(bool force, Map<String, dynamic> updateInfo) {
    Get.dialog(
      UpgradeAlert(
          upgradeType: force ? UpgradeType.force : UpgradeType.recommended,
          updateInfo: updateInfo),
      barrierDismissible: !force,
    );

    if (Platform.isAndroid) {
      InAppUpdate.performImmediateUpdate();
    }
  }

  final UpgradeType upgradeType;
  final Map<String, dynamic> updateInfo;
  const UpgradeAlert(
      {Key? key,
      this.upgradeType = UpgradeType.recommended,
      required this.updateInfo})
      : super(key: key);
  bool get isForceUpdate => upgradeType == UpgradeType.force;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(!isForceUpdate),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: Dimensions.pagePadding,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.whiteColor),
            child: Material(
              color: AppColors.whiteColor,
              child: SizedBox(
                height: Get.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: !isForceUpdate,
                          child: GestureDetector(
                            onTap: (() {
                              Get.back();
                            }),
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.close,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                    Text(
                      'Update Available',
                      style: kManropeBold.copyWith(fontSize: 24),
                    ),
                    Text(
                      'Version ${updateInfo['version']}',
                      style: kManropeBold.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int index = 0;
                              index < updateInfo['changes'].length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${index + 1}. ${updateInfo['changes'][index]}',
                                style: kManropeBold.copyWith(
                                    fontSize: 14, color: AppColors.greyColor),
                              ),
                            ),
                        ],
                      )),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      buttonTitle: 'Update Now',
                      onPressed: () {
                        if (Platform.isIOS) {
                          if (updateInfo['iosUrl'] != null) {
                            launchUrl(Uri.parse(updateInfo['iosUrl']),
                                mode: LaunchMode.externalApplication);
                          } else {
                            Get.back();
                          }
                        } else {
                          launchUrl(Uri.parse(updateInfo['androidUrl']),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: Get.height / 6,
              ),
              Lottie.asset(
                'assets/lotties/blue-rocket.json',
                alignment: Alignment.center,
                width: 180,
                animate: true,
                repeat: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
