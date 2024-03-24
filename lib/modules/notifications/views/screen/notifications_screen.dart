// import 'package:flutter/material.dart';
// import 'package:flutter_boilerplate/modules/notifications/controllers/notifications_controller.dart';
// import 'package:flutter_boilerplate/shared/constants/constant.dart';
// import 'package:flutter_boilerplate/shared/constants/extensions.dart';
// import 'package:flutter_boilerplate/widgets/placeholder_widget.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// import '../../../../shared/constants/enums.dart';
// import '../../model/notification_model.dart';

// class NotificationsScreen extends StatelessWidget {
//   final List<NotificationModel> notifications;
//   const NotificationsScreen({super.key, required this.notifications});

//   @override
//   Widget build(BuildContext context) {
//     final box = Hive.box('secureBox');

//     box.put(HiveKeys.existingNotificationCount, notifications.length);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Notifications'.tr),
//         leading: IconButton(
//           onPressed: Get.back,
//           icon: const Icon(
//             Icons.arrow_back,
//             color: AppColors.blackColor,
//           ),
//         ),
//         backgroundColor: AppColors.whiteColor,
//       ),
//       body: SafeArea(
//         child: Padding(
//             padding: Dimensions.pagePadding,
//             child: notifications.isEmpty
//                 ? PlaceHolderWidget(
//                     title: 'No notifications available'.tr,
//                     placeHolderType: PlaceHolderType.data)
//                 : ListView.builder(
//                     itemCount: notifications.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         elevation: 5,
//                         shape: Dimensions.smallRoundedBorder,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 0.0),
//                           child: ListTile(
//                             onTap: () {
//                               NotificationController.handleTapAction(
//                                   notifications[index].data?.toJson());
//                             },
//                             leading: const Icon(
//                               Icons.notifications,
//                               color: AppColors.buttonColor,
//                             ),
//                             contentPadding: const EdgeInsets.all(12),
//                             title: Text(
//                                 '${notifications[index].notification.title} At ${notifications[index].updatedAt.dateTimeToHumanReadable()}'),
//                             subtitle:
//                                 Text(notifications[index].notification.body),
//                             trailing: notifications[index].data?.route != null
//                                 ? const Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     color: AppColors.blackColor,
//                                   )
//                                 : null,
//                           ),
//                         ),
//                       );
//                     })),
//       ),
//     );
//   }
// }
