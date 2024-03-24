import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:getitgouser/main.dart';

class DrawerAndSearchHome extends StatelessWidget {
  final Function(String)? onChanged;
  const DrawerAndSearchHome({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  // final searchController = TextEditingController();

  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(
            Icons.menu,
            size: 32,
          ),
        ),
      ],
    );
  }
}
