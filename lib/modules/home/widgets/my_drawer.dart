import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getitgouser/main.dart';
import 'package:getitgouser/shared/constants/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppColors.kPrimaryColor,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                scaffoldKey.currentState?.closeDrawer();
              },
            ),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ListTile(
                  horizontalTitleGap: 8,
                  contentPadding: const EdgeInsets.all(4),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.whiteColor,
                    radius: 22,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text('Abc Xyz'),
                  titleTextStyle: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  subtitle: const Text('+919123456789'),
                  subtitleTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(height: 5),
            const Divider(thickness: 15, color: Color(0xff53B6FF)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 22,
                      child: Icon(
                        CupertinoIcons.checkmark_shield_fill,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'Safety',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    horizontalTitleGap: 8,
                  ),
                  const Divider(
                    indent: 5,
                    thickness: 2,
                    endIndent: 9,
                    height: 2,
                    color: Colors.white,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 22,
                      child: Icon(
                        Icons.history,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'My Rides',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    horizontalTitleGap: 8,
                  ),
                  const Divider(
                    indent: 5,
                    thickness: 2,
                    endIndent: 9,
                    height: 2,
                    color: Colors.white,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 22,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    horizontalTitleGap: 8,
                  ),
                  const Divider(
                    indent: 5,
                    thickness: 2,
                    endIndent: 9,
                    height: 2,
                    color: Colors.white,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 22,
                      child: Icon(
                        Icons.contact_emergency_outlined,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'Emergency Contacts',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    horizontalTitleGap: 8,
                  ),
                  const Divider(
                    indent: 5,
                    thickness: 2,
                    endIndent: 9,
                    height: 2,
                    color: Colors.white,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 22,
                      child: Icon(
                        Icons.info_rounded,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'About App',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    horizontalTitleGap: 8,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
