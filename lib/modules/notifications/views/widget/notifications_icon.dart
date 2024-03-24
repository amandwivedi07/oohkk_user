// import 'package:flutter/material.dart';
// import 'package:flutter_boilerplate/modules/notifications/controllers/notifications_controller.dart';
// import 'package:flutter_boilerplate/modules/notifications/views/screen/notifications_screen.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// import '../../../../shared/constants/color.dart';
// import '../../../../shared/constants/string.dart';

// class NotificationsIcon extends StatefulWidget {
//   const NotificationsIcon({super.key});

//   @override
//   State<NotificationsIcon> createState() => _NotificationsIconState();
// }

// class _NotificationsIconState extends State<NotificationsIcon> {
//   final box = Hive.box('secureBox');
//   int? existingNotificationCount;

//   @override
//   void initState() {
//     super.initState();
//     updateCount();
//   }

//   updateCount() {
//     existingNotificationCount = box.get(HiveKeys.existingNotificationCount);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: NotificationController.get(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const SizedBox();
//           }
//           if (snapshot.hasData && snapshot.data != null) {
//             return IconButton(
//               onPressed: () async {
//                 await Get.to(
//                     () => NotificationsScreen(notifications: snapshot.data!));
//                 updateCount();
//               },
//               icon: Stack(
//                 children: <Widget>[
//                   const Icon(Icons.notifications),
//                   if (existingNotificationCount != null &&
//                       snapshot.data!.length > existingNotificationCount!)
//                     Positioned(
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: AppColors.buttonColor,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         constraints: const BoxConstraints(
//                           minWidth: 12,
//                           minHeight: 12,
//                         ),
//                         child: Text(
//                           '${snapshot.data!.length - existingNotificationCount!}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 8,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )
//                 ],
//               ),
//             );
//           }
//           return IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.notifications,
//               color: AppColors.grey,
//             ),
//           );
//         });
//   }
// }
